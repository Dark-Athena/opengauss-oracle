create or replace function pg_catalog.remainder(numeric,numeric)
returns numeric 
LANGUAGE sql 
as $$ select $1-$2*round($1/$2) $$;