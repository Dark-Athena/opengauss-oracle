create schema UTL_RAW;

CREATE OR REPLACE FUNCTION UTL_RAW.cast_to_varchar2(r IN BYTEA)
RETURNS text
LANGUAGE SQL
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
SELECT convert_from(r,pg_client_encoding());
 $$;
/

CREATE OR REPLACE FUNCTION UTL_RAW.cast_to_raw(c IN text)
RETURNS BYTEA
LANGUAGE SQL
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
SELECT c::BYTEA;
 $$;
/

CREATE OR REPLACE FUNCTION UTL_RAW.concat(
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

CREATE OR REPLACE FUNCTION UTL_RAW.length(r IN bytea)
RETURNS int4
LANGUAGE SQL
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
SELECT pg_catalog.length(r);
 $$;
/

CREATE OR REPLACE FUNCTION UTL_RAW.substr(r IN bytea,pos in int4,len in int4 DEFAULT null)
RETURNS bytea
LANGUAGE SQL
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
SELECT case when len is not null then  substring(r from pos for len) else substring(r from pos) end ;
 $$;
/

CREATE OR REPLACE FUNCTION UTL_RAW.transliterate(
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
RAISE WARNING 'Error in utl_raw.transliterate: pad must be 1 byte or null!';
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

CREATE OR REPLACE FUNCTION UTL_RAW.translate(r IN bytea,from_set in bytea,to_set in bytea )
RETURNS bytea
LANGUAGE sql
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
select UTL_RAW.transliterate(r,to_set,from_set,''::bytea);
$$;
/

CREATE OR REPLACE FUNCTION UTL_RAW.copies(
r IN bytea,
n IN int)
RETURNS bytea
LANGUAGE plpgsql
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
DECLARE
l_result bytea DEFAULT ''::bytea;
begin
if n<0 then 
RAISE WARNING 'n must be equal or greater than 1!';
end if;
if pg_catalog.length(r)<1 then 
RAISE WARNING 'r is missing, null and/or 0 length!';
end if;
for i in 1..n LOOP
l_result:=l_result||r;
end loop;
return l_result;
end;
$$;
/

CREATE OR REPLACE FUNCTION UTL_RAW.overlay(
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
l_overlay_str:=l_overlay_str||UTL_RAW.copies(l_pad,l_len-length(overlay_str) );
end if;
l_result:=substring(target from 1 for pos-1)||l_overlay_str||substring(target from pos+l_len);
return l_result;
end;
$$;
/

CREATE OR REPLACE FUNCTION UTL_RAW.xrange(
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
begin
if pg_catalog.length(start_byte)!=1 or pg_catalog.length(end_byte)!=1  then 
RAISE WARNING 'start_byte and end_byte must be single byte!';
end if;
l_start_int:=get_byte(start_byte,0);
l_end_int:=get_byte(end_byte,0);
for i in 0..l_end_int-l_start_int LOOP
l_result:=l_result||('\x'||lpad(to_hex(l_start_int+i),2,'0'))::bytea;
end loop;
return l_result;
end;
$$;
/

CREATE OR REPLACE FUNCTION UTL_RAW.reverse(
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

CREATE OR REPLACE FUNCTION UTL_RAW.compare(
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

CREATE OR REPLACE FUNCTION UTL_RAW.convert(r IN bytea,
                   to_charset   IN text,
                   from_charset IN text)
RETURNS bytea
LANGUAGE sql
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
select convert_to(convert_from(r,from_charset),to_charset);
$$;
/
