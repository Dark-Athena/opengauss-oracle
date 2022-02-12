create schema UTL_ENCODE;

CREATE OR REPLACE FUNCTION UTL_ENCODE.base64_encode(r IN raw)
RETURNS raw
LANGUAGE SQL
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
SELECT rawtohex(encode(rawsend(r),'base64'))::RAW;
 $$;
/

CREATE OR REPLACE FUNCTION UTL_ENCODE.base64_decode(r IN raw)
RETURNS raw
LANGUAGE SQL
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
SELECT rawout(decode(encode(rawsend(r),'escape'),'base64')::BYTEA)::TEXT::RAW;
 $$;
/
/

--test
--SELECT  UTL_ENCODE.base64_encode(rawtohex('测试')::raw) ='3572574C364B2B56'::RAW
--SELECT UTL_ENCODE.base64_decode('3572574C364B2B56')= 'E6B58BE8AF95'::raw


CREATE OR REPLACE FUNCTION utl_encode.text_encode(buf  in text,
                       encode_charset in text default 'UTF8'::text,
                       encoding       in int4 default 2::int4)
 RETURNS text
 LANGUAGE plpgsql
 IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
DECLARE
l_result text DEFAULT ''::text;
begin
if encoding=1 THEN
l_result:= encode(CONVERT_TO(buf,encode_charset), 'base64') ;
elsif encoding=2 THEN
select string_agg( (case when ascii(s)<=255 AND s!='=' then s else 
        regexp_replace(upper(REPLACE(convert_TO(s, encode_charset)::TEXT,'\x','')),'(.{2})',
                                                '=\1','g') end ),'') into l_result
        from (select unnest(string_to_array(buf, null) ) s);
else
raise 'invaild encoding!';
end if;
return l_result;
end;
$$;
/     

--select utl_encode.text_encode('往1234\as df=AB',encode_charset => 'GBK')='=CD=F91234\as df=3DAB'
--select utl_encode.text_encode('往1234\as df=AB',encode_charset => 'GBK',encoding => 1) ='zfkxMjM0XGFzIGRmPUFC'

                              
CREATE OR REPLACE FUNCTION utl_encode.text_decode(buf  in text,
                       encode_charset in text default 'UTF8'::text,
                       encoding       in int4 default 2::int4)
 RETURNS text
 LANGUAGE plpgsql
 IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
DECLARE
l_result text DEFAULT ''::text;
begin
if encoding=1 THEN
l_result:= CONVERT_FROM(decode(buf, 'base64'),encode_charset) ;
elsif encoding=2 THEN
select CONVERT_FROM(string_agg(CASE
                                 WHEN LENGTH(A) = 3 THEN
                                   REPLACE(A, '=', '\x') :: bytea
                                 when a = '\' then
                                   '\\' :: bytea
                                 ELSE
                                   A :: bytea
                               END, '' :: bytea), encode_charset) into l_result
  from (select a
          from (select (regexp_matches(buf, '(=..|.)', 'g')) [ 1 ] a ) ) A;
else
raise 'invaild encoding!';
end if;
return l_result;
end;
$$;
/                    


--select utl_encode.text_decode('=CD=F91234\as df=3DAB',encode_charset => 'GBK',encoding => 2)   ='往1234\as df=AB'
--select utl_encode.text_decode('zfkxMjM0XGFzIGRmPUFC',encode_charset => 'GBK',encoding => 1)   ='往1234\as df=AB'



CREATE OR REPLACE FUNCTION utl_encode.quoted_printable_encode(r in raw)
 RETURNS raw
 LANGUAGE plpgsql
 IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
DECLARE
l_result text DEFAULT ''::raw;
l_def_charset text DEFAULT 'utf8';
begin
select pg_encoding_to_char(encoding) into l_def_charset from pg_database where datname=current_database();
select rawtohex(string_agg((case
                              when ascii(s) <= 255  AND s not in('=', '\') then
                                s
                              when s = '\' then
                                '\\'
                              else
                                regexp_replace(upper(REPLACE(convert_TO(s, l_def_charset) :: TEXT, '\x', '')), '(.{2})', '=\1', 'g')
                            end), '')) :: raw into l_result
  from (select unnest(string_to_array(convert_from(rawsend(r), l_def_charset), null) ) s );
return l_result;
end;
$$;
/       

--select utl_raw.cast_to_raw('往1234\as df=AB')='E5BE80313233345C61732064663D4142';
--select utl_encode.quoted_printable_encode( 'E5BE80313233345C61732064663D4142') ='3D45353D42453D3830313233345C61732064663D33444142';
--select utl_raw.cast_to_varchar2('3D45353D42453D3830313233345C61732064663D33444142')='=E5=BE=801234\as df=3DAB';



CREATE OR REPLACE FUNCTION utl_encode.quoted_printable_decode(r in raw)
 RETURNS raw
 LANGUAGE plpgsql
 IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
DECLARE
l_result text DEFAULT ''::raw;
l_def_charset text DEFAULT 'utf8';
begin
select pg_encoding_to_char(encoding) into l_def_charset from pg_database where datname=current_database();
select rawout(string_agg(CASE
                                 WHEN LENGTH(A) = 3 THEN
                                   REPLACE(A, '=', '\x') :: bytea
                                 when a = '\' then
                                   '\\' :: bytea
                                 ELSE
                                   A :: bytea
                               END, '' :: bytea))::text::raw into l_result
  from (select a
          from (select (regexp_matches(convert_from(rawsend(r), l_def_charset), '(=..|.)', 'g')) [ 1 ] a ) ) A;
return l_result;
end;
$$;
/       

--select utl_raw.cast_to_raw('=E5=BE=801234\as df=3DAB') ='3D45353D42453D3830313233345C61732064663D33444142';
--select utl_encode.quoted_printable_decode( '3D45353D42453D3830313233345C61732064663D33444142') ='E5BE80313233345C61732064663D4142';
--select utl_raw.cast_to_varchar2('E5BE80313233345C61732064663D4142')='往1234\as df=AB'


CREATE OR REPLACE FUNCTION utl_encode.mimeheader_encode(buf  in text,
                       encode_charset in text default 'UTF8'::text,
                       encoding       in int4 default 2::int4)
 RETURNS text
 LANGUAGE plpgsql
 IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
DECLARE
l_result text DEFAULT ''::text;
begin
if encoding=1 THEN
l_result:= encode(CONVERT_TO(buf,encode_charset), 'base64') ;
elsif encoding=2 THEN
select string_agg( (case when ascii(s)<=255 AND s NOT IN ('=',' ','?') then s else 
        regexp_replace(upper(REPLACE(convert_TO(s, encode_charset)::TEXT,'\x','')),'(.{2})',
                                                '=\1','g') end ),'') into l_result
        from (select unnest(string_to_array(buf, null) ) s);
else
raise 'invaild encoding!';
end if;
return '=?'||encode_charset||'?'||CASE WHEN encoding=2 THEN 'Q' ELSE 'B' END||'?'||l_result||'?=';
end;
$$;
/


--SELECT UTL_ENCODE.MIMEHEADER_ENCODE('What is the date 王 =20 / \?',encode_charset =>'GBK' )='=?GBK?Q?What=20is=20the=20date=20=CD=F5=20=3D20=20/=20\=3F?=' ;
--SELECT UTL_ENCODE.MIMEHEADER_ENCODE('What is the date 王 =20 / \?',encoding => 2 ) ='=?UTF8?Q?What=20is=20the=20date=20=E7=8E=8B=20=3D20=20/=20\=3F?=';
--SELECT UTL_ENCODE.MIMEHEADER_ENCODE('What is the date 王 =20 / \?',encode_charset =>'UTF8',encoding => 1 ) ='=?UTF8?B?V2hhdCBpcyB0aGUgZGF0ZSDnjosgPTIwIC8gXD8=?=';

CREATE OR REPLACE FUNCTION utl_encode.mimeheader_decode(buf in text)
 RETURNS text
 LANGUAGE plpgsql
 IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
DECLARE
l_encode_charset text;
l_encoding text;
l_result text DEFAULT ''::text;
l_buf text;
begin
l_encode_charset:=REGEXP_SUBSTR(buf,'(?<=\=\?)(.+?)(?=\?.\?)');
l_encoding:=REGEXP_SUBSTR(buf,'(?<=\?)(.?)(?=\?)');
l_buf:=REGEXP_SUBSTR(buf,'(?<=\?.\?)(.+?)(?=\?\=)');
if l_encoding='B' THEN
l_result:= CONVERT_FROM(decode(l_buf, 'base64'),l_encode_charset) ;
elsif l_encoding='Q' THEN
select CONVERT_FROM(string_agg(CASE
                                 WHEN LENGTH(A) = 3 THEN
                                   REPLACE(A, '=', '\x') :: bytea
                                 when a = '\' then
                                   '\\' :: bytea
                                 ELSE
                                   A :: bytea
                               END, '' :: bytea), l_encode_charset) into l_result
  from (select a
          from (select (regexp_matches(l_buf, '(=..|.)', 'g')) [ 1 ] a ) ) A;
else
raise 'invaild encoding!';
end if;
return l_result;
end;
$$;
/    

--SELECT UTL_ENCODE.mimeheader_decode('=?UTF-8?Q?What=20is=20the=20date=20=E7=8E=8B=20=3D20=20/=20\=3F?=')='What is the date 王 =20 / \?';
--SELECT UTL_ENCODE.mimeheader_decode('=?UTF8?B?V2hhdCBpcyB0aGUgZGF0ZSDnjosgPTIwIC8gXD8=?=')='What is the date 王 =20 / \?'
