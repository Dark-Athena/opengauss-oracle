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

#### dbms包
未开始

#### 注意事项
1.STANDARD_HASH函数依赖于postgresql-contrib模块中的pgcrypto，但openGauss默认没有此模块，请自行提前安装
