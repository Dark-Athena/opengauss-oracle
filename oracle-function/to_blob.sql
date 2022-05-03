create or replace function pg_catalog.to_blob(raw) 
returns blob
LANGUAGE sql
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
SELECT $1::blob;
 $$;
/