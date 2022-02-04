
create schema UTL_URL;

CREATE OR REPLACE FUNCTION UTL_URL.escape(url IN TEXT, escape_reserved_chars IN BOOL DEFAULT FALSE, url_charset IN TEXT DEFAULT 'UTF8')
RETURNS TEXT
LANGUAGE plpgsql
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
declare
  L_TMP            TEXT DEFAULT '';
  L_BAD            TEXT DEFAULT ' >%}\~];?@&<#{|^[`/:=$+''"';
  l_reserved_chars TEXT DEFAULT ';/?:@&=+$[]';
  L_CHAR           TEXT;
BEGIN
  IF (url IS NULL) THEN
    RETURN NULL;
  END IF;

  if not escape_reserved_chars then
    L_BAD := translate(L_BAD, l_reserved_chars, '');
  end if;

  FOR I IN 1..LENGTH(url) LOOP
    L_CHAR := SUBSTR(url, I, 1);
    IF (INSTR(L_BAD, L_CHAR) > 0 or ascii(L_CHAR) > 255) THEN
      L_TMP := L_TMP || regexp_replace(upper(REPLACE(convert_TO(L_CHAR, url_charset)::TEXT,'\x','')),'(.{2})',
                                       '%\1','g');
    ELSE
      L_TMP := L_TMP || L_CHAR;
    END IF;
  END LOOP;
  RETURN L_TMP;
END; $$;
/
 
CREATE OR REPLACE FUNCTION UTL_URL.unescape(url IN TEXT, url_charset IN TEXT DEFAULT 'UTF8')
RETURNS TEXT
LANGUAGE sql
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
  select CONVERT_FROM(string_agg(CASE
                                   WHEN LENGTH(A) = 3 THEN
                                     REPLACE(A, '%','\x')::bytea
                                   ELSE
                                     A :: bytea
                                 END, '' :: bytea), url_charset) 
    from (select a
            from (select (regexp_matches(url, '(%..|.)', 'g')) [ 1 ] a ) ) A;
$$;
/

--test:
--select utl_url.escape('https://www.darkathena.top/archives/我开博了',TRUE,url_charset=>'GBK') from dual;
--select utl_url.escape('https://www.darkathena.top/archives/我开博了',url_charset=>'GBK') from dual;
--select utl_url.escape('https://www.darkathena.top/archives/我开博了',url_charset=>'UTF8') from dual;
--select utl_url.unescape('https://www.darkathena.top/archives/%CE%D2%BF%AA%B2%A9%C1%CB','GBK') from dual;
--select utl_url.unescape('https://www.darkathena.top/archives/%E6%88%91%E5%BC%80%E5%8D%9A%E4%BA%86','UTF8') from dual;

