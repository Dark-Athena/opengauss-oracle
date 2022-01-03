CREATE OR REPLACE FUNCTION pg_catalog.cosh(numeric)
returns numeric
LANGUAGE sql
as $$
  select (exp($1)+exp(-$1))/2 $$;
/