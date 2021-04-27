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

对于整形数据，MySQL还支持在类型名称后面的小括号内指定显式宽度。

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



## 第七章 存储引擎（表类型）的选择

存储引擎概述：根据不同领域的需要选择合适的存储引擎，可以更好地提高数据库的效率。在诸多的引擎中，支持事务安全的只有 InnoDB 和 BDB。默认的存储引擎可以通过 default-table-type 配置。使用  `SHOW ENGINES` 可以查看当前数据库支持的引擎。

各种存储引擎的特性：

![image-20201220142420583](《深入浅出MySQL》笔记/image-20201220142420583.png)

+ MyISAM：不支持事务、也不支持外键，其优势是访问的速度快，对事务完整性没有要求或者以 SELECT、INSERT 为主的应用基本上都可以使用这个引擎创建表。
+ InnoDB：提供了具有提交、回滚和崩溃恢复能力的事务安全。但是对比MyISAM的存储引擎，InnoDB写的处理效率差一些，并且会占用更多的磁盘空间以保留数据和索引。
+ MEMORY：使用存在于内存中的内容来创建表。每个MEMORY 表只实际对应一个磁盘文件，格式是.frm。MEMORY 类型的表访问非常地快，因为它的数据是放在内存中的，并且默认使用 HASH 索引，但是一旦服务关闭，表中的数据就会丢失掉。
+ MERGE：是一组 MyISAM 表的组合，这些 MyISAM 表必须结构完全相同，MERGE 表本身并没有数据，对 MERGE 类型的表可以进行查询、更新、删除操作，这些操作实际上是对内部 MyISAM 表进行的。
+ TokuDB：第三方引擎，是一个高性能、支持事务处理的MySQL和MariaDB的存储引擎，具有高扩展性、高压缩率、高效的写入性能，支持大多数在线DDL操作。



## 第八章 选择合适的数据类型

CHAR 与 VARCHAR：下表是它们之间的对比，最后一行只适用于 MySQL 运行在非严格模式下面。

![image-20201220145107981](《深入浅出MySQL》笔记/image-20201220145107981.png)

CHAR 长度固定，处理速度快，但是浪费空间存储。对于 MyISAM 和 MEMORY 来说，首选 CHAR，而对于 InnoDB 来说，建议使用VARCHAR类型。

TEXT 与 BLOB：在保存较大文本时，通常会选择使用TEXT或者BLOB。二者之间的主要差别是BLOB能用来保存二进制数据，比如照片；而TEXT只能保存字符数据，比如一篇文章或者日记。

+ BLOB 和 TEXT 值会造成性能问题，在执行删除操作之后，会在数据表中留下很大的空洞，可以定期使用 `OPTIMIZE TABLE` 来进行碎片整理。
+ 使用合成索引来提高大文本字段的查询性能。合成索引就是根据大文本字段的内容建立一个散列值，并把这个值存储在单独的数据列中，接下来就可以通过检索散列值找到数据行了。注意只能用于精确匹配。
+ 在不必要的时候避免检索大型的 BLOB 或 TEXT 值。
+ 把 BLOB 或 TEXT 列分离到单独的表中，以减少主表的碎片

浮点数与定点数：浮点数不是精确的，定点数更加精确。float，doble 都是浮点数，decimal 则是定点数。

日期类型选择：根据实际需要选择能够满足应用的最小存储的日期类型。如果记录的日期需要让不同时区的用户使用，那么最好使用 TIMESTAMP，因为日期类型中只有它能够和实际时区相对应。



## 第九章 字符集

常用字符集比较：

![image-20201220170248401](《深入浅出MySQL》笔记/image-20201220170248401.png)

选择字符集标准：

+ 如果应用要处理各种各样的文字，首选 utf-8
+ 如果应用中涉及已有数据的导入，就要充分考虑数据库字符集对已有数据的兼容性
+ 如果数据库只需要支持一般中文，数据量很大，性能要求也很高，那就应该选择双字节定长编码的中文字符集，比如 GBK
+ 如果数据库需要做大量的字符运算，如比较、排序等，那么选择定长字符集可能更好

MySQL 支持的字符集简介：查看所有可用的字符集的命令是 `show character set`，MySQL 的字符集包含字符集（CHARACTER）和校对规则（COLLATION）两个概念。其中字符集用来定义 MySQL 存储字符串的方式，校对规则用来定义比较字符串的方式。校对规则命名约定：以其相关的字符集名开始，通常包括一个语言名，并且以`_ci`（大小写不敏感）、`_cs`（大小写敏感）或`_bin`（比较是基于字符编码的值而与language无关）结束。

MySQL 字符集设置：有4个级别的默认设置：服务器级、数据库级、表级和字段级。

+ 服务器字符集：可以在 my.cnf 中配置`character-set-server`来设置。
+ 数据库字符集：可以在创建数据库的时候指定，也可以在创建完数据库后通过“alter database”命令进行修改。后者并不能修改之前已经插入的数据的字符集。
+ 表字符集：可以在创建表的时候指定，可以通过 alter table 命令进行修改，同样，如果表中已有记录，修改字符集对原有的记录并没有影响，不会按照新的字符集进行存放。
+ 列字符集：可以定义列级别的字符集和校对规则，主要是针对相同的表不同字段需要使用不同的字符集的情况。

字符集的修改步骤：如果原来的数据库中已经存在数据，那么通过 alter database 或者 alter tablename 的方式并不能修改之前已经插入的数据的字符集。最好先使用 mysqldump 导出表定义，然后手动修改数据集`将SET NAMES character`，最后再次导入数据。



## 第十章 索引的设计和使用

索引概述：索引用于快速找出在某个列中有一特定值的行，对相关列使用索引能提高 SELECT 操作性能的最佳途径，MySQL 支持前缀索引，还支持全文索引。

+ 创建索引：

  ```
  CREATE [UNIQUE|FULLTEXT|SPATIAL] INDEX index_name
  [USING index_type]
  ON tbl_name (index_col_name,. .);
  ```

+ 删除索引：

  ```
  DROP INDEX index_name ON tbl_name;
  ```

索引设计原则：

+ 最适合索引的列是出现在 WHERE 子句中的列，或连接子句中指定的列
+ 使用唯一索引
+ 使用短索引
+ 不过度使用索引

BTREE 索引与 HASH 索引：

+ 使用 HASH 索引的时候，只能用于 = 或者 <> 操作符比较，MySQL 不能确定两个值之间大约有多少行数据
+ 对于 BTREE 索引，当使用 >、<、>=、<=、BETWEEN、!= 或者 <>，或者LIKE 'pattern' 操作符时，都可以使用相关列上的索引



## 第十一章 视图

视图：一种虚拟存在的表，对于使用视图的用户来说透明，视图相对于表的优点有：简单，安全和数据独立。

视图操作：

```
// 创建视图
CREATE [OR REPLACE] VIEW view_name [(column_list)]
AS select_statement
[WITH [CASCADED | LOCAL] CHECK OPTION]
// 修改视图
ALTER VIEW view_name [(column_list)]
AS select_statement
[WITH [CASCADED | LOCAL] CHECK OPTION]
// 删除视图
DROP VIEW [IF EXISTS] view_name [, view_name] . .[RESTRICT | CASCADE]
// 查看视图
SHOW TABLES;
SHOW CREATE VIEW view_name;
```

`WITH [CASCADED | LOCAL] CHECK OPTION`决定了是否允许更新数据使记录不再满足视图的条件，其中`LOCAL`只要满足本视图的条件就可以更新，而`CASCADED`则必须满足所有针对该视图的所有视图的条件才可以更新。



## 第十二章 存储过程和函数

存储过程和函数：它们都是一段 SQL 语句的集合，不同之处在于函数必须有返回值，并且其参数只能是 IN 类型的，合理使用它们可以减少数据传输量，但是在服务器上进行大量的运算也会占用服务器的 CPU，需要综合考虑。

存储过程和函数的相关操作：

```
// 创建
CREATE PROCUDURE p_name ([proc_parameter[,...]])
[characteristic ..] routine_body

CREATE FUNCTION f_name ([func_parameter[,. .]])
RETURNS type
[characteristic ..] routine_body

// 修改
ALTER {PROCEDURE | FUNCTION} sp_name [characteristic . .]

// 调用
CALL sp_name([parameter[,...]])

// 删除
DROP {PROCEDURE | FUNCTION} [IF EXISTS] sp_name

// 查看
SHOW {PROCEDURE | FUNCTION} STATUS [LIKE 'pattern']

```

通常，`routine_body`包含多条语句，为了不出现错误，我们可以使用`DELIMITER $$`命令将语句的结束符从“;”修改成其他符号（$$）。

`characteristic`特征值说明如下：

+ LANGUAGE SQL：说明 BODY 是使用 SQL 语言编写的
+ [NOT] DETERMINISTIC：DETERMINISTIC确定的,即每次输入一样输出也一样的程序，NOT DETERMINISTIC非确定的，默认是非确定的
+ { CONTAINS SQL | NO SQL | READS SQL DATA | MODIFIES SQL DATA }：提供额外信息给服务器
+ SQL SECURITY { DEFINER | INVOKER }：可以用来指定子程序该用创建子程序者的许可来执行，还是使用调用者的许可来执行。默认值是DEFINER

变量的使用：

```
// 定义
DECLARE var_name[,. .] type [DEFAULT value]

// 赋值
SET var_name = expr [, var_name = expr] ..
SELECT col_name[,. .] INTO var_name[,. .] table_expr
```

条件的使用：

```
// 定义
DECLARE condition_name CONDITION FOR condition_value
condition_value: SQLSTATE [VALUE] sqlstate_value | mysql_error_code

// 条件处理
DECLARE handler_type HANDLER FOR condition_value[,...] sp_statement
handler_type: CONTINUE | EXIT | UNDO
condition_value: SQLSTATE [VALUE] sqlstate_value
| condition_name
| SQLWARNING
| NOT FOUND
| SQLEXCEPTION
| mysql_error_code
```

光标使用：

```
// 声明
DECLARE cursor_name CURSOR FOR select_statement

// OPEN -> FETCH -> CLOSE
OPEN cursor_name
FETCH cursor_name INTO var_name[, var_name]..
CLOSE cursor_name
```

流程控制：

```
// IF
IF condition THEN statement_list
[ELSEIF condition THEN statement_list] ...
[ELSE statement_list]
END IF

// CASE
CASE case_value
WHEN when_value THEN statement_list
[WHEN when_value THEN statement_list] ...
[ELSE statement_list]
END CASE

// LOOP，通常结合 LEAVE 使用，LEAVE 作用类似于 BREAK
[begin_label:] LOOP
statement_list
END LOOP [end_label]

// ITERATE：跳过当前循环的剩下的语句，直接进入下一轮循环，类似 CONTINUE

// REPEAT
[begin_label:] REPEAT
statement_list
UNTIL condition
END REPEAT [end_label]

// WHILE
[begin_label:] WHILE condition DO
statement_list
END WHILE [end_label]
```

事件调度器：可以在某个时间点触发操作，或者每隔一段时间执行固定代码：

```
// 时间点
CREATE EVENT myevent
ON SCHEDULE AT CURRENT_TIMESTAMP + INTERVAL 1 HOUR
DO
UPDATE myschema.mytable SET mycol = mycol + 1;
// 时间间隔
CREATE EVENT myevent
ON SCHEDULE EVERY 5 SECOND
DO
UPDATE myschema.mytable SET mycol = mycol + 1;
```



##  第十三章 触发器

触发器操作：

```
// 创建
CREATE TRIGGER trigger_name [BEFORE | AFTER] [INSERT | DELETE | UPDATE]
ON table_name FOR EACH ROW trigger_stmt
// 删除
DROP TRIGGER [schema_name.]trigger_name
// 查看
show triggers
```

触发器使用：在触发器中，使用别名 OLD 和 NEW 来引用发生变化的记录内容。另外，触发器存在如下限制：

+ 触发程序不能调用将数据返回客户端的存储程序
+ 不能在触发器中使用以显式或隐式方式开始或结束事务的语句



































































