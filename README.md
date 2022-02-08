# opengauss-oracle

#### 2022-01-28 通知
本项目对于不同版本兼容性验证通过后的对象，会合并到[compat-tools](https://gitee.com/enmotech/compat-tools)项目中

-----

#### 介绍
一些函数和包，可以在postgresql中使用oracle中的同名函数，不包含[compat-tools](https://gitee.com/enmotech/compat-tools)（截至到2021-12-28的公开版本）里已存在的

#### 计划及进度
##### 函数
|函数名称|功能描述|进度|完成日期|是否已合并至compat-tools
|-|-|-|-|-|
|ANY_VALUE|聚合函数，取任意值|完成|20220101|是
|ASCIISTR|获得字符串的ascii码|完成|20211229|是
|BFILENAME|获得操作系统上的一个文件作为对象
|BIN_TO_NUM|二进制转数字|完成|20211229|是
|COSH|双曲余弦|完成|20211230|是
|KURTOSIS_POP|总体峰态|完成|20220103|是
|KURTOSIS_SAMP|样本峰态|完成|20220103|是
|LNNVL|避免表达式中有空值导致统计遗漏的一个函数|完成|20220101|是
|NUMTOYMINTERVAL|将数字转换成年月INTERVAL|完成|20211230|是
|RATIO_TO_REPORT|分析函数，取本值占分组的百分比
|ROUND_TIES_TO_EVEN (number)|区别于round的另一种四舍五入|完成|20211229|是
|SINH|双曲正弦|完成|20211230|是
|SKEWNESS_POP|总体偏度|完成|20220103|是
|SKEWNESS_SAMP|样本偏度|完成|20220103|是
|SOUNDEX|发音相似|完成|20211230|是
|STANDARD_HASH|标准哈希|完成|20211229|
|SYSTIMESTAMP|当前时间戳|完成|20211229|是
|TANH|双曲正切|完成|20211230|是
|UNISTR|将unicode编码转换成文字字符串|完成|20211229|
|以下为相较于第一版的新增部分
|BIT_AND_AGG|位与聚合|完成|20211231|是
|BIT_OR_AGG|位或聚合|完成|20211231|是
|BIT_XOR_AGG|位异或聚合|完成|20211231|是
|REMAINDER|取任何数相除的余数(和mod不一样,不会进行floor)|完成|20220102|是
|BITOR|位或|完成|20211231|是
|BITXOR|位异或|完成|20211231|是

##### 包
下列包名为我初次筛选，在开发中可能会用到的包
|包名|主要功能|compat-tools是否已含|本人是否可能会进行开发|本人开发进度|本人完成日期|
|-|-|-|-|-|-
|DBMS_HADOOP|在数据库中集成对HIVE及HADOOP进行操作、查询的功能||N|
|DBMS_JOB|作业管理|Y|N|
|DBMS_LOB|大参数操作包||?|
|DBMS_MLE|多开发语言引擎(目前Oracle只支持JS)||N|
|DBMS_METADATA|元数据管理|Y|N|
|DBMS_OUTPUT|控制台输出信息|Y|N|
|DBMS_RANDOM|随机值|Y|N|
|DBMS_REPORT|数据库报告||N|
|DBMS_SCHEDULER|作业管理||N|
|DBMS_SQL|SQL相关包||?|
|DBMS_SQLTUNE|SQL调优包||N|
|DBMS_SQL_TRANSLATOR|SQL翻译(用于对不同sql语法数据库的sql转换或执行)||N|
|DBMS_TF|多态表函数||N|
|DBMS_UTILITY|多种实用工具|Y(部分)|Y|
|DIUTIL|DI工具||Y|
|SQLJUTL|SQLJ工具(特定的一些类型转换,例如布尔到整形)||Y|
|UTL_COMPRESS|压缩解压||?|
|UTL_ENCODE|各种编码解码||Y|
|UTL_FILE|文件工具包||?|
|UTL_HTTP|HTTP工具包||?|
|UTL_I18N|I18N工具包||Y|
|UTL_INADDR|根据域名获取IP或根据IP获取域名||?|
|UTL_MATCH|匹配两个字符串的相似度||Y|
|UTL_LMS|可以根据不同语言输出报错信息||?|
|UTL_NLA|向量矩阵计算||?|
|UTL_RAW|二进制数据工具包||Y|
|UTL_SMTP|邮件工具包||?|
|UTL_TCP|TCP工具包||?|
|UTL_URL|URL工具包||Y|完成|20220202
|UTL_XML|XML工具包||N|
|dbms_application_info|应用信息工具包|Y|N
|DBMS_LOCK|锁定(主要使用sleep过程来延时)|Y|N

子程序明细

|包名|过程或函数名|重载|COMPAT-TOOLS是否已有|开发进度|完成日期
|-|-|-|-|-|-
|DBMS_UTILITY|ACTIVE_INSTANCES||||
|DBMS_UTILITY|ANALYZE_DATABASE||||
|DBMS_UTILITY|ANALYZE_PART_OBJECT||||
|DBMS_UTILITY|ANALYZE_SCHEMA||||
|DBMS_UTILITY|CANONICALIZE||Y||
|DBMS_UTILITY|COMMA_TO_TABLE|2|Y||
|DBMS_UTILITY|COMMA_TO_TABLE|1|Y||
|DBMS_UTILITY|COMPILE_SCHEMA||||
|DBMS_UTILITY|CREATE_ALTER_TYPE_ERROR_TABLE||||
|DBMS_UTILITY|CURRENT_INSTANCE||||
|DBMS_UTILITY|DATA_BLOCK_ADDRESS_BLOCK||||
|DBMS_UTILITY|DATA_BLOCK_ADDRESS_FILE||||
|DBMS_UTILITY|DB_VERSION|1|Y||
|DBMS_UTILITY|DB_VERSION|2|Y||
|DBMS_UTILITY|DIRECTORY_HAS_SYMLINK||||
|DBMS_UTILITY|EXEC_DDL_STATEMENT||Y||
|DBMS_UTILITY|EXPAND_SQL_TEXT||||
|DBMS_UTILITY|FORMAT_CALL_STACK||||
|DBMS_UTILITY|FORMAT_ERROR_BACKTRACE||||
|DBMS_UTILITY|FORMAT_ERROR_STACK||||
|DBMS_UTILITY|GET_CPU_TIME||||
|DBMS_UTILITY|GET_DEPENDENCY||||
|DBMS_UTILITY|GET_ENDIANNESS||||
|DBMS_UTILITY|GET_HASH_VALUE||||
|DBMS_UTILITY|GET_PARAMETER_VALUE||||
|DBMS_UTILITY|GET_SQL_HASH||||
|DBMS_UTILITY|GET_TIME||||
|DBMS_UTILITY|GET_TZ_TRANSITIONS||||
|DBMS_UTILITY|INIT_NUMBER_ARRAY||||
|DBMS_UTILITY|INVALIDATE||||
|DBMS_UTILITY|IS_BIT_SET||||
|DBMS_UTILITY|IS_CLUSTER_DATABASE||||
|DBMS_UTILITY|MAKE_DATA_BLOCK_ADDRESS||||
|DBMS_UTILITY|NAME_RESOLVE||||
|DBMS_UTILITY|NAME_TOKENIZE||||
|DBMS_UTILITY|OLD_CURRENT_SCHEMA||||
|DBMS_UTILITY|OLD_CURRENT_USER||||
|DBMS_UTILITY|PORT_STRING||||
|DBMS_UTILITY|SQLID_TO_SQLHASH||||
|DBMS_UTILITY|TABLE_TO_COMMA|1|||
|DBMS_UTILITY|TABLE_TO_COMMA|2|||
|DBMS_UTILITY|VALIDATE|1|||
|DBMS_UTILITY|VALIDATE|2|||
|DBMS_UTILITY|WAIT_ON_PENDING_DML||||
|DIUTIL|ATTRIBUTE_USE_STATISTICS||||
|DIUTIL|BOOL_TO_INT||||
|DIUTIL|GET_D||||
|DIUTIL|GET_DIANA||||
|DIUTIL|INT_TO_BOOL||||
|DIUTIL|NODE_USE_STATISTICS||||
|DIUTIL|SUBPTXT||||
|SQLJUTL|BOOL2INT||||
|SQLJUTL|CHAR2IDS||||
|SQLJUTL|CHAR2IYM||||
|SQLJUTL|GET_TYPECODE||||
|SQLJUTL|HAS_DEFAULT||||
|SQLJUTL|IDS2CHAR||||
|SQLJUTL|INT2BOOL||||
|SQLJUTL|IYM2CHAR||||
|SQLJUTL|URI2VCHAR||||
|UTL_ENCODE|BASE64_DECODE|||完成|20220203
|UTL_ENCODE|BASE64_ENCODE|||完成|20220203
|UTL_ENCODE|MIMEHEADER_DECODE||||
|UTL_ENCODE|MIMEHEADER_ENCODE||||
|UTL_ENCODE|QUOTED_PRINTABLE_DECODE||||
|UTL_ENCODE|QUOTED_PRINTABLE_ENCODE||||
|UTL_ENCODE|TEXT_DECODE||||
|UTL_ENCODE|TEXT_ENCODE||||
|UTL_ENCODE|UUDECODE||||
|UTL_ENCODE|UUENCODE||||
|UTL_I18N|ENCODE_SQL_XML||||
|UTL_I18N|ESCAPE_REFERENCE||||
|UTL_I18N|GET_COMMON_TIME_ZONES||||
|UTL_I18N|GET_DEFAULT_CHARSET||||
|UTL_I18N|GET_DEFAULT_ISO_CURRENCY||||
|UTL_I18N|GET_DEFAULT_LINGUISTIC_SORT||||
|UTL_I18N|GET_LOCAL_LANGUAGES||||
|UTL_I18N|GET_LOCAL_LINGUISTIC_SORTS||||
|UTL_I18N|GET_LOCAL_TERRITORIES||||
|UTL_I18N|GET_LOCAL_TIME_ZONES||||
|UTL_I18N|GET_MAX_CHARACTER_SIZE||||
|UTL_I18N|GET_TRANSLATION||||
|UTL_I18N|MAP_CHARSET||||
|UTL_I18N|MAP_FROM_SHORT_LANGUAGE||||
|UTL_I18N|MAP_LANGUAGE_FROM_ISO||||
|UTL_I18N|MAP_LOCALE_TO_ISO||||
|UTL_I18N|MAP_TERRITORY_FROM_ISO||||
|UTL_I18N|MAP_TO_SHORT_LANGUAGE||||
|UTL_I18N|RAW_TO_CHAR|1|||
|UTL_I18N|RAW_TO_CHAR|2|||
|UTL_I18N|RAW_TO_NCHAR|1|||
|UTL_I18N|RAW_TO_NCHAR|2|||
|UTL_I18N|STRING_TO_RAW||||
|UTL_I18N|TRANSLITERATE||||
|UTL_I18N|UNESCAPE_REFERENCE||||
|UTL_I18N|VALIDATE_CHARACTER_ENCODING|2|||
|UTL_I18N|VALIDATE_CHARACTER_ENCODING|1|||
|UTL_I18N|VALIDATE_SQLNAME||||
|UTL_MATCH|EDIT_DISTANCE||||
|UTL_MATCH|EDIT_DISTANCE_SIMILARITY||||
|UTL_MATCH|JARO_WINKLER||||
|UTL_MATCH|JARO_WINKLER_SIMILARITY||||
|UTL_RAW|BIT_AND|||完成|20220206
|UTL_RAW|BIT_COMPLEMENT|||完成|20220206
|UTL_RAW|BIT_OR|||完成|20220206
|UTL_RAW|BIT_XOR|||完成|20220206
|UTL_RAW|CAST_FROM_BINARY_DOUBLE||||
|UTL_RAW|CAST_FROM_BINARY_FLOAT||||
|UTL_RAW|CAST_FROM_BINARY_INTEGER|||完成|20220208
|UTL_RAW|CAST_FROM_NUMBER|||完成|20220208
|UTL_RAW|CAST_TO_BINARY_DOUBLE||||
|UTL_RAW|CAST_TO_BINARY_FLOAT||||
|UTL_RAW|CAST_TO_BINARY_INTEGER|||完成|20220208
|UTL_RAW|CAST_TO_NUMBER|||完成|20220208
|UTL_RAW|CAST_TO_NVARCHAR2||||
|UTL_RAW|CAST_TO_RAW|||完成|20220203
|UTL_RAW|CAST_TO_VARCHAR2|||完成|20220203
|UTL_RAW|COMPARE|||完成|20220205
|UTL_RAW|CONCAT|||完成|20220203
|UTL_RAW|CONVERT|||完成|20220205
|UTL_RAW|COPIES|||完成|20220204
|UTL_RAW|LENGTH|||完成|20220203
|UTL_RAW|OVERLAY|||完成|20220204
|UTL_RAW|REVERSE|||完成|20220205
|UTL_RAW|SUBSTR|||完成|20220203
|UTL_RAW|TRANSLATE|||完成|20220203
|UTL_RAW|TRANSLITERATE|||完成|20220203
|UTL_RAW|XRANGE|||完成|20220205
|UTL_URL|ESCAPE|||完成|20220202
|UTL_URL|UNESCAPE|||完成|20220202


#### 注意事项
1.STANDARD_HASH函数依赖于postgresql-contrib模块中的pgcrypto，但openGauss默认没有此模块，请自行提前安装
