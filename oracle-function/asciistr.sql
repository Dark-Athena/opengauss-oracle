CREATE OR REPLACE FUNCTION pg_catalog.asciistr(text)
 RETURNS text
 LANGUAGE sql
 NOT FENCED NOT SHIPPABLE
AS $$
select string_agg( (case when ascii(s)<=255 and s!='\' then s else 
'\'||lpad((to_hex(ascii(s))::text),4,'0') end ),'')
  from (select unnest(string_to_array($1, null) ) s);
 $$;
/