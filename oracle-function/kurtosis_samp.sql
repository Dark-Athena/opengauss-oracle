CREATE OR REPLACE FUNCTION pg_catalog.kurtosis_samp_final_func(results numeric [ ])
RETURNS numeric
LANGUAGE plpgsql
COST 111 IMMUTABLE
AS $$
DECLARE
  av   numeric;
  stp  numeric;
  ct   numeric;
  avsp numeric;
begin
  select avg(s) :: numeric, power(stddev(s), 4) :: numeric, count(s) :: numeric into av, stp, ct
    from (select unnest(results) s );
  select sum(power(s - av, 4)) into avsp
    from (select unnest(results) s );
  return ct * (ct + 1) * avsp / ((ct - 1) * (ct - 2) * (ct - 3) * stp) -
       3 * power((ct - 1), 2) / ((ct - 2) * (ct - 3));
end; $$;
/

CREATE AGGREGATE pg_catalog.kurtosis_samp(numeric)
        (
          sfunc = array_append,
          stype = numeric[],
          FINALFUNC = pg_catalog.kurtosis_samp_final_func
        );