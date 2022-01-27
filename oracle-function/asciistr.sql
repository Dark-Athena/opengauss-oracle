--带了个常见形式的u
CREATE OR REPLACE FUNCTION pg_catalog.asciistr(text)
RETURNS text
LANGUAGE sql
NOT FENCED NOT SHIPPABLE
AS $$
select string_agg( (case when ascii(s)<=255 then s else 
'\u'||(to_hex(ascii(s))::text) end ),'')
  from (select unnest(string_to_array($1, null) ) s);
 $$;
/