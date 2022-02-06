create schema UTL_RAW;

CREATE OR REPLACE FUNCTION UTL_RAW.cast_to_varchar2(r IN raw)
RETURNS text
LANGUAGE SQL
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
SELECT convert_from(rawsend(r),(select pg_encoding_to_char(encoding) as encoding from pg_database where datname=current_database()));
 $$;
/

CREATE OR REPLACE FUNCTION UTL_RAW.cast_to_raw(c IN text)
RETURNS raw
LANGUAGE SQL
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
SELECT rawout(c::BYTEA)::text::raw;
 $$;
/

CREATE OR REPLACE FUNCTION UTL_RAW.concat(
r1  IN raw DEFAULT ''::raw,
r2  IN raw DEFAULT ''::raw,
r3  IN raw DEFAULT ''::raw,
r4  IN raw DEFAULT ''::raw,
r5  IN raw DEFAULT ''::raw,
r6  IN raw DEFAULT ''::raw,
r7  IN raw DEFAULT ''::raw,
r8  IN raw DEFAULT ''::raw,
r9  IN raw DEFAULT ''::raw,
r10 IN raw DEFAULT ''::raw,
r11 IN raw DEFAULT ''::raw,
r12 IN raw DEFAULT ''::raw
)
RETURNS raw
LANGUAGE SQL
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
--SELECT rawcat(rawcat(rawcat(rawcat(rawcat(rawcat(rawcat(rawcat(rawcat(rawcat(rawcat(r1,r2),r3),r4),r5),r6),r7),r8),r9),r10),r11),r12);
SELECT (r1||r2||r3||r4||r5||r6||r7||r8||r9||r10||r11||r12)::raw;
 $$;
/


CREATE OR REPLACE FUNCTION UTL_RAW.length(r IN raw)
RETURNS int4
LANGUAGE SQL
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
SELECT (pg_catalog.length(r)/2)::int4;
 $$;
/

CREATE OR REPLACE FUNCTION UTL_RAW.substr(r IN raw,pos in int4,len in int4 DEFAULT null)
RETURNS raw
LANGUAGE SQL
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
SELECT (case when len is not null then  substring(r from pos*2-1 for len*2) else substring(r from pos*2-1) end )::raw ;
 $$;
/



CREATE OR REPLACE FUNCTION UTL_RAW.transliterate(
r IN raw,
to_set in raw DEFAULT ''::raw,
from_set in raw DEFAULT ''::raw,
pad IN raw DEFAULT '00'::raw )
RETURNS raw
LANGUAGE plpgsql
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
DECLARE
l_tmp text;
begin
if pg_catalog.length(pad)/2>1 then 
RAISE WARNING 'Error in utl_raw.transliterate: pad must be 1 byte or null!';
end if;
l_tmp:=regexp_replace(r::TEXT, '(..)','=\1', 'g');
for rec in (
select fs_str,nvl(ts_str,pad::TEXT) ts_str from 
(select row_number() over() fs_pos,fs_str from (
select (regexp_matches(from_set::TEXT, '(..)', 'g')) [ 1 ] fs_str)) f
left join 
(select row_number() over() ts_pos,ts_str from (
select (regexp_matches(to_set::TEXT, '(..)', 'g')) [ 1 ] ts_str)) t
on f.fs_pos=t.ts_pos
) loop
l_tmp:=replace(l_tmp,'='||rec.fs_str,rec.ts_str);
end loop;
return replace(l_tmp,'=','')::raw;
end;
$$;
/


CREATE OR REPLACE FUNCTION UTL_RAW.translate(r IN raw,from_set in raw,to_set in raw )
RETURNS raw
LANGUAGE sql
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
select UTL_RAW.transliterate(r,to_set,from_set,''::raw);
$$;
/


CREATE OR REPLACE FUNCTION UTL_RAW.copies(
r IN raw,
n IN bigint)
RETURNS raw
LANGUAGE plpgsql
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
DECLARE
l_result raw DEFAULT ''::raw;
begin
if n<0 then 
RAISE WARNING 'n must be equal or greater than 1!';
end if;
if pg_catalog.length(r)/2<1 then 
RAISE WARNING 'r is missing, null and/or 0 length!';
end if;
for i in 1..n LOOP
l_result:=l_result||r;
end loop;
return l_result;
end;
$$;
/