create aggregate any_value(anyelement) (
    sfunc = first_transition,
    stype = anyelement
);
/