CREATE OR REPLACE FUNCTION pg_catalog.standard_hash(expr text, method text)
returns text
LANGUAGE SQL
AS $$
  SELECT encode(digest(expr, method), 'hex');
$$;
/