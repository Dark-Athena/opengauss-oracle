create aggregate pg_catalog.any_value(anyelement) (
    sfunc = first_transition,
    stype = anyelement
);
/