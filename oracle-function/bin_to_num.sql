CREATE OR REPLACE FUNCTION pg_catalog.bin_to_num(VARIADIC bin integer [ ])
RETURNS int
LANGUAGE plpgsql
NOT FENCED NOT SHIPPABLE
AS $$
DECLARE
  r bigint;
begin
  EXECUTE  'select B'''||array_to_string(BIN,'')||'''::INT' into r;
  return r;
end; $$;
/