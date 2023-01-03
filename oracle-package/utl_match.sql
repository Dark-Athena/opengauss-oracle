create schema utl_match;

CREATE OR REPLACE FUNCTION utl_match.edit_distance   
  (s1   IN text,  
   s2   IN text)  
  RETURNS                INT4  
  LANGUAGE plpgsql STRICT IMMUTABLE
AS $$
DECLARE
  v_len_s1    NUMBER := NVL (LENGTH (s1), 0);  
  v_len_s2    NUMBER := NVL (LENGTH (s2), 0);  
  v_cl        int[];  
  v_cc        int[];  
  v_cost                NUMBER := 0;  
BEGIN  
  IF v_len_s1 = 0 THEN  
    RETURN v_len_s2;  
  ELSIF v_len_s2 = 0 THEN  
    RETURN v_len_s1;  
  ELSE  
    FOR j IN 0 .. v_len_s2 LOOP  
      v_cl(j) := j;  
    END LOOP;  
    FOR i IN 1.. v_len_s1 LOOP  
      v_cc(0) := i;  
      FOR j IN 1 .. v_len_s2 LOOP  
        IF SUBSTR (s1, i, 1) =  
           SUBSTR (s2, j, 1)  
        THEN v_cost := 0;  
        ELSE v_cost := 1;  
        END IF;  
        v_cc(j) := LEAST (v_cc(j-1) + 1,  
                                    v_cl(j) + 1,  
                                    v_cl(j-1) + v_cost);  
      END LOOP;  
      FOR j IN 0 .. v_len_s2  LOOP  
        v_cl(j) := v_cc(j);  
      END LOOP;  
    END LOOP;  
  END IF;  
  RETURN v_cc(v_len_s2);  
END;  
$$;

CREATE OR REPLACE FUNCTION utl_match.edit_distance_similarity( s1 VARCHAR2, s2 VARCHAR2 )
  RETURNS INT4
   LANGUAGE plpgsql STRICT IMMUTABLE
AS $$
  DECLARE
     v_len_s1 int; 
     v_len_s2 int; 
     v_len_max INT;
  BEGIN
    v_len_s1 := LENGTH(s1);
    v_len_s2 := LENGTH(s2);
    IF v_len_s1 > v_len_s2 THEN
       v_len_max := v_len_s1;
    ELSE
       v_len_max := v_len_s2;
    END IF;
    RETURN ROUND((1 - edit_distance(s1, s2) / v_len_max) * 100);
  END;
$$;


select utl_match.edit_distance('peter zhang','pete zhaxg') from dual;
select utl_match.edit_distance_similarity('peter zhang','pete zhaxg') from dual;
