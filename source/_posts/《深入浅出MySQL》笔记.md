---
title: 《深入浅出MySQL》笔记
date: 2020-12-20 10:42:23
tags: ["MySQL"]
---

本文用于记录《深入浅出MySQL》里面的知识要点，以备再次查阅。



## 第二章 SQL基础

MySQL使用入门：

+ SQL语句分类：DDL，DML，DCL。

+ DDL：数据定义语言，对数据库内部的对象进行创建，删除，修改等操作。

  ```
  // 数据库
  CREATE DATABASE dbname;
  SHOW DATABASES;
  USE dbname;
  DROP DATABASE dbname;
  // 表
  CREATE TABLE tablename (
  	column_name1, type1 constraints,
  	...
  	column_namen, typen constraints);
  DESC tablename;	
  SHOW CREATE TABLE tablename;
  DROP TBALE database;
  ALTER TABLE tablename MODIFY [COLUMN] column_definition [FIRST | AFTER col_name];
  ALTER TABLE tablename ADD [COLUMN] column_difinition [FIRST | AFTER col_name];
  ALTER TABLE tablename DROP [COLUMN] col_name;
  ALTER TABLE tablename CHANGE [COLUMN] old_col_name column_definition;
  ALTER TABLE tablename RENAME new_tablename;
  ```

+ DML：数据操作，主要包括表记录的增删查改。

  ```
  INSERT INTO tablename(field1, field2, ..., fieldn)
  VALUES
  (value1, value2, ..., valuen),
  (value1, value2, ..., valuen);
  UPDATE tablename SET field1=value1 [WHERE CONDITION];
  DELETE FROM tablename [WHERE CONDITION];
  SELECT * FROM tablename [WHERE CONDITION] [LIMIT offset_start, row_count];
  ```

  + 查询不重复记录：distinct
  + 条件查询：WHERE CONDITION
  + 排序和限制：ORDER BY 和 LIMIT offset_start, row_count
  + 聚合：GROUP BY column_name HAVING condition
  + 表连接：内连接，外连接（左连接，右连接）
  + 子查询：可能需要 in，not in，exists 等
  + 记录联合：UNION，UNION ALL

+ DCL：DBA 用来管理系统中的对象权限时使用。

  ```
  GRANT SELECT, INSERT on dbname.* to 'z1'@'localhost' identified by '123';
  REVOKE INSERT on dbname.* from 'z1'@'localhost';
  ```

帮助的使用：

+ 按照层次查看帮助：`? contents`
+ 快速查阅帮助：`? select`



## 第三章 MySQL支持的数据类型

数值类型：

| 类型         | 大小                                     | 范围（有符号）                                               | 范围（无符号）                                               |
| :----------- | :--------------------------------------- | :----------------------------------------------------------- | :----------------------------------------------------------- |
| TINYINT      | 1 byte                                   | (-128，127)                                                  | (0，255)                                                     |
| SMALLINT     | 2 bytes                                  | (-32 768，32 767)                                            | (0，65 535)                                                  |
| MEDIUMINT    | 3 bytes                                  | (-8 388 608，8 388 607)                                      | (0，16 777 215)                                              |
| INT或INTEGER | 4 bytes                                  | (-2 147 483 648，2 147 483 647)                              | (0，4 294 967 295)                                           |
| BIGINT       | 8 bytes                                  | (-9,223,372,036,854,775,808，9 223 372 036 854 775 807)      | (0，18 446 744 073 709 551 615)                              |
| FLOAT        | 4 bytes                                  | (-3.402 823 466 E+38，-1.175 494 351 E-38)，0，(1.175 494 351 E-38，3.402 823 466 351 E+38) | 0，(1.175 494 351 E-38，3.402 823 466 E+38)                  |
| DOUBLE       | 8 bytes                                  | (-1.797 693 134 862 315 7 E+308，-2.225 073 858 507 201 4 E-308)，0，(2.225 073 858 507 201 4 E-308，1.797 693 134 862 315 7 E+308) | 0，(2.225 073 858 507 201 4 E-308，1.797 693 134 862 315 7 E+308) |
| DECIMAL      | 对DECIMAL(M,D) ，如果M>D，为M+2否则为D+2 | 依赖于M和D的值                                               | 依赖于M和D的值                                               |

对于整形数据，MySQL还支持在类型名称后面的小括号内指定显
示宽度。

日期时间类型：

| 类型      | 大小 ( bytes) | 范围                                    | 格式                | 用途                     |
| :-------- | :------------ | :-------------------------------------- | :------------------ | :----------------------- |
| DATE      | 3             | 1000-01-01/9999-12-31                   | YYYY-MM-DD          | 日期值                   |
| TIME      | 3             | '-838:59:59'/'838:59:59'                | HH:MM:SS            | 时间值或持续时间         |
| YEAR      | 1             | 1901/2155                               | YYYY                | 年份值                   |
| DATETIME  | 8             | 1000-01-01 00:00:00/9999-12-31 23:59:59 | YYYY-MM-DD HH:MM:SS | 混合日期和时间值         |
| TIMESTAMP | 4             | 1970-01-01 00:00:00/2038                | YYYYMMDD HHMMSS     | 混合日期和时间值，时间戳 |

字符串类型：

| 类型       | 大小                  | 用途                            |
| :--------- | :-------------------- | :------------------------------ |
| CHAR       | 0-255 bytes           | 定长字符串                      |
| VARCHAR    | 0-65535 bytes         | 变长字符串                      |
| TINYBLOB   | 0-255 bytes           | 不超过 255 个字符的二进制字符串 |
| TINYTEXT   | 0-255 bytes           | 短文本字符串                    |
| BLOB       | 0-65 535 bytes        | 二进制形式的长文本数据          |
| TEXT       | 0-65 535 bytes        | 长文本数据                      |
| MEDIUMBLOB | 0-16 777 215 bytes    | 二进制形式的中等长度文本数据    |
| MEDIUMTEXT | 0-16 777 215 bytes    | 中等长度文本数据                |
| LONGBLOB   | 0-4 294 967 295 bytes | 二进制形式的极大文本数据        |
| LONGTEXT   | 0-4 294 967 295 bytes | 极大文本数据                    |

+ ENUM：值范围需要在创建表时通过枚举方式显式指定，对于插入不在 ENUM指定范围内的值时，并没有返回警告，而是插入了 enum 定义中的第一个值
+ SET：从允许值集合中选择任意1个或多个元素进行组合来赋值



## 第四章 MySQL中的运算符

算术运算符：

| 运算符   | 作用 |
| :------- | :--- |
| +        | 加法 |
| -        | 减法 |
| *        | 乘法 |
| / 或 DIV | 除法 |
| % 或 MOD | 取余 |

在除法运算和模运算中，如果除数为0，将是非法除数，返回结果为NULL。

比较运算符：

|                 |                            |                                                              |
| --------------- | -------------------------- | ------------------------------------------------------------ |
| =               | 等于                       |                                                              |
| <>, !=          | 不等于                     |                                                              |
| >               | 大于                       |                                                              |
| <               | 小于                       |                                                              |
| <=              | 小于等于                   |                                                              |
| >=              | 大于等于                   |                                                              |
| BETWEEN         | 在两值之间                 | >=min&&<=max                                                 |
| NOT BETWEEN     | 不在两值之间               |                                                              |
| IN              | 在集合中                   |                                                              |
| NOT IN          | 不在集合中                 |                                                              |
| <=>             | 严格比较两个NULL值是否相等 | 两个操作码均为NULL时，其所得值为1；而当一个操作码为NULL时，其所得值为0 |
| LIKE            | 模糊匹配                   |                                                              |
| REGEXP 或 RLIKE | 正则式匹配                 |                                                              |
| IS NULL         | 为空                       |                                                              |
| IS NOT NULL     | 不为空                     |                                                              |

逻辑运算符：

| 运算符号 | 作用     |
| :------- | :------- |
| NOT 或 ! | 逻辑非   |
| AND      | 逻辑与   |
| OR       | 逻辑或   |
| XOR      | 逻辑异或 |

位运算符：

| 运算符号 | 作用     |
| :------- | :------- |
| &        | 按位与   |
| \|       | 按位或   |
| ^        | 按位异或 |
| !        | 取反     |
| <<       | 左移     |
| >>       | 右移     |



## 第五章 常用函数

字符串函数：

| **编号** | **函数名**               | **作用**                                                     |
| -------- | ------------------------ | ------------------------------------------------------------ |
| 1        | LEFT(s,n)                | 返回字符串s前n个字符                                         |
| 2        | RIGHT(s,n)               | 返回字符串s后n个字符                                         |
| 3        | LENGTH(s)                | 返回字符串s的长度                                            |
| 4        | LOCATE(s1,s2)            | 从字符串 s2 中获取 子串s1 的开始位置                         |
| 5        | LOWER(s)                 | 大写转小写                                                   |
| 6        | UPPER(s)                 | 小写转大写                                                   |
| 7        | LTRIM(s)                 | 去掉字符串s左面的空格                                        |
| 8        | RTRIM(s)                 | 去掉字符串s右面的空格                                        |
| 9        | TRIM(s)                  | 去掉字符串s两边的空格                                        |
| 10       | ASCII(s)                 | 返回字符串s的第一个字符的 ASCII 码                           |
| 11       | CONCAT(s1,s2…sn)         | 字符串 s1,s2 等多个字符串合并为一个字符串                    |
| 12       | FIND_IN_SET(s1,s2)       | 返回在字符串s2中与s1匹配的字符串的位置(多句话)               |
| 13       | FORMAT(x,n)              | 可以将数字 x 进行格式化 “#,###.##”, 将 x 保留到小数点后 n 位，最后一位四舍五入 |
| 14       | INSERT(s1,x,len,s2)      | 字符串 s2 替换 s1 的 x 位置开始长度为 len 的字符串           |
| 15       | SUBSTR(s, start, length) | 从字符串 s 的 start 位置截取长度为 length 的子字符串         |
| 16       | POSITION(s1 IN s)        | 从字符串 s 中获取 s1 的开始位置                              |
| 17       | REPEAT(s,n)              | 将字符串 s 重复 n 次                                         |
| 18       | REVERSE(s)               | 将字符串s的顺序反过来                                        |
| 19       | STRCMP(s1,s2)            | 比较字符串 s1 和 s2，如果 s1 与 s2 相等返回 0 ，如果 s1>s2 返回 1，如果 s1<s2 返回 -1（比较的是字符串首字母的 ASCII 码） |
| 20       | REPLACE (s1,s2,s3)       | 替换字符串；将s1中的s2内容替换为s3                           |

数值函数：

| **编号** | **函数名**                       | **作用**                                                     |
| -------- | -------------------------------- | ------------------------------------------------------------ |
| 1        | ABS(x)                           | 返回x的绝对值                                                |
| 2        | AVG(expression)                  | 返回一个表达式的平均值，expression 是一个字段                |
| 3        | CEIL(x)/CEILING(x)               | 返回大于或等于 x 的最小整数                                  |
| 4        | FLOOR(x)                         | 返回小于或等于 x 的最大整数                                  |
| 5        | EXP(x)                           | 返回 e 的 x 次方                                             |
| 6        | GREATEST(expr1, expr2, expr3, …) | 返回列表中的最大值                                           |
| 7        | LEAST(expr1, expr2, expr3, …)    | 返回列表中的最小值                                           |
| 8        | LN                               | 返回数字的自然对数                                           |
| 9        | LOG(x)                           | 返回自然对数(以 e 为底的对数)                                |
| 10       | MAX(expression)                  | 返回字段 expression 中的最大值                               |
| 11       | MIN(expression)                  | 返回字段 expression 中的最大值                               |
| 12       | POW(x,y)/POWER(x,y)              | 返回 x 的 y 次方                                             |
| 13       | RAND()                           | 返回 0 到 1 的随机数                                         |
| 14       | ROUND(x)                         | 返回离 x 最近的整数                                          |
| 15       | SIGN(x)                          | 返回 x 的符号，x 是负数、0、正数分别返回 -1、0 和 1          |
| 16       | SQRT(x)                          | 返回x的平方根                                                |
| 17       | SUM(expression)                  | 返回指定字段的总和                                           |
| 18       | TRUNCATE(x,y)                    | 返回数值 x 保留到小数点后 y 位的值（与 ROUND 最大的区别是不会进行四舍五入） |

日期和时间函数：

| **编号** | **函数名**               | **作用**                                          |
| -------- | ------------------------ | ------------------------------------------------- |
| 1        | CURDATE()/CURRENT_DATE() | 返回当前日期                                      |
| 2        | CURRENT_TIME()/CURTIME() | 返回当前时间                                      |
| 3        | CURRENT_TIMESTAMP()      | 返回当前日期和时间                                |
| 4        | ADDDATE(d,n)             | 计算起始日期 d 加上 n 天的日期                    |
| 5        | ADDTIME(t,n)             | 时间 t 加上 n 秒的时间                            |
| 6        | DATE()                   | 从日期或日期时间表达式中提取日期值                |
| 7        | DAY(d)                   | 返回日期值 d 的日期部分                           |
| 8        | DATEDIFF(d1,d2)          | 计算日期 d1->d2 之间相隔的天数                    |
| 9        | DATE_FORMAT              | 按表达式 f的要求显示日期 d                        |
| 10       | DAYNAME(d)               | 返回日期 d 是星期几，如 Monday,Tuesday            |
| 11       | DAYOFMONTH(d)            | 计算日期 d 是本月的第几天                         |
| 12       | DAYOFWEEK(d)             | 日期 d 今天是星期几，1 星期日，2 星期一，以此类推 |
| 13       | DAYOFYEAR(d)             | 计算日期 d 是本年的第几天                         |
| 14       | UNIX_TIMESTAMP()         | 得到时间戳                                        |
| 15       | FROM_UNIXTIME()          | 时间戳转日期                                      |
| 16       | NOW()                    | 返回当前的日期和时间                              |
| 17       | STR_TO_DATE()            | 将日期格式的字符转换成指定格式的日期              |
| 18       | DATE_FORMAT()            | 将日期转换成字符(支持：- . /分割年月日)           |

流程函数：

| 函数                                      | 功能                                 |
| ----------------------------------------- | ------------------------------------ |
| IF(cond, t, f)                            | 如果 cond 为真，返回 t，否则fanhui f |
| CASE cond WHEN value1 THEN result ... END | 多重选择                             |

其他常用函数：

| 函数           | 功能               |
| -------------- | ------------------ |
| DATABASE()     | 返回当前数据库名   |
| VERSION()      | 返回数据库版本     |
| USER()         | 返回当前登录用户名 |
| INET_ATON(IP)  | 返回 IP 代表的 num |
| INET_NTOA(num) | 返回 num 代表的 IP |
| PASSWORD()     | 返回加密版本       |
| MD5()          | 返回 MD5 的值      |



## 第六章 图形化工具的使用

MySQL Workbench：

+ SQL 开发
+ 数据建模
+ 服务器管理
+ MySQL Utilities

phpMyAdmin：

+ 数据库管理
+ 数据库对象管理
+ 权限管理
+ 导入导出数据