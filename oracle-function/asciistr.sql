CREATE OR REPLACE FUNCTION pg_catalog.asciistr(text)
 RETURNS text
 LANGUAGE sql
 NOT FENCED NOT SHIPPABLE
AS $$
select string_agg( '\'||lpad((case when ascii(s)<=255 and s!='\' then s else 
(to_hex(ascii(s))::text) end ),4,'0'),'')
  from (select unnest(string_to_array($1, null) ) s);
 $$;
/