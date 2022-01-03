CREATE OR REPLACE FUNCTION pg_catalog.unistr( str text )
RETURNS text
LANGUAGE plpgsql
NOT FENCED NOT SHIPPABLE
AS $$
DECLARE
  r text;
begin
  EXECUTE  'select e'''||str||'''' into r;
  return r;
end; $$;
/