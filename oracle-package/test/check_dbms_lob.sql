--drop package base64;
--searched a package from http://blog.chinaunix.net/uid-173640-id-4053255.html
--and remove the code that about "bfile" or "convertto*" any.

create or replace package base64 is

  -- Author : GANGJH
  -- Created : 2013-05-06 16:08:20
  -- Purpose :
  
  -- Public type declarations
   function to_base64(t in varchar2) return varchar2 ;
   PROCEDURE to_base64(dest IN OUT  CLOB, src in blob ) ;
 
   function from_base64(t in varchar2) return varchar2 ;
   PROCEDURE from_base64(dest IN OUT  CLOB, src CLOB ) ;


end base64;
/
create or replace package body base64 is

  function to_base64(t in varchar2) return varchar2 is
  begin
    return utl_raw.cast_to_varchar2(utl_encode.base64_encode(utl_raw.cast_to_raw(t)));
  end ;
  
  PROCEDURE to_base64(dest IN OUT  CLOB, src in blob) IS
    --取 3 的倍數 因為如果需要按照64字符每行分行，所以需要是16的倍數，所以下面的長度必需為 48的倍數
    sizeB integer := 6144;
    buffer raw(6144);
    p_offset integer default 1;
    --coding varchar2(20000);
  begin
    loop
       begin
       dbms_lob.read(src, sizeB, p_offset, buffer);
       exception
         when no_data_found then
           exit;
       end;
       p_offset := p_offset + sizeB;
       dbms_lob.append(dest, to_clob(utl_raw.cast_to_varchar2(utl_encode.base64_encode(buffer))));
    end loop;
  END ;
  
  function from_base64(t in varchar2) return varchar2 is
  begin
    return utl_raw.cast_to_varchar2(utl_encode.base64_decode(utl_raw.cast_to_raw(t)));
  end ;
  
  PROCEDURE from_base64(dest IN OUT  CLOB, src CLOB ) is
    n int := 0;
    substring varchar2(2000);
    substring_length int := 2000;
  BEGIN
    n := 0;
  /*then we do the very same thing backwards - decode base64*/
  while true loop
    substring := dbms_lob.substr(src,
                                 least(substring_length, substring_length * n + 1 - length(src)),
                                 substring_length * n + 1);
    if substring is null then
      exit;
    end if;
    dest := dest|| from_base64(substring);
    n := n + 1;
  end loop;
  END ;

end base64;
/

--dbms_lob,utl_raw and utl_encode
DECLARE
a blob:='1234567890aabbccddeeff'::raw::blob;
b clob;
BEGIN
base64.to_base64(b,a);
raise notice '%',b;
end;
/
--EjRWeJCqu8zd7v8=

--utl_raw and utl_encode
select utl_raw.cast_to_varchar2(utl_encode.base64_encode('1234567890aabbccddeeff')) from dual
--EjRWeJCqu8zd7v8=

--native
select encode('\x1234567890aabbccddeeff','base64')
--EjRWeJCqu8zd7v8=
