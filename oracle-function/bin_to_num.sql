CREATE OR REPLACE FUNCTION pg_catalog.bin_to_num(VARIADIC integer [])
RETURNS int
LANGUAGE sql
NOT FENCED NOT SHIPPABLE
AS $$
select int8(replace(array_to_string($1,','),',')::varbit)::int;
$$;