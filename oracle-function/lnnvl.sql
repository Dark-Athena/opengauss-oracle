create or replace function pg_catalog.lnnvl(bool)
returns BOOl 
LANGUAGE sql 
as $$ select case when $1 is null or $1=false then true else false end $$;
/