CREATE OR REPLACE FUNCTION pg_catalog.round_ties_to_even(numeric)
RETURNS numeric
LANGUAGE sql
IMMUTABLE STRICT NOT FENCED NOT SHIPPABLE COST 1
AS $$
  select case
           when $1 - pg_catalog.trunc($1, 0) = 0.5
                     and mod(pg_catalog.trunc($1, 0), 2) = 0 then
             $1 - 0.5
           else
             pg_catalog.round($1, 0) end$$; 
/