create schema UTL_BYTEA;

CREATE OR REPLACE FUNCTION UTL_BYTEA.cast_to_varchar2(r IN BYTEA)
RETURNS text
LANGUAGE SQL
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
SELECT convert_from(r,pg_client_encoding());
 $$;
/
--select UTL_BYTEA.cast_to_raw('测试');

CREATE OR REPLACE FUNCTION UTL_BYTEA.cast_to_raw(c IN text)
RETURNS BYTEA
LANGUAGE SQL
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
SELECT c::BYTEA;
 $$;
/
--select UTL_BYTEA.cast_to_varchar2('测试'::bytea);

CREATE OR REPLACE FUNCTION UTL_BYTEA.concat(
r1  IN BYTEA DEFAULT ''::BYTEA,
r2  IN BYTEA DEFAULT ''::BYTEA,
r3  IN BYTEA DEFAULT ''::BYTEA,
r4  IN BYTEA DEFAULT ''::BYTEA,
r5  IN BYTEA DEFAULT ''::BYTEA,
r6  IN BYTEA DEFAULT ''::BYTEA,
r7  IN BYTEA DEFAULT ''::BYTEA,
r8  IN BYTEA DEFAULT ''::BYTEA,
r9  IN BYTEA DEFAULT ''::BYTEA,
r10 IN BYTEA DEFAULT ''::BYTEA,
r11 IN BYTEA DEFAULT ''::BYTEA,
r12 IN BYTEA DEFAULT ''::BYTEA
)
RETURNS BYTEA
LANGUAGE SQL
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
SELECT r1||r2||r3||r4||r5||r6||r7||r8||r9||r10||r11||r12;
 $$;
/
--select UTL_BYTEA.concat('测'::bytea,'试'::bytea);


CREATE OR REPLACE FUNCTION UTL_BYTEA.length(r IN bytea)
RETURNS int4
LANGUAGE SQL
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
SELECT pg_catalog.length(r);
 $$;
/
--select UTL_BYTEA.length('测'::bytea);

CREATE OR REPLACE FUNCTION UTL_BYTEA.substr(r IN bytea,pos in int4,len in int4 DEFAULT null)
RETURNS bytea
LANGUAGE plpgSQL
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
DECLARE 
BEGIN
if pos>0 then 
return (case when len is not null 
             then  substring(r from pos for len) 
             else substring(r from pos) end );
ELSE
if -pos<len THEN
RAISE 'Error in UTL_BYTEA.substr: out of index!';
end if;
return (case when len is not null 
             then  pg_catalog.substr(r , pos , len) 
             else pg_catalog.substr(r , pos) end ) ;
end if;
end;   
 $$;
/
--select UTL_BYTEA.substr('测'::bytea,1,1);

CREATE OR REPLACE FUNCTION UTL_BYTEA.transliterate(
r IN bytea,
to_set in bytea DEFAULT ''::bytea,
from_set in bytea DEFAULT ''::bytea,
pad IN bytea DEFAULT '\000'::bytea )
RETURNS bytea
LANGUAGE plpgsql
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
DECLARE
l_tmp text;
begin
if length(pad)>1 then 
RAISE  'Error in UTL_BYTEA.transliterate: pad must be 1 byte or null!';
end if;
l_tmp:=regexp_replace(REPLACE(r::TEXT,'\x',''), '(..)','=\1', 'g');
for rec in (
select fs_str,nvl(ts_str,REPLACE(pad::TEXT,'\x','')) ts_str from 
(select row_number() over() fs_pos,fs_str from (
select (regexp_matches(REPLACE(from_set::TEXT,'\x',''), '(..)', 'g')) [ 1 ] fs_str)) f
left join 
(select row_number() over() ts_pos,ts_str from (
select (regexp_matches(REPLACE(to_set::TEXT,'\x',''), '(..)', 'g')) [ 1 ] ts_str)) t
on f.fs_pos=t.ts_pos
) loop
l_tmp:=replace(l_tmp,'='||rec.fs_str,rec.ts_str);
end loop;
return ('\x'||replace(l_tmp,'=',''))::bytea;
end;
$$;
/
--select UTL_BYTEA.transliterate('测试'::bytea,decode('e6b5','HEX'),decode('e8af95','HEX'),'\000'::bytea)

CREATE OR REPLACE FUNCTION UTL_BYTEA.translate(r IN bytea,from_set in bytea,to_set in bytea )
RETURNS bytea
LANGUAGE sql
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
select UTL_BYTEA.transliterate(r,to_set,from_set,''::bytea);
$$;
/
--select UTL_BYTEA.translate('测试'::bytea,decode('e6b58b','HEX'),decode('e8','HEX'))

CREATE OR REPLACE FUNCTION UTL_BYTEA.copies(
r IN bytea,
n IN int8)
RETURNS bytea
LANGUAGE plpgsql
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
DECLARE
l_result bytea DEFAULT ''::bytea;
begin
if n<0 then 
RAISE  'n must be equal or greater than 1!';
end if;
if pg_catalog.length(r)<1 then 
RAISE  'r is missing, null and/or 0 length!';
end if;
for i in 1..n LOOP
l_result:=l_result||r;
end loop;
return l_result;
end;
$$;
/
--  select UTL_BYTEA.copies('\xFF'::bytea,10)   ;

CREATE OR REPLACE FUNCTION UTL_BYTEA.overlay(
overlay_str IN bytea,
target      IN bytea,
pos         IN int4 DEFAULT 1,
len         IN int4 DEFAULT NULL,
pad         IN bytea            DEFAULT '\x00'::bytea)
RETURNS bytea
LANGUAGE plpgsql
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
DECLARE
l_result bytea;
l_overlay_str bytea;
l_len int4;
l_pad bytea;
l_pos_over_str bytea DEFAULT ''::bytea;
begin
l_overlay_str:=overlay_str;
if length(pad)>1 THEN
l_pad:=substring(pad from 1 for 1);
ELSE
l_pad:=pad;
end if;
if len is null then 
l_len:=length(overlay_str);
else  
l_len:=len;
end if;
if length(l_overlay_str)>l_len THEN
l_overlay_str:=substring(l_overlay_str from 1 for l_len);
elsif length(l_overlay_str)<l_len THEN
l_overlay_str:=l_overlay_str||UTL_BYTEA.copies(l_pad,l_len-length(overlay_str) );
end if;
if pos>length(target) THEN
l_pos_over_str:=UTL_BYTEA.copies(pad,pos-length(target)-1);
end if;
l_result:=substring(target from 1 for pos-1)||l_pos_over_str||l_overlay_str||substring(target from pos+l_len);
return l_result;
end;
$$;
/
--select UTL_BYTEA.overlay('\xFFFFFF'::bytea, '\x112233445566778899'::bytea,2,5,'\xAA'::bytea) ;

CREATE OR REPLACE FUNCTION UTL_BYTEA.xrange(
start_byte IN bytea,
end_byte IN bytea)
RETURNS bytea
LANGUAGE plpgsql
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
DECLARE
l_result bytea DEFAULT ''::bytea;
l_start_int int4;
l_end_int int4;
l_tmp BYTEA;
begin
if pg_catalog.length(start_byte)!=1 or pg_catalog.length(end_byte)!=1  then 
RAISE  'start_byte and end_byte must be single byte!';
end if;
l_start_int:=get_byte(start_byte,0);
l_end_int:=get_byte(end_byte,0);
 LOOP
l_tmp:=('\x'||lpad(to_hex(CASE WHEN l_start_int >255 THEN l_start_int-256 ELSE l_start_int END ),2,'0'))::bytea;
l_result:=l_result||l_tmp;
if l_tmp=UTL_BYTEA.substr(end_byte,1,1) then exit;
end if;
l_start_int:=l_start_int+1;
end loop;
return l_result;
end;
$$;
/
--   select UTL_BYTEA.xrange('\x00'::bytea,'\x11'::bytea);
--   select UTL_BYTEA.xrange('\xFA'::bytea,'\x06'::bytea);

CREATE OR REPLACE FUNCTION UTL_BYTEA.reverse(
r IN bytea)
RETURNS bytea
LANGUAGE plpgsql
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
DECLARE
l_result bytea DEFAULT ''::bytea;
begin
for i in reverse pg_catalog.length(r)..1   LOOP
l_result:=l_result||substring(r from i for 1);
end loop;
return l_result;
end;
$$;
/
--   select UTL_BYTEA.reverse('\x112233445566778899'::bytea);

CREATE OR REPLACE FUNCTION UTL_BYTEA.compare(
                   r1  IN bytea,
                   r2  IN bytea,
                   pad IN bytea DEFAULT '\x00'::bytea)
RETURNS int4
LANGUAGE plpgsql
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
DECLARE
l_result int4 DEFAULT 0;
l_r1 bytea DEFAULT ''::bytea;
l_r2 bytea DEFAULT ''::bytea;
begin
for i in 1..greatest(pg_catalog.length(r1),pg_catalog.length(r2))   LOOP
l_r1:=substring(r1 from i for 1);
l_r2:=substring(r2 from i for 1);
if l_r1!=l_r2 THEN
if l_r1=''::bytea then 
l_r1:=pad;
end if;
if l_r2=''::bytea then 
l_r2:=pad;
end if;
if l_r1!=l_r2 then 
l_result:=i;
EXIT;
end if;
end if;
end loop;
return l_result;
end;
$$;
/
-- select UTL_BYTEA.compare('\x1122334455660000'::bytea,'\x112233445566'::bytea);

CREATE OR REPLACE FUNCTION UTL_BYTEA.convert(r IN bytea,
                   to_charset   IN text,
                   from_charset IN text)
RETURNS bytea
LANGUAGE sql
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
select convert_to(convert_from(r,from_charset),to_charset);
$$;
/
-- select UTL_BYTEA.convert('测试'::bytea,'GBK','UTF8');

CREATE OR REPLACE FUNCTION UTL_BYTEA.bit_and(r1 bytea, r2 bytea)
 RETURNS bytea
 LANGUAGE plpgsql
 IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
DECLARE
l_result bytea DEFAULT ''::bytea;
l_r1 bytea;
l_r2 bytea;
l_r1_len int8;
l_r2_len int8;
begin
l_r1_len:=pg_catalog.length(r1);
l_r2_len:=pg_catalog.length(r2);
l_r1:=r1;
l_r2:=r2;
if l_r1_len>l_r2_len then
l_r2:=UTL_BYTEA.copies('\x00'::bytea,l_r1_len-l_r2_len)||l_r2;
elsif l_r1_len<l_r2_len then 
l_r1:=UTL_BYTEA.copies('\x00'::bytea,l_r2_len-l_r1_len)||l_r2;
end if;
l_result:=UTL_BYTEA.copies('\x00'::bytea,GREATEST(l_r1_len,l_r2_len));
for i in 0..bit_length(l_r1)-1 LOOP
l_result:=set_bit(l_result,i,get_bit(l_r1,i)&get_bit(l_r2,i));
end loop;
return l_result;
end;
$$;
/
-- select UTL_BYTEA.bit_and('\x1234ffdd'::bytea,'\x1234ffee'::bytea)='\x1234ffcc'::bytea;

CREATE OR REPLACE FUNCTION UTL_BYTEA.bit_or(r1 bytea, r2 bytea)
 RETURNS bytea
 LANGUAGE plpgsql
 IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
DECLARE
l_result bytea DEFAULT ''::bytea;
l_r1 bytea;
l_r2 bytea;
l_r1_len int8;
l_r2_len int8;
begin
l_r1_len:=pg_catalog.length(r1);
l_r2_len:=pg_catalog.length(r2);
l_r1:=r1;
l_r2:=r2;
if l_r1_len>l_r2_len then
l_r2:=UTL_BYTEA.copies('\x00'::bytea,l_r1_len-l_r2_len)||l_r2;
elsif l_r1_len<l_r2_len then 
l_r1:=UTL_BYTEA.copies('\x00'::bytea,l_r2_len-l_r1_len)||l_r2;
end if;
l_result:=UTL_BYTEA.copies('\x00'::bytea,GREATEST(l_r1_len,l_r2_len));
for i in 0..bit_length(l_r1)-1 LOOP
l_result:=set_bit(l_result,i,get_bit(l_r1,i)|get_bit(l_r2,i));
end loop;
return l_result;
end;
$$;
/
-- select UTL_BYTEA.bit_and('\x1234ffdd'::bytea,'\x1234ffee'::bytea)='\x1234ffcc'::bytea;
               
CREATE OR REPLACE FUNCTION UTL_BYTEA.bit_xor(r1 bytea, r2 bytea)
 RETURNS bytea
 LANGUAGE plpgsql
 IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
DECLARE
l_result bytea DEFAULT ''::bytea;
l_r1 bytea;
l_r2 bytea;
l_r1_len int8;
l_r2_len int8;
begin
l_r1_len:=pg_catalog.length(r1);
l_r2_len:=pg_catalog.length(r2);
l_r1:=r1;
l_r2:=r2;
if l_r1_len>l_r2_len then
l_r2:=UTL_BYTEA.copies('\x00'::bytea,l_r1_len-l_r2_len)||l_r2;
elsif l_r1_len<l_r2_len then 
l_r1:=UTL_BYTEA.copies('\x00'::bytea,l_r2_len-l_r1_len)||l_r2;
end if;
l_result:=UTL_BYTEA.copies('\x00'::bytea,GREATEST(l_r1_len,l_r2_len));
for i in 0..bit_length(l_r1)-1 LOOP
l_result:=set_bit(l_result,i,get_bit(l_r1,i)#get_bit(l_r2,i));
end loop;
return l_result;
end;
$$;
/
-- select UTL_BYTEA.bit_xor('\x1234ffdd'::bytea,'\x1234ffee'::bytea)='\x00000033'::bytea;


CREATE OR REPLACE FUNCTION UTL_BYTEA.bit_complement(r bytea)
 RETURNS bytea
 LANGUAGE plpgsql
 IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
DECLARE
l_result bytea DEFAULT ''::bytea;
begin
l_result:=r;
for i in 0..bit_length(r)-1 LOOP
dbms_output.put_line(get_bit(r,i));
l_result:=set_bit(l_result,i,case when get_bit(r,i)=1 then 0 else 1 end );
end loop;
return l_result;
end;
$$;
/
-- select UTL_BYTEA.bit_complement('\x11'::bytea)='\xEE'::bytea