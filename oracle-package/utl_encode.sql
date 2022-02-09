create schema UTL_ENCODE;

CREATE OR REPLACE FUNCTION UTL_ENCODE.base64_encode(r IN raw)
RETURNS raw
LANGUAGE SQL
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
SELECT rawtohex(encode(rawsend(r),'base64'))::RAW;
 $$;
/

CREATE OR REPLACE FUNCTION UTL_ENCODE.base64_decode(r IN raw)
RETURNS raw
LANGUAGE SQL
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
SELECT rawout(decode(encode(rawsend(r),'escape'),'base64')::BYTEA)::TEXT::RAW;
 $$;
/
/

--test
--SELECT  UTL_ENCODE.base64_encode(rawtohex('测试')::raw) ='3572574C364B2B56'::RAW
--SELECT UTL_ENCODE.base64_decode('3572574C364B2B56')= 'E6B58BE8AF95'::raw