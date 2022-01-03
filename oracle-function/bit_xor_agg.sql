CREATE OR REPLACE FUNCTION pg_catalog.bit_xor_agg_state_func(results int, val numeric)
RETURNS int
LANGUAGE sql
COST 50 IMMUTABLE
AS $$
  select (case when results is null then val else  results # val end)::int;
$$;

CREATE AGGREGATE pg_catalog.bit_xor_agg( numeric )
        (
          sfunc = pg_catalog.bit_xor_agg_state_func,
          stype = int
        );  