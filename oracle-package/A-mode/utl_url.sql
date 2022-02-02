CREATE OR REPLACE package pg_catalog.UTL_URL
as
  function escape(url IN TEXT, escape_reserved_chars IN BOOL DEFAULT FALSE, url_charset IN TEXT DEFAULT 'UTF8')
  RETURN TEXT;

  FUNCTION unescape(url IN TEXT, url_charset IN TEXT DEFAULT 'UTF8')
  RETURN TEXT;
end UTL_URL;
/

CREATE OR REPLACE package body pg_catalog.UTL_URL
as
  function escape(url IN TEXT, escape_reserved_chars IN BOOL DEFAULT FALSE, url_charset IN TEXT DEFAULT 'UTF8')
  RETURN TEXT
  IMMUTABLE NOT FENCED NOT SHIPPABLE
  AS
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

    FOR I IN 1.. LENGTH(url) LOOP
      L_CHAR := SUBSTR(url, I, 1);
      IF (INSTR(L_BAD, L_CHAR) > 0 or ascii(L_CHAR) > 255) THEN
        L_TMP := L_TMP || regexp_replace(upper(REPLACE(convert_TO(L_CHAR, url_charset)::TEXT,'\x','')),'(.{2})',
                                       '%\1','g');
      ELSE
        L_TMP := L_TMP || L_CHAR;
      END IF;
    END LOOP;
    RETURN L_TMP;
  END;

  FUNCTION unescape(url IN TEXT, url_charset IN TEXT DEFAULT 'UTF8')
  RETURN TEXT
  IMMUTABLE NOT FENCED NOT SHIPPABLE
  AS
    l_return text;
  begin
    select CONVERT_FROM(string_agg(CASE
                                     WHEN LENGTH(A) = 3 THEN
                                       decode(REPLACE(A, '%'), 'HEX')
                                     ELSE
                                       A :: bytea
                                   END, '' :: bytea), url_charset) into l_return
      from (select a
              from (select (regexp_matches(url, '(%..|.)', 'g')) [ 1 ] a ) ) A;
    return l_return;
  end;
end UTL_URL;
/
