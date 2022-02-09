create or replace function pg_catalog.round_ties_to_even(n NUMERIC,places int4 DEFAULT 0)
RETURNS numeric
LANGUAGE plpgsql
IMMUTABLE STRICT NOT FENCED NOT SHIPPABLE COST 1
AS $$
declare
l_ret numeric;
l_dif numeric;
begin
l_ret := round(n,places);
l_dif := l_ret-n;
if abs(l_dif)*(10^places) = 0.5 then
if not (l_ret * (10^places)) % 2 = 0 then
l_ret := round(n-l_dif,places);
end if;
end if;
return l_ret;
end;
$$;
/