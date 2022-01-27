CREATE OR REPLACE FUNCTION pg_catalog.soundex(text)
returns TEXT
LANGUAGE sql
as $$
  select rpad(regexp_replace(string_agg(x, ''), '(\w)\1{1,}', '\1'),4,'0')
            from (select case
                        when rownum = 1 then
                            UPPER(c)
                        when c in('b', 'f', 'p', 'v') then
                            '1'
                        when c in('c', 'g', 'j', 'k', 'q', 's', 'x', 'z') then
                            '2'
                        when c in('d', 't') then
                            '3'
                        when c in('l') then
                            '4'
                        when c in('m', 'n') then
                            '5'
                        when c in('r') then
                            '6'
                        end x
                    from (select unnest(string_to_array(lower($1), null) ) c ) ) $$;
  
/