create schema UTL_ENCODE;

CREATE OR REPLACE FUNCTION UTL_ENCODE.base64_encode(r IN BYTEA)
RETURNS BYTEA
LANGUAGE SQL
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
SELECT encode(r,'base64')::BYTEA;
 $$;
/

CREATE OR REPLACE FUNCTION UTL_ENCODE.base64_decode(r IN BYTEA)
RETURNS BYTEA
LANGUAGE SQL
IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
SELECT decode(encode(r,'escape'),'base64')::BYTEA;
 $$;
/

--test
--select encode(UTL_ENCODE.base64_encode(convert_to('测试','utf8')),'escape');
--select convert_from(UTL_ENCODE.base64_decode('5rWL6K+V'::bytea),'utf8');