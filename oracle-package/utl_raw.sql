create schema UTL_RAW;

CREATE OR REPLACE FUNCTION UTL_RAW.cast_to_varchar2(r IN raw)
RETURNS text
LANGUAGE SQL
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
SELECT convert_from(rawsend(r),(select pg_encoding_to_char(encoding) as encoding from pg_database where datname=current_database()));
 $$;
/
--select utl_raw.cast_to_varchar2( '43616D65726F6E')='Cameron';

CREATE OR REPLACE FUNCTION UTL_RAW.cast_to_raw(c IN text)
RETURNS raw
LANGUAGE SQL
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
SELECT rawtohex(replace(c,'\','\\'))::raw;
 $$;
/
--select utl_raw.cast_to_raw( 'Cameron' )='43616D65726F6E'::raw;

CREATE OR REPLACE FUNCTION UTL_RAW.concat(
r1  IN raw DEFAULT ''::raw,
r2  IN raw DEFAULT ''::raw,
r3  IN raw DEFAULT ''::raw,
r4  IN raw DEFAULT ''::raw,
r5  IN raw DEFAULT ''::raw,
r6  IN raw DEFAULT ''::raw,
r7  IN raw DEFAULT ''::raw,
r8  IN raw DEFAULT ''::raw,
r9  IN raw DEFAULT ''::raw,
r10 IN raw DEFAULT ''::raw,
r11 IN raw DEFAULT ''::raw,
r12 IN raw DEFAULT ''::raw
)
RETURNS raw
LANGUAGE SQL
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
--SELECT rawcat(rawcat(rawcat(rawcat(rawcat(rawcat(rawcat(rawcat(rawcat(rawcat(rawcat(r1,r2),r3),r4),r5),r6),r7),r8),r9),r10),r11),r12);
SELECT (r1||r2||r3||r4||r5||r6||r7||r8||r9||r10||r11||r12)::raw;
 $$;
/
--select utl_raw.concat( '9', '0102', 'ff', '0a2b' )='090102FF0A2B'::raw;

CREATE OR REPLACE FUNCTION UTL_RAW.length(r IN raw)
RETURNS int4
LANGUAGE SQL
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
SELECT (pg_catalog.length(r)/2)::int4;
 $$;
/
--select UTL_RAW.length('FF'::raw)=1::int;

CREATE OR REPLACE FUNCTION UTL_RAW.substr(r IN raw,pos in int4,len in int4 DEFAULT null)
RETURNS raw
LANGUAGE plpgSQL
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
DECLARE 
BEGIN
if pos>0 then 
return (case when len is not null 
             then  substring(r from pos*2-1 for len*2) 
             else substring(r from pos*2-1) end )::raw ;
ELSE

return (case when len is not null 
             then  pg_catalog.substr(r , pos*2 , len*2) 
             else pg_catalog.substr(r , pos*2) end )::raw ;
end if;
end;             
 $$;
/
--select utl_raw.substr( '0102030405', 3, 2 )='0304'::raw;
--select utl_raw.substr( '0102030405'::raw, -2,1)='04'::raw;

CREATE OR REPLACE FUNCTION UTL_RAW.transliterate(
r IN raw,
to_set in raw DEFAULT ''::raw,
from_set in raw DEFAULT ''::raw,
pad IN raw DEFAULT '00'::raw )
RETURNS raw
LANGUAGE plpgsql
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
DECLARE
l_tmp text;
begin
if pg_catalog.length(pad)/2>1 then 
RAISE  'Error in utl_raw.transliterate: pad must be 1 byte or null!';
end if;
l_tmp:=regexp_replace(r::TEXT, '(..)','=\1', 'g');
for rec in (
select fs_str,nvl(ts_str,pad::TEXT) ts_str from 
(select row_number() over() fs_pos,fs_str from (
select (regexp_matches(from_set::TEXT, '(..)', 'g')) [ 1 ] fs_str)) f
left join 
(select row_number() over() ts_pos,ts_str from (
select (regexp_matches(to_set::TEXT, '(..)', 'g')) [ 1 ] ts_str)) t
on f.fs_pos=t.ts_pos
) loop
l_tmp:=replace(l_tmp,'='||rec.fs_str,rec.ts_str);
end loop;
return replace(l_tmp,'=','')::raw;
end;
$$;
/
--select utl_raw.transliterate( '010203040502', '0809', '01020304', '0a' )='08090A0A0509'::raw

CREATE OR REPLACE FUNCTION UTL_RAW.translate(r IN raw,from_set in raw,to_set in raw )
RETURNS raw
LANGUAGE sql
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
select UTL_RAW.transliterate(r,to_set,from_set,''::raw);
$$;
/
--select utl_raw.translate( '0102030405', '0203', '06' )='01060405'::raw;

CREATE OR REPLACE FUNCTION UTL_RAW.copies(
r IN raw,
n IN int8)
RETURNS raw
LANGUAGE plpgsql
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
DECLARE
l_result raw DEFAULT ''::raw;
begin
if n<0 then 
RAISE  'n must be equal or greater than 1!';
end if;
if pg_catalog.length(r)/2<1 then 
RAISE  'r is missing, null and/or 0 length!';
end if;
for i in 1..n LOOP
l_result:=l_result||r;
end loop;
return l_result;
end;
$$;
/
--select utl_raw.copies( '010203', 4 )='010203010203010203010203'::raw;

CREATE OR REPLACE FUNCTION UTL_RAW.overlay(
overlay_str IN raw,
target      IN raw,
pos         IN int4 DEFAULT 1,
len         IN int4 DEFAULT NULL,
pad         IN raw            DEFAULT '00'::raw)
RETURNS raw
LANGUAGE plpgsql
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
DECLARE
l_result raw;
l_overlay_str raw;
l_len int4;
l_pad raw;
l_pos_over_str raw DEFAULT ''::raw;
begin
l_overlay_str:=overlay_str;
if UTL_RAW.length(pad)>1 THEN
l_pad:=UTL_RAW.substr(pad , 1 , 1);
ELSE
l_pad:=pad;
end if;
if len is null then 
l_len:=UTL_RAW.length(overlay_str);
else  
l_len:=len;
end if;
if UTL_RAW.length(l_overlay_str)>l_len THEN
l_overlay_str:=UTL_RAW.substr(l_overlay_str , 1 , l_len);
elsif UTL_RAW.length(l_overlay_str)<l_len THEN
l_overlay_str:=l_overlay_str||UTL_RAW.copies(l_pad,l_len-UTL_RAW.length(l_overlay_str) );
end if;
if pos>utl_raw.length(target) THEN
l_pos_over_str:=UTL_RAW.copies(pad,pos-utl_raw.length(target)-1);
end if;
l_result:=UTL_RAW.substr(target , 1 , pos-1)||l_pos_over_str||l_overlay_str||UTL_RAW.substr(target , pos+l_len);
return l_result;
end;
$$;
/
--select utl_raw.overlay( 'aabb', '010203' )='AABB03'::raw;	
--select utl_raw.overlay( 'aabb', '010203', 2 )='01AABB'::raw;
--select utl_raw.overlay( 'aabb', '010203', 5 )='01020300AABB'::raw;
--select utl_raw.overlay( 'aabb', '010203', 2, 1 )='01AA03'::raw;	
--select utl_raw.overlay( 'aabb', '010203', 5, 1, 'FF' )='010203FFAA'::raw;

CREATE OR REPLACE FUNCTION UTL_RAW.xrange(
start_byte IN raw,
end_byte IN raw)
RETURNS raw
LANGUAGE plpgsql
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
DECLARE
l_result raw DEFAULT ''::raw;
l_start_int int4;
l_end_int int4;
l_tmp raw;
begin
if UTL_RAW.length(start_byte)!=1 or UTL_RAW.length(end_byte)!=1  then 
RAISE  'start_byte and end_byte must be single byte!';
end if;
l_start_int:=to_number(start_byte,'xx');
l_end_int:=to_number(end_byte,'xx');
LOOP
l_tmp:=utl_raw.substr(to_hex(l_start_int)::raw,-1,1);
l_result:=l_result||l_tmp;
if l_tmp=utl_raw.substr(end_byte,-1) then exit;
end if;
l_start_int:=l_start_int+1;
end loop;
return l_result;
end;
$$;
/
--select utl_raw.xrange( '01', '11' )='0102030405060708090A0B0C0D0E0F1011'::raw;
--select utl_raw.xrange( 'fa', '06' )='FAFBFCFDFEFF00010203040506'::raw;

CREATE OR REPLACE FUNCTION UTL_RAW.reverse(
r IN raw)
RETURNS raw
LANGUAGE plpgsql
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
DECLARE
l_result raw DEFAULT ''::raw;
begin
for i in reverse UTL_RAW.length(r)..1   LOOP
l_result:=l_result||UTL_RAW.substr(r , i , 1);
end loop;
return l_result;
end;
$$;
/
--SELECT utl_raw.reverse( '0102030405' )='0504030201'::raw;

CREATE OR REPLACE FUNCTION UTL_RAW.compare(
                   r1  IN raw,
                   r2  IN raw,
                   pad IN raw DEFAULT '00'::raw)
RETURNS int4
LANGUAGE plpgsql
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
DECLARE
l_result int4 DEFAULT 0;
l_r1 raw DEFAULT ''::raw;
l_r2 raw DEFAULT ''::raw;
begin
for i in 1..greatest(UTL_RAW.length(r1),UTL_RAW.length(r2))   LOOP
l_r1:=UTL_RAW.substr(r1 , i , 1);
l_r2:=UTL_RAW.substr(r2 , i , 1);
if l_r1!=l_r2 THEN
if l_r1=''::raw then 
l_r1:=pad;
end if;
if l_r2=''::raw then 
l_r2:=pad;
end if;
if l_r1!=l_r2 then 
l_result:=i;
EXIT;
end if;
end if;
end loop;
return l_result;
end;
$$;
/
--SELECT utl_raw.compare( '010203', '01020304', '04' )=0::int;	
--SELECT utl_raw.compare( '01050304', '01020304' )=2::int;

CREATE OR REPLACE FUNCTION UTL_RAW.convert(r IN raw,
                   to_charset   IN text,
                   from_charset IN text)
RETURNS raw
LANGUAGE sql
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
select rawout(convert_to(convert_from(rawsend(r),from_charset),to_charset))::text::raw;
$$;
/
--select utl_raw.convert(rawout('测试'::BYTEA)::text::raw,'GBK','UTF8')='B2E2CAD4'::raw;

CREATE OR REPLACE FUNCTION utl_raw.bit_and(r1 raw, r2 raw)
 RETURNS raw
 LANGUAGE plpgsql
 IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
DECLARE
l_result bytea DEFAULT '\x'::bytea;
l_r1 raw;
l_r2 raw;
l_r1_bytea bytea;
l_r2_bytea bytea;
l_r1_len int8;
l_r2_len int8;
begin
l_r1_len:=utl_raw.length(r1);
l_r2_len:=utl_raw.length(r2);
l_r1:=r1;
l_r2:=r2;
if l_r1_len>l_r2_len then
l_r2:=utl_raw.copies('00'::raw,l_r1_len-l_r2_len)||l_r2;
elsif l_r1_len<l_r2_len then 
l_r1:=utl_raw.copies('00'::raw,l_r2_len-l_r1_len)||l_r2;
end if;
l_r1_bytea:=rawsend(l_r1);
l_r2_bytea:=rawsend(l_r2);
l_result:=rawsend(utl_raw.copies('00'::raw,GREATEST(l_r1_len,l_r2_len)));
for i in 0..bit_length(l_result)-1 LOOP
l_result:=set_bit(l_result,i,get_bit(l_r1_bytea,i)&get_bit(l_r2_bytea,i));
end loop;
return rawout(l_result)::text::raw;
end;
$$;
/
--select utl_raw.bit_and('1234ffdd','1234ffee')='1234FFCC'::raw;

CREATE OR REPLACE FUNCTION utl_raw.bit_or(r1 raw, r2 raw)
 RETURNS raw
 LANGUAGE plpgsql
 IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
DECLARE
l_result bytea DEFAULT '\x'::bytea;
l_r1 raw;
l_r2 raw;
l_r1_bytea bytea;
l_r2_bytea bytea;
l_r1_len int8;
l_r2_len int8;
begin
l_r1_len:=utl_raw.length(r1);
l_r2_len:=utl_raw.length(r2);
l_r1:=r1;
l_r2:=r2;
if l_r1_len>l_r2_len then
l_r2:=utl_raw.copies('00'::raw,l_r1_len-l_r2_len)||l_r2;
elsif l_r1_len<l_r2_len then 
l_r1:=utl_raw.copies('00'::raw,l_r2_len-l_r1_len)||l_r2;
end if;
l_r1_bytea:=rawsend(l_r1);
l_r2_bytea:=rawsend(l_r2);
l_result:=rawsend(utl_raw.copies('00'::raw,GREATEST(l_r1_len,l_r2_len)));
for i in 0..bit_length(l_result)-1 LOOP
l_result:=set_bit(l_result,i,get_bit(l_r1_bytea,i)|get_bit(l_r2_bytea,i));
end loop;
return rawout(l_result)::text::raw;
end;
$$;
/
--select utl_raw.bit_or('1234ffdd','1234ffee')='1234FFFF'::raw;                           

CREATE OR REPLACE FUNCTION utl_raw.bit_xor(r1 raw, r2 raw)
 RETURNS raw
 LANGUAGE plpgsql
 IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
DECLARE
l_result bytea DEFAULT '\x'::bytea;
l_r1 raw;
l_r2 raw;
l_r1_bytea bytea;
l_r2_bytea bytea;
l_r1_len int8;
l_r2_len int8;
begin
l_r1_len:=utl_raw.length(r1);
l_r2_len:=utl_raw.length(r2);
l_r1:=r1;
l_r2:=r2;
if l_r1_len>l_r2_len then
l_r2:=utl_raw.copies('00'::raw,l_r1_len-l_r2_len)||l_r2;
elsif l_r1_len<l_r2_len then 
l_r1:=utl_raw.copies('00'::raw,l_r2_len-l_r1_len)||l_r2;
end if;
l_r1_bytea:=rawsend(l_r1);
l_r2_bytea:=rawsend(l_r2);
l_result:=rawsend(utl_raw.copies('00'::raw,GREATEST(l_r1_len,l_r2_len)));
for i in 0..bit_length(l_result)-1 LOOP
l_result:=set_bit(l_result,i,get_bit(l_r1_bytea,i)#get_bit(l_r2_bytea,i));
end loop;
return rawout(l_result)::text::raw;
end;
$$;
/
--select utl_raw.bit_xor('1234ffdd','1234ffee')='00000033'::raw; 

CREATE OR REPLACE FUNCTION utl_raw.bit_complement(r raw)
 RETURNS raw
 LANGUAGE plpgsql
 IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
DECLARE
l_result bytea DEFAULT '\x'::bytea;
begin
l_result:=rawsend(r);
for i in 0..bit_length(l_result)-1 LOOP
l_result:=set_bit(l_result,i,case when get_bit(l_result,i)=1 then 0 else 1 end );
end loop;
return rawout(l_result)::text::raw;
end;
$$;
/
--select UTL_raw.bit_complement('1122FF') ='EEDD00'::raw;

CREATE OR REPLACE FUNCTION utl_raw.cast_to_number(r raw)
 RETURNS NUMERIC
 LANGUAGE plpgsql
 IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
/*2022-02-08 memo:未对输入参数的正确性进行校验，错误的输入会带来错误的输出（by:DarkAthena）*/
DECLARE
l_result NUMERIC DEFAULT 0::numeric;
l_first_byte int4;
l_len int8;
begin
l_len:=utl_raw.length(r);
l_first_byte:=to_number(utl_raw.substr(r,1,1),'xx');
if l_first_byte>128 then 
for i in 1..l_len-1 LOOP
l_result:=l_result+(to_number(utl_raw.substr(r,i+1,1),'xx')-1)*(100^(l_first_byte-193-(i-1)));
end loop;
elsif l_first_byte<128 then 
for i in 1..l_len-2 LOOP
l_result:=l_result-(101-to_number(utl_raw.substr(r,i+1,1),'xx'))*(100^(62-l_first_byte-(i-1)));
end loop;
elsif l_first_byte=128 then 
l_result:=0;
else 
RAISE  'raw format error!';
end if;
return l_result;
end;
$$;
/
--select utl_raw.cast_TO_number('C1020B') =1.1;
--select utl_raw.cast_TO_number('3E645B66') =-1.1;


CREATE OR REPLACE FUNCTION utl_raw.cast_from_number(n NUMERIC)
 RETURNS raw
 LANGUAGE plpgsql
 IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
DECLARE
l_result raw DEFAULT ''::raw;
l_len int4;
l_x NUMERIC;
l_pos int4 DEFAULT 1::int4;
begin
l_len:=ceil((pg_catalog.length(ceil(abs(n)))/2))::int8;
if n>0 then 
l_result:=to_hex(193+(l_len-1))::raw;
LOOP
l_x:=trunc(n,-(l_len-l_pos)*2)-trunc(n,-(l_len-l_pos+1)*2);
l_result:=rawcat(l_result,to_hex((l_x/(100^(l_len-l_pos))+1)::int4)::raw);
if trunc(n,-(l_len-l_pos)*2)=n then 
exit;
end if;
l_pos:=l_pos+1;
end loop;
elsif n<0 then 
l_result:=to_hex(62-(l_len-1))::raw;
LOOP
l_x:=trunc(n,-(l_len-l_pos)*2)-trunc(n,-(l_len-l_pos+1)*2);
l_result:=rawcat(l_result,to_hex(101+(l_x/(100^(l_len-l_pos)))::int4)::raw);
if trunc(n,-(l_len-l_pos)*2)=n then 
exit;
end if;
l_pos:=l_pos+1;
end loop;
l_result:=rawcat(l_result,'66'::raw);
elsif n=0 then 
l_result:='80'::raw;
else 
RAISE  'NUMERIC error!';
end if;
return l_result;
end;
$$;
/
--select utl_raw.cast_from_number(1.1) ='C1020B'::raw;
--select utl_raw.cast_from_number(-1.1) ='3E645B66'::raw;



CREATE OR REPLACE FUNCTION utl_raw.cast_to_binary_integer(r IN RAW,
                                  endianess IN int1  DEFAULT 1)
 RETURNS int4
 LANGUAGE plpgsql
 IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
DECLARE
l_result int4;
begin
if endianess in (1,3) then  
l_result:=to_number(r::text,'xxxxxxxx');
elsif endianess =2 then
l_result:=to_number(utl_raw.reverse(r)::text,'xxxxxxxx');
else
RAISE  'invaild endianess!';
end if;
return l_result;
end;
$$;
/
--select utl_raw.cast_to_binary_integer('0000FF00')=65280;
--select utl_raw.cast_to_binary_integer('FF000000',2)=255;

CREATE OR REPLACE FUNCTION utl_raw.cast_from_binary_integer(n integer, endianess tinyint DEFAULT 1)
 RETURNS raw
 LANGUAGE plpgsql
 IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
DECLARE
l_result raw DEFAULT ''::raw;
begin                       
if endianess in (1,3) then  
l_result:=lpad(to_char(n,'fmxxxxxxxx'),8,'0')::raw;
elsif endianess =2 then
l_result:=utl_raw.reverse(replace(lpad(to_char(n,'fmxxxxxxxx'),8,'0'),' ','0')::raw);
else
RAISE  'invaild endianess!';
end if;
return l_result;
end;
$$;
/
--select utl_raw.cast_from_binary_integer(65280)='0000FF00'::RAW
--select utl_raw.cast_from_binary_integer(65280,2)='00FF0000'::RAW
