CREATE OR REPLACE FUNCTION pg_catalog.numtoyminterval(numeric,text)
returns interval
LANGUAGE sql
as $$
  select NUMTODSINTERVAL($1,$2) $$;
/