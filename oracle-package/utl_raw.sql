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