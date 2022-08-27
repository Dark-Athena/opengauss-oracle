CREATE PACKAGE dbms_crypto IS 
-- dependencies 
-- 1. https://github.com/Dark-Athena/sha256-opengauss/blob/main/og3.0/sha256.pkg

HASH_MD5 CONSTANT PLS_INTEGER := 2;
HASH_SH256 CONSTANT PLS_INTEGER := 4;

FUNCTION Hash (src IN RAW,
               typ IN PLS_INTEGER)
    RETURN RAW ;

FUNCTION Hash (src IN BLOB,
               typ IN PLS_INTEGER)
    RETURN RAW ;

FUNCTION Hash (src IN CLOB,
               typ IN PLS_INTEGER)
    RETURN RAW ;
end dbms_crypto;
/

create or replace package body dbms_crypto is
function Hash (src IN RAW,
               typ IN PLS_INTEGER)
    RETURN RAW is
   begin
  	if typ=dbms_crypto.hash_md5 then
  	return (md5(rawsend(src)))::text::raw;
  	elsif typ=dbms_crypto.HASH_SH256 then 
  	return (sha256.ENCRYPT_RAW(src))::raw;
  	else
  	raise 'unsupported hash type!';
    end if;
  end;

FUNCTION Hash (src IN BLOB,
               typ IN PLS_INTEGER)
    RETURN RAW is
   begin
  	if typ=dbms_crypto.hash_md5 then
  	return (md5(rawsend(src)))::text::raw;
  	elsif typ=dbms_crypto.HASH_SH256 then 
  	return (sha256.ENCRYPT_RAW(src))::raw;
  	else
  	raise 'unsupported hash type!';
    end if;
  	
  end;

FUNCTION Hash (src IN CLOB,
               typ IN PLS_INTEGER)
    RETURN RAW is
   begin
  	if typ=dbms_crypto.hash_md5 then
  	return (md5(src))::raw;
  	elsif typ=dbms_crypto.HASH_SH256 then 
  	return (sha256.ENCRYPT(src))::raw;
  	else
  	raise 'unsupported hash type!';
    end if;
  end;
 end dbms_crypto;
 /