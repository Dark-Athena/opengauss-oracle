CREATE OR REPLACE FUNCTION dump(anyelement)
 RETURNS text
 LANGUAGE plpgsql
 IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $function$
        declare
            v_typsend   text;
            v_type text;
            v_bytea     bytea;
            v_hexstr    TEXT;
            v_hexbyte   TEXT;
            v_tmp       TEXT;
            i           INT;
            v_len       INT;
        begin
	        select typsend,typname into v_typsend,v_type from pg_type 
             where oid= pg_typeof($1);
            if v_type='blob' then 
            v_typsend:='rawsend';
            elsif v_type='unknown' then
            v_typsend:='textsend';            
            end if;
            EXECUTE 'select '||v_typsend||'(:1)' into v_bytea using $1;
            SELECT length(v_bytea) into v_len;
           raise notice '%',v_bytea;
           raise notice '%',v_len;
          
            v_hexstr := 'Len=' || v_len || ' ';
            v_tmp := ',';
            FOR i in 1..v_len LOOP
                select to_hex(get_byte(v_bytea, i-1)) into v_hexbyte;
                if i = v_len then
                    v_tmp := '';
                end if;
                v_hexstr := v_hexstr || v_hexbyte || v_tmp;
            END LOOP;
            RETURN v_hexstr;
        END;
        $function$;

       
CREATE OR REPLACE FUNCTION dump(unknown)
 RETURNS text
 LANGUAGE plpgsql
 IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $function$
        declare
            v_typsend   text;
            v_type text;
            v_bytea     bytea;
            v_hexstr    TEXT;
            v_hexbyte   TEXT;
            v_tmp       TEXT;
            i           INT;
            v_len       INT;
        begin
            v_typsend:='textsend';            
            EXECUTE 'select '||v_typsend||'(:1)' into v_bytea using $1;
            SELECT length(v_bytea) into v_len;
            v_hexstr := 'Len=' || v_len || ' ';
            v_tmp := ',';
            FOR i in 1..v_len LOOP
                select to_hex(get_byte(v_bytea, i-1)) into v_hexbyte;
                if i = v_len then
                    v_tmp := '';
                end if;
                v_hexstr := v_hexstr || v_hexbyte || v_tmp;
            END LOOP;
            RETURN v_hexstr;
        END;
        $function$;

--test       
--select dump(1234);
--select dump(1234.5678);
--select dump('abcd');
--select dump('abcd'::VARCHAR);
--select dump('FFFF'::RAW);
--select dump('FFFF'::BLOB);
--select dump(DATE'2022-01-23');
--select dump(current_timestamp);
