CREATE OR REPLACE FUNCTION pg_catalog.bitxor(bigint, bigint)
 RETURNS bigint
 LANGUAGE sql
AS $$ select $1 # $2 $$;
/  