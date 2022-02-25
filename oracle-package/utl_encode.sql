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
l_result raw DEFAULT ''::raw;
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
l_result raw DEFAULT ''::raw;
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


create or replace function UTL_ENCODE.uuencode(r   in raw,
                    type       in int1 default 1::int1,
                    filename   in text default 'uuencode.txt',
                    permission in text default '0')
 RETURNS raw
 LANGUAGE plpgsql
 IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
DECLARE
/*Oracle自带函数有BUG(doc id 2197134.1),未遵循uuencode标准,官方不建议使用
    而本函数按uuencode标准生成 -- DarkAthena 2022-02-14*/
l_result text DEFAULT ''::text;
l_pos int4 DEFAULT 1;
l_3_bytes text DEFAULT ''::text;
l_new_4_chr text DEFAULT ''::text;
l_full_str text DEFAULT ''::text;
l_line_num int4 DEFAULT 1;
l_line_str text DEFAULT ''::text;
l_line_len int4 DEFAULT 60::int4;
begin
if type not in (1,2,3,4) THEN
RAISE  'input type error!';
end if;
loop
l_3_bytes:=substring(r from l_pos*6-5 for 6);
if length(l_3_bytes)=0 or l_3_bytes is null THEN
exit;
elsif length(l_3_bytes)!=6 THEN
l_3_bytes:=rpad(l_3_bytes,6,'0');
end if;
select 
chr(SUBSTRING(a from 1 for 6)::int +32)||
chr(SUBSTRING(a from 7 for 6)::int+32)||
chr(SUBSTRING(a from 13 for 6)::int+32)||
chr(SUBSTRING(a from 19 for 6)::int+32) into l_new_4_chr
from 
(select to_number(l_3_bytes,'xxxxxx')::int::bit(24) a);
l_full_str:=l_full_str||l_new_4_chr;
l_pos:=l_pos+1;
end loop;
dbms_output.put_line(l_full_str);
loop
l_line_str:=substring(l_full_str from l_line_num*(l_line_len)-(l_line_len-1) for l_line_len);
if length(l_line_str)=0 or l_line_str is null  then 
exit;
end if;
l_result:=l_result||chr((length(l_line_str))/4*3+32)||l_line_str||chr(13)||chr(10);
l_line_num:=l_line_num+1;
end loop;
l_result:=replace(l_result,' ','`');

if type in (1,2) then 
l_result:='begin '||permission||' '||filename||chr(13)||chr(10)||l_result;
end if;
if type in (1,4) then 
l_result:=l_result||'`'||chr(13)||chr(10)||'end';
end if;

return rawtohex(replace(l_result,'\','\\'))::raw;
end;
$$;
/


create or replace function UTL_ENCODE.uudecode(r   in raw)
 RETURNS raw
 LANGUAGE plpgsql
 IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
DECLARE
/*Oracle自带函数有BUG(doc id 2197134.1),未遵循uuencode标准,官方不建议使用
    而本函数按uuencode标准解析-- DarkAthena 2022-02-14*/
l_ori_str text DEFAULT ''::text;
l_result text DEFAULT ''::text;
l_pos int4 DEFAULT 1;
l_3_bytes text DEFAULT ''::text;
l_new_4_chr text DEFAULT ''::text;
l_full_str text DEFAULT ''::text;
l_line_num int4 DEFAULT 1;
l_line_str text DEFAULT ''::text;
l_line_len int4 DEFAULT 60::int4;
begin
SELECT convert_from(rawsend(r),
(select pg_encoding_to_char(encoding) as encoding from pg_database where datname=current_database())) 
into l_ori_str;

l_ori_str:=replace(l_ori_str,chr(13)||chr(10)||'`'||chr(13)||chr(10)||'end','');

if substr(l_ori_str,1,5) ='begin' THEN
l_ori_str:=substr(l_ori_str,instr(l_ori_str,chr(10))+1);
end if ;

LOOP
l_line_str:=substr(l_ori_str,2+(l_line_len+3)*(l_line_num-1),l_line_len);
if length(l_line_str)=0 or l_line_str is null then exit;
end if;
l_full_str:=l_full_str||l_line_str;
l_line_num:=l_line_num+1;
end loop;

l_full_str:=replace(l_full_str,'`',' ');

LOOP
l_new_4_chr:=substring(l_full_str from 1+4*(l_pos-1) for 4);
if length(l_new_4_chr)=0 or l_new_4_chr is null then exit;
end if;
select  to_char((listagg(substring( (ascii(a)-32)::bit(8) from 3 for 6)::text) within group(order by 1))::bit(24)::int,'fmxxxxxx')::raw
into l_3_bytes
from (select unnest(string_to_array(l_new_4_chr,null)) a);
l_result:=l_result||l_3_bytes;
l_pos:=l_pos+1;
end LOOP;

l_result:=regexp_replace(l_result,'(00)+$','');
return l_result::raw;
end;
$$;
/       

/*
--uuencode
select  utl_raw.cast_to_varchar2(UTL_ENCODE.uuencode(utl_raw.cast_to_raw('今天天气真的好abcdefg4156787fsd~！@#￥%——+(\)*:;[]{】,。？、、、gdfhoqsr')::raw));

select utl_raw.cast_to_raw($q$begin 0 uuencode.txt
MY+N*Y:2IY:2IYK"4YYR?YYJ$Y:6]86)C9&5F9S0Q-38W.#=F<V1^[[R!0"/O
MOZ4EXH"4XH"4*RA<*2HZ.UM=>^.`D2SC@(+OO)_C@('C@('C@(%G9&9H;W%S
#<@``
`
end$q$);

--uudecode
select utl_raw.cast_to_varchar2(UTL_ENCODE.uudecode('626567696E2030207575656E636F64652E7478740D0A4D592B4E2A593A3249593A3249594B22345959523F59594A24593A365D3836294339263546395330512D3338572E233D463C56315E5B5B522130222F4F0D0A4D4F5A344558482234584822342A52413C2A32485A2E554D3D3E5E2E604432534340282B4F4F295F43402827434028274340282547392639483B5725530D0A233C4060600D0A600D0A656E64'::raw));

*/