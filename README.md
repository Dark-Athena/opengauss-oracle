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
|DBMS_SQL|SQL相关包||N|
|DBMS_SQLTUNE|SQL调优包||N|
|DBMS_SQL_TRANSLATOR|SQL翻译(用于对不同sql语法数据库的sql转换或执行)||N|
|DBMS_TF|多态表函数||N|
|DBMS_UTILITY|多种实用工具|Y|Y|
|DIUTIL|DI工具||Y|
|SQLJUTL|SQLJ工具(特定的一些类型转换,例如布尔到整形)||Y|
|UTL_COMPRESS|压缩解压||?|
|UTL_ENCODE|各种编码解码||?|
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

#### 注意事项
1.STANDARD_HASH函数依赖于postgresql-contrib模块中的pgcrypto，但openGauss默认没有此模块，请自行提前安装
