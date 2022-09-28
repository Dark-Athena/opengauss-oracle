CREATE OR REPLACE FUNCTION pg_catalog.dump(anyelement,numeric default 10,int4 default null,int4 default null)
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
                    v_oid       int;
                    v_charset text :='';
                    v_typcategory text;
                begin
                    select typsend,typname,oid ,typcategory
                    into v_typsend,v_type,v_oid ,v_typcategory
                    from pg_type
                    where oid= pg_typeof($1);
                    if v_type='blob' then
                    v_typsend:='rawsend';
                    elsif v_type='unknown' then
                    v_typsend:='textsend';
                    end if;
                    if v_typcategory='S' then
                    v_bytea:=$1::text::bytea;
                    else 
                    EXECUTE 'select '||v_typsend||'(:1)' into v_bytea using $1;
                    end if;
                if $3 is not null and $4 is not null then
                v_bytea:=substr(v_bytea,$3,$4);
                elsif $3 is not null and $4 is null then
                v_bytea:=substr(v_bytea,$3);
                end if;
                    SELECT length(v_bytea) into v_len;
                    $2:=floor($2);
                if $2>1000 and v_typcategory='S' then
                select pg_encoding_to_char(encoding) into v_charset
                from pg_database where datname=current_database();
                v_charset:=' CharacterSet='||v_charset;
                $2:=$2-1000;
                end if;
                    v_hexstr := 'Typ='||v_oid||' Len=' || v_len || v_charset||': ';
                    v_tmp := ',';
                if $2>=16 or $2<0 then
                    FOR i in 1..v_len LOOP
                        select to_hex(get_byte(v_bytea, i-1)) into v_hexbyte;
                        if i = v_len then
                            v_tmp := '';
                        end if;
                        v_hexstr := v_hexstr || v_hexbyte || v_tmp;
                    END LOOP;
                elsif  $2<>8 or $2 is null then
                FOR i in 1..v_len LOOP
                        select get_byte(v_bytea, i-1) into v_hexbyte;
                        if i = v_len then
                            v_tmp := '';
                        end if;
                        v_hexstr := v_hexstr || v_hexbyte || v_tmp;
                    END LOOP;
                elsif   $2=8 then
                raise 'unsupport Octal!';
                end if;
                    RETURN v_hexstr;
                END;
                $function$;
