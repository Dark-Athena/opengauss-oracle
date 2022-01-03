CREATE OR REPLACE FUNCTION pg_catalog.systimestamp()
RETURNS timestampwith time zone LANGUAGE sql AS
                        $$select current_timestamp $$; 
/