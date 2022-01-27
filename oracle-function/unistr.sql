CREATE OR REPLACE FUNCTION pg_catalog.unistr(text)
RETURNS text
LANGUAGE plpgsql
NOT FENCED NOT SHIPPABLE
AS $$
DECLARE
  r text;
begin
  EXECUTE  'select e'''||$1||'''' into r;
  return r;
end; $$;
/