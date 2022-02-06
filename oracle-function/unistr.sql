CREATE OR REPLACE FUNCTION pg_catalog.unistr(text)
 RETURNS text
 LANGUAGE plpgsql
 NOT FENCED NOT SHIPPABLE
AS $$
DECLARE
  r text;
begin
IF LENGTH($1)>0 THEN 
  EXECUTE left(REPLACE(REPLACE('select '||'U&'''||quote_nullable($1)||'''','U&''E''','U&'''),'\\','\'),-1) into r;
ELSe r:=str;
END IF;
  return r;
end; $$;
/

--select unistr('\80e1\6843');
--防sql注入
--select unistr('\80e1\6843'';select ''1  ');