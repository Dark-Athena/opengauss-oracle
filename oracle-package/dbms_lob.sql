--DROP SCHEMA DBMS_LOB CASCADE;

create schema DBMS_LOB;

CREATE OR REPLACE FUNCTION DBMS_LOB.file_readonly 
returns int4
LANGUAGE sql
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
SELECT 0::int4;
 $$;
/

CREATE OR REPLACE FUNCTION DBMS_LOB.lob_readonly 
returns int4
LANGUAGE sql
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
SELECT 0::int4;
 $$;
/
CREATE OR REPLACE FUNCTION DBMS_LOB.lob_readwrite 
returns int4
LANGUAGE sql
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
SELECT 1::int4;
 $$;
/
CREATE OR REPLACE FUNCTION DBMS_LOB.lobmaxsize 
returns int4
LANGUAGE sql
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
--SELECT 18446744073709551615::int8; --只能int4
SELECT 2147483647::int4;
 $$;
/

CREATE OR REPLACE FUNCTION DBMS_LOB.getlength(lob_loc in BLOB)
RETURNS INT4
LANGUAGE SQL
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
SELECT pg_catalog.length(rawsend(lob_loc))::INT4;
 $$;
/
--select DBMS_LOB.getlength('AABBCCDD'::RAW::BLOB);

CREATE OR REPLACE FUNCTION DBMS_LOB.getlength(lob_loc in clob)
RETURNS INT4
LANGUAGE SQL
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
SELECT pg_catalog.length(lob_loc)::INT4;
 $$;
/
--select DBMS_LOB.getlength('AABBCCDD'::CLOB);

CREATE OR REPLACE PROCEDURE DBMS_LOB.open(lob_loc   IN OUT  BLOB,
                                 open_mode IN int) package
AS 
BEGIN
null;
end;
/ 

CREATE OR REPLACE PROCEDURE DBMS_LOB.open(lob_loc   IN OUT  CLOB,
                                 open_mode IN int) package
AS 
BEGIN
null;
end;
/ 

CREATE OR REPLACE PROCEDURE DBMS_LOB.freetemporary(lob_loc   IN OUT  BLOB) package
AS 
BEGIN
null;
end;
/ 
CREATE OR REPLACE PROCEDURE DBMS_LOB.freetemporary(lob_loc   IN OUT  cLOB) package
AS 
BEGIN
null;
end;
/ 

CREATE OR REPLACE FUNCTION DBMS_LOB.substr (lob_loc IN BLOB,
                  amount  IN int4 := 32767,
                  p_offset  IN int4 := 1)
returns RAW
LANGUAGE sql
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
SELECT rawout(pg_catalog.SUBSTR(rawsend(lob_loc),p_offset,amount))::text::raw;
 $$;
/
--select DBMS_LOB.substr('AABBCCDD'::RAW::BLOB,2,2);

CREATE OR REPLACE FUNCTION DBMS_LOB.substr (lob_loc IN CLOB,
                  amount  IN int4 := 32767,
                  p_offset  IN int4 := 1)
returns TEXT
LANGUAGE sql
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
SELECT pg_catalog.SUBSTR(lob_loc,p_offset,amount);
 $$;
/
--select DBMS_LOB.substr('AABBCCDD'::CLOB,2,2);



CREATE OR REPLACE FUNCTION DBMS_LOB.instr(lob_loc IN BLOB,
                               pattern IN RAW,
                               p_offset IN int4 := 1,
                               nth IN int4 := 1)
RETURNS integer 
LANGUAGE plpgsql STRICT IMMUTABLE
AS $$
DECLARE
    pos integer NOT NULL DEFAULT 0;
    occur_number integer NOT NULL DEFAULT 0;
    temp_str BYTEA;
    beg integer;
    i integer;
    length integer;
    ss_length integer;
    loc bytea;
BEGIN
 loc:=rawsend(lob_loc);
    IF nth <= 0 THEN
        RAISE 'argument ''%'' is out of range', occur_index
          USING ERRCODE = '22003';
    END IF;

    IF p_offset > 0 THEN
        beg := p_offset - 1;
        FOR i IN 1..nth LOOP
            temp_str := substring(loc FROM beg + 1);
            pos := position(RAWSEND(pattern) IN temp_str);
            IF pos = 0 THEN
                RETURN 0;
            END IF;
            beg := beg + pos;
        END LOOP;

        RETURN beg;
    ELSIF p_offset < 0 THEN
        ss_length := pg_catalog.length(RAWSEND(pattern));
        length := pg_catalog.length(loc);
        beg := length + 1 + p_offset;

        WHILE beg > 0 LOOP
            temp_str := substring(loc FROM beg FOR ss_length);
            IF RAWSEND(pattern) = temp_str THEN
                occur_number := occur_number + 1;
                IF occur_number = nth THEN
                    RETURN beg;
                END IF;
            END IF;

            beg := beg - 1;
        END LOOP;

        RETURN 0;
    ELSE
        RETURN 0;
    END IF;
END;
$$ ;
/
--select DBMS_LOB.instr('AABBCCDDBB'::RAW::BLOB,'BB'::RAW,1,1);
--select DBMS_LOB.instr('BBAABBCCDDBB'::RAW::BLOB,'BB'::RAW,2,2);



CREATE OR REPLACE FUNCTION DBMS_LOB.instr(lob_loc CLOB, pattern TEXT,
                      p_offset integer, nth integer)
RETURNS integer 
LANGUAGE plpgsql STRICT IMMUTABLE
AS $$
DECLARE
    pos integer NOT NULL DEFAULT 0;
    occur_number integer NOT NULL DEFAULT 0;
    temp_str TEXT;
    beg integer;
    i integer;
    length integer;
    ss_length integer; 
    loc text;
BEGIN
 loc:=lob_loc::TEXT;
    IF nth <= 0 THEN
        RAISE 'argument ''%'' is out of range', occur_index
          USING ERRCODE = '22003';
    END IF;

    IF p_offset > 0 THEN
        beg := p_offset - 1;
        FOR i IN 1..nth LOOP
            temp_str := substring(loc FROM beg + 1);
            pos := position(pattern IN temp_str);
            IF pos = 0 THEN
                RETURN 0;
            END IF;
            beg := beg + pos;
        END LOOP;

        RETURN beg;
    ELSIF p_offset < 0 THEN
        ss_length := char_length(pattern);
        length := char_length(loc);
        beg := length + 1 + p_offset;

        WHILE beg > 0 LOOP
            temp_str := substring(loc FROM beg FOR ss_length);
            IF pattern = temp_str THEN
                occur_number := occur_number + 1;
                IF occur_number = nth THEN
                    RETURN beg;
                END IF;
            END IF;

            beg := beg - 1;
        END LOOP;

        RETURN 0;
    ELSE
        RETURN 0;
    END IF;
END;
$$;
/
--select DBMS_LOB.instr('AABBCCDDBB','BB',1,1);
--select DBMS_LOB.instr('BBAABBCCDDBB'::CLOB,'BB',2,2);

CREATE or replace  PROCEDURE DBMS_LOB.createtemporary(lob_loc IN OUT   BLOB,
                            cache   IN            BOOLEAN,
                            dur     IN            INT4 := 10) package
AS 
BEGIN
null;
end;
/ 

CREATE or replace  PROCEDURE DBMS_LOB.createtemporary(lob_loc IN OUT   CLOB ,
                            cache   IN            BOOLEAN,
                            dur     IN            INT4 := 10) package
AS 
BEGIN
null;
end;
/
CREATE or replace  PROCEDURE DBMS_LOB.close(lob_loc IN OUT   BLOB) 
package
AS 
BEGIN
null;
end;
/
CREATE or replace  PROCEDURE DBMS_LOB.close(lob_loc IN OUT   CLOB)
package
AS 
BEGIN
null;
end;
/

CREATE or replace  PROCEDURE DBMS_LOB.append(dest_lob IN OUT  BLOB,
                   src_lob  IN            BLOB) package
AS
BEGIN
dest_lob:=rawout(rawsend(dest_lob)||rawsend(src_lob))::text::raw::blob;
END;
/

/*
DECLARE
a blob:='AABB'::RAW::BLOB;
BEGIN
DBMS_LOB.append(a,'CCDD'::RAW::BLOB);
RAISE NOTICE '%',a;
end;
*/

CREATE or replace  PROCEDURE DBMS_LOB.append(dest_lob IN OUT  CLOB,
                   src_lob  IN            CLOB ) package
AS
BEGIN
dest_lob:=(dest_lob::text||src_lob::text)::clob;
END;
/
/*
DECLARE
a clob:='AABB'::cLOB;
BEGIN
DBMS_LOB.append(a,'CCDD'::cLOB);
RAISE NOTICE '%',a;
end;
*/

CREATE OR REPLACE FUNCTION DBMS_LOB.compare(
                   lob_1    IN BLOB,
                   lob_2    IN BLOB,
                   amount   IN int4 := 2147483647,
                   offset_1 IN INTEGER := 1,
                   offset_2 IN INTEGER := 1)
RETURNS int4
LANGUAGE plpgsql
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
DECLARE
l_result int4 DEFAULT 0;
l_r1 bytea DEFAULT ''::bytea;
l_r2 bytea DEFAULT ''::bytea;
len_1 int4;
len_2 int4;
lob1_bytea bytea; 
lob2_bytea bytea;
begin
lob1_bytea:=substr(rawsend(lob_1),offset_1,least(amount,pg_catalog.length(rawsend(lob_1))-offset_1));
lob2_bytea:=substr(rawsend(lob_2),offset_2,least(amount,pg_catalog.length(rawsend(lob_2))-offset_2));

len_1:=pg_catalog.length(lob1_bytea);
len_2:=pg_catalog.length(lob2_bytea);

if len_1<len_2 then 
return -1;
elsif len_1>len_2 then
return 1;
end if;

for i in 1..greatest(len_1,len_2)   LOOP
l_r1:=pg_catalog.substr(lob1_bytea , i , 1);
l_r2:=pg_catalog.substr(lob2_bytea , i , 1);
if l_r1!=l_r2 THEN
l_result:=i;
EXIT;
end if;
end loop;
return l_result;
end;
$$;
/
--select DBMS_LOB.compare('E6B58BE8AF95'::blob,'E6B58BE8AF95'::blob,3,1,1);
--select DBMS_LOB.compare('E6B48BE8AF95'::blob,'E6B58BE8AF95'::blob,3,1,1);
--select DBMS_LOB.compare('E6'::blob,'E6B58BE8AF95'::blob,3,1,1);
--select DBMS_LOB.compare('E6B58BE8AF95'::blob,'E6B5'::blob,3,1,1);
 
CREATE OR REPLACE FUNCTION DBMS_LOB.compare(
                   lob_1    IN CLOB,
                   lob_2    IN CLOB,
                   amount   IN int4 := 2147483647,
                   offset_1 IN INTEGER := 1,
                   offset_2 IN INTEGER := 1)
RETURNS int4
LANGUAGE plpgsql
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
DECLARE
l_result int4 DEFAULT 0;
l_r1 text DEFAULT ''::text;
l_r2 text DEFAULT ''::text;
len_1 int4;
len_2 int4;
lob1_text text; 
lob2_text text;
begin
lob1_text:=substr(lob_1::text,offset_1,least(amount,pg_catalog.length(lob_1::text)-offset_1));
lob2_text:=substr(lob_2::text,offset_2,least(amount,pg_catalog.length(lob_2::text)-offset_2));

len_1:=pg_catalog.length(lob1_text);
len_2:=pg_catalog.length(lob2_text);

if len_1<len_2 then 
return -1;
elsif len_1>len_2 then
return 1;
end if;

for i in 1..greatest(len_1,len_2)   LOOP
l_r1:=pg_catalog.substr(lob1_text , i , 1);
l_r2:=pg_catalog.substr(lob2_text , i , 1);
if l_r1!=l_r2 THEN
l_result:=i;
EXIT;
end if;
end loop;
return l_result;
end;
$$;
/
--select DBMS_LOB.compare('E6B58BE8AF95'::clob,'E6B58BE8AF95'::clob,6,1,1);
--select DBMS_LOB.compare('E6B48BE8AF95'::clob,'E6B58BE8AF95'::clob,6,1,1);
--select DBMS_LOB.compare('E6'::clob,'E6B58BE8AF95'::clob,6,1,1);
--select DBMS_LOB.compare('E6B58BE8AF95'::clob,'E6B5'::clob,6,1,1);

CREATE or replace PROCEDURE DBMS_LOB.copy(dest_lob    IN OUT  BLOB,
                 src_lob     IN            BLOB,
                 amount      IN            INTEGER,
                 dest_offset IN            INTEGER := 1,
                 src_offset  IN            INTEGER := 1) package
AS
DECLARE
dest_bytea bytea;
end_bytea bytea DEFAULT ''::bytea;
null_bytea bytea DEFAULT '\x00'::bytea;
dest_bytea_length int4;
pad_bytea bytea DEFAULT ''::bytea;
BEGIN
dest_bytea:=rawsend(dest_lob);
dest_bytea_length:=pg_catalog.length(dest_bytea);
if dest_bytea_length>dest_offset+amount-1 then 
end_bytea:=substr(dest_bytea,dest_offset+amount);
end if;
if dest_bytea_length<dest_offset THEN
for i in 1..dest_offset-dest_bytea_length-1 LOOP
pad_bytea:=pad_bytea||null_bytea;
end loop;
end if;

dest_lob:=rawout(substr(dest_bytea,1,dest_offset-1)||pad_bytea||substr(rawsend(src_lob),src_offset,amount)||end_bytea)::text::raw::blob;
end;
/

/*
DECLARE
dest_lob blob;
begin
dest_lob:='E6B58BE8'::raw::blob;
DBMS_LOB.copy(dest_lob,'AABBCCDDEEFF'::raw::blob,6,6,1) ;
RAISE NOTICE '%',dest_lob;
end;
*/

CREATE or replace PROCEDURE DBMS_LOB.copy(dest_lob    IN OUT  CLOB,
                 src_lob     IN            CLOB,
                 amount      IN            INTEGER,
                 dest_offset IN            INTEGER := 1,
                 src_offset  IN            INTEGER := 1) package
AS
DECLARE
dest_text text;
end_text text DEFAULT ''::text;
null_text text DEFAULT ' '::text;
dest_text_length int4;
pad_text text DEFAULT ''::text;
BEGIN
dest_text:=dest_lob::text;
dest_text_length:=pg_catalog.length(dest_text);
if dest_text_length>dest_offset+amount-1 then 
end_text:=substr(dest_text,dest_offset+amount);
end if;
if dest_text_length<dest_offset THEN
for i in 1..dest_offset-dest_text_length-1 LOOP
pad_text:=pad_text||null_text;
end loop;
end if;

dest_lob:=(substr(dest_text,1,dest_offset-1)||pad_text||substr(src_lob::text,src_offset,amount)||end_text)::clob;
end;
/
/*
DECLARE
dest_lob clob;
begin
dest_lob:='E6B58BE8'::clob;
DBMS_LOB.copy(dest_lob,'AABBCCDDEEFF'::clob,10,10,1) ;
RAISE NOTICE '%',dest_lob;
end;
*/                 
CREATE or replace PROCEDURE DBMS_LOB.erase(lob_loc IN OUT   BLOB,
                  amount  IN OUT   INTEGER,
                  p_offset  IN      INTEGER := 1) package
AS
DECLARE
lob_length int4;
lob_bytea bytea;
null_bytea bytea DEFAULT '\x00'::bytea;
pad_bytea bytea DEFAULT ''::bytea;
end_bytea bytea;
begin
lob_bytea:=rawsend(lob_loc);
lob_length:=pg_catalog.length(lob_bytea);
if amount<lob_length-p_offset+1 then 
end_bytea:=substr(lob_bytea,p_offset+amount+1);
end if;
amount:=least(amount,lob_length-p_offset+1);
for i in 1..amount LOOP
pad_bytea:=pad_bytea||null_bytea;
end loop;
lob_loc:=rawout(pg_catalog.substr(lob_bytea,0,p_offset-1)||pad_bytea||end_bytea)::text::raw;
end;
/
/*
DECLARE
dest_lob blob;
begin
dest_lob:='E6B58BE8AF95'::raw::blob;
DBMS_LOB.erase(dest_lob,2,3);
RAISE NOTICE '%',dest_lob;
end;
*/

CREATE or replace PROCEDURE DBMS_LOB.erase(lob_loc IN OUT   CLOB,
                  amount  IN OUT   INTEGER,
                  p_offset  IN      INTEGER := 1) package
AS
DECLARE
lob_length int4;
lob_text text;
null_text text DEFAULT ' '::text;
pad_text text DEFAULT ''::text;
end_text text;
begin
lob_text:=lob_loc::text;
lob_length:=pg_catalog.length(lob_text);
if amount<lob_length-p_offset+1 then 
end_text:=substr(lob_text,p_offset+amount+1);
end if;
amount:=least(amount,lob_length-p_offset+1);
for i in 1..amount LOOP
pad_text:=pad_text||null_text;
end loop;
lob_loc:=(pg_catalog.substr(lob_text,0,p_offset-1)||pad_text||end_text)::clob;
end;
/
/*
DECLARE
dest_lob clob;
begin
dest_lob:='E6B58BE8AF95'::clob;
DBMS_LOB.erase(dest_lob,2,3);
RAISE NOTICE '%',dest_lob;
end;
*/

CREATE or replace PROCEDURE DBMS_LOB.read(lob_loc IN            BLOB,
                 amount  IN OUT  INTEGER,
                 p_offset  IN            INTEGER,
                 buffer  OUT           RAW) package
as
DECLARE
tmp_bytea bytea;
BEGIN
tmp_bytea:=pg_catalog.substr(rawsend(lob_loc),p_offset,amount);
if pg_catalog.length(tmp_bytea)=0 or tmp_bytea is null
then raise NO_DATA_FOUND;
end if;
buffer:=rawout(tmp_bytea)::text::raw;
amount:=pg_catalog.length(tmp_bytea);
end;
/
/*
DECLARE
dest_lob blob;
a raw;
m int;
begin
m:=2;
dest_lob:='E6B58BE8AF95'::raw::blob;
DBMS_LOB.read(dest_lob,m,4,a);
RAISE NOTICE '%,%',a,m;
end;
*/

CREATE or replace PROCEDURE DBMS_LOB.read(lob_loc IN            CLOB,
                 amount  IN OUT  INTEGER,
                 p_offset  IN            INTEGER,
                 buffer  OUT           TEXT) package
as
BEGIN
buffer:=pg_catalog.substr(lob_loc::text,p_offset,amount);
if pg_catalog.length(buffer)=0 or buffer is null
then raise NO_DATA_FOUND;
end if;
amount:=pg_catalog.length(buffer);
end;
/
/*
DECLARE
dest_lob clob;
a text;
m int;
begin
m:=20;
dest_lob:='E6B58BE8AF95'::clob;
DBMS_LOB.read(dest_lob,m,3,a);
RAISE NOTICE '%,%',a,m;
end;
*/

CREATE or replace PROCEDURE DBMS_LOB.trim(lob_loc IN OUT   BLOB,
                 newlen  IN            INTEGER) package
as
BEGIN
lob_loc:=rawout(pg_catalog.substr(rawsend(lob_loc),1,newlen))::text::raw::blob;
end;
/
/*
DECLARE
dest_lob blob;
newlen int;
begin
newlen:=2;
dest_lob:='E6B58BE8AF95'::raw::blob;
DBMS_LOB.trim(dest_lob,newlen);
RAISE NOTICE '%',dest_lob;
end;
*/
CREATE or replace PROCEDURE DBMS_LOB.trim(lob_loc IN OUT   CLOB,
                 newlen  IN            INTEGER) package
as
BEGIN
lob_loc:=pg_catalog.substr(lob_loc::text,1,newlen)::clob;
end;
/
/*
DECLARE
dest_lob clob;
newlen int;
begin
newlen:=2;
dest_lob:='E6B58BE8AF95'::clob;
DBMS_LOB.trim(dest_lob,newlen);
RAISE NOTICE '%',dest_lob;
end;
*/

CREATE or replace PROCEDURE DBMS_LOB.write(lob_loc IN OUT   BLOB,
                  amount  IN            INTEGER,
                  p_offset  IN            INTEGER,
                  buffer  IN            RAW) package
AS
BEGIN
DBMS_LOB.copy(lob_loc,buffer::blob,amount,p_offset,1);
end;
/
/*
DECLARE
dest_lob blob;
begin
dest_lob:='E6B58BE8'::raw::blob;
DBMS_LOB.write(dest_lob,6,6,'AABBCCDDEEFF'::raw::blob) ;
RAISE NOTICE '%',dest_lob;
end;
*/

CREATE or replace PROCEDURE DBMS_LOB.write(lob_loc IN OUT   cLOB,
                  amount  IN            INTEGER,
                  p_offset  IN            INTEGER,
                  buffer  IN            text) package
AS
BEGIN
DBMS_LOB.copy(lob_loc,buffer::text,amount,p_offset,1);
end;
/
/*
DECLARE
dest_lob clob;
begin
dest_lob:='E6B58BE8'::clob;
DBMS_LOB.write(dest_lob,6,6,'AABBCCDDEEFF'::clob) ;
RAISE NOTICE '%',dest_lob;
end;
*/

CREATE or replace PROCEDURE DBMS_LOB.writeappend(lob_loc IN OUT  BLOB,
                        amount  IN     INTEGER,
                        buffer  IN     RAW) package
AS
/*未做amount校验 by DarkAthena 2022-05-03*/
BEGIN
lob_loc:=RAWOUT(RAWSEND(lob_loc)||RAWSEND(buffer))::TEXT::RAW::BLOB;
end;
/
/*
DECLARE
lob_loc blob:='112233'::RAW::BLOB;
begin
DBMS_LOB.writeappend(lob_loc,5,'AABBCCDDEE'::RAW);
RAISE NOTICE '%',lob_loc;
end;
*/

CREATE or replace PROCEDURE DBMS_LOB.writeappend(lob_loc IN OUT  CLOB,
                        amount  IN     INTEGER,
                        buffer  IN     TEXT) package
AS
/*未做amount校验 by DarkAthena 2022-05-03*/
BEGIN
lob_loc:=(lob_loc::TEXT||buffer)::CLOB;
end;
/    
/*
DECLARE
lob_loc clob:='112233'::cLOB;
begin
DBMS_LOB.writeappend(lob_loc,10,'AABBCCDDEE'::text);
RAISE NOTICE '%',lob_loc;
end;
*/