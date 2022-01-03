CREATE OR REPLACE FUNCTION pg_catalog.skewness_pop_final_func(results numeric [ ])
RETURNS numeric
LANGUAGE plpgsql
COST 111 IMMUTABLE
AS $$
DECLARE
  av   numeric;
  stp  numeric;
  ct   numeric;
  avsp numeric;
  skew_s numeric;
begin
  select avg(s) :: numeric, power(stddev(s), 3) :: numeric, count(s) :: numeric into av, stp, ct
    from (select unnest(results) s );
  select sum(power(s - av, 3)) into avsp
    from (select unnest(results) s );
  skew_s := ct * (avsp / ((ct - 1) * (ct - 2) * stp));
  return skew_s*(ct-2)/sqrt(ct*(ct-1));
end; $$;
/

CREATE AGGREGATE pg_catalog.skewness_pop(numeric)
        (
          sfunc = array_append,
          stype = numeric[],
          FINALFUNC = pg_catalog.skewness_pop_final_func
        );
