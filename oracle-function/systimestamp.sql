CREATE OR REPLACE FUNCTION pg_catalog.systimestamp()
RETURNS timestamp with time zone LANGUAGE sql AS
                        $$select current_timestamp $$; 
/