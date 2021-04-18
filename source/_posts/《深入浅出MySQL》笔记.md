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