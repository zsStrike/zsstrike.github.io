---
title: MySQL基本操作
date: 2020-02-19 11:48:27
tags: ["MySQL"]
---

本文介绍MySQL数据库的简单使用方法，包括数据库的启动和连接，以及数据的增删改查等。操作环境在CentOS 7中。

<!-- More -->

## 数据库连接和断开连接

在进行数据库的连接之前，我们需要先启动数据库服务：

```bash
shell> systemctl start mysqld.service
```

数据库连接命令：

```bash
shell> mysql [-h host] -u root -p
Enter password: *****
```

缺省host就表示连接本地的mysql数据库。

数据库断开连接：

```bash
mysql> quit
Bye
```

## 查询

连接到mysql后，可以查询版本信息，当前日期和时间和当前用户：

```bash
mysql> SELECT VERSION(), CURRENT_DATE, NOW(), USER();
+-----------+--------------+---------------------+----------------+
| VERSION() | CURRENT_DATE | NOW()               | USER()         |
+-----------+--------------+---------------------+----------------+
| 8.0.19    | 2020-02-19   | 2020-02-19 18:03:54 | root@localhost |
+-----------+--------------+---------------------+----------------+
1 row in set (0.00 sec)
```

## 创建和使用数据库

查询当前服务器中的数据库有哪些：

```bash
mysql> SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
| test               |
+--------------------+
5 rows in set (0.01 sec)
```

使用某个数据库：

```bash
mysql> USE test;
Database changed
```

在test数据库中创建的任何数据可能会被别人删除，可以让管理员执行以下命令使得只有你能使用某个数据库(menagerie)：

```bash
mysql> GRANT ALL ON menagerie.* TO 'your_mysql_name'@'your_client_host';
```

### 创建和选择数据库

创建新的数据库：

```bash
mysql> CREATE DATABASE menagerie;
Query OK, 1 row affected (0.00 sec)
```

选择数据库：

```bash
mysql> USE menagerie;
Database changed
```

查询当前使用的数据库：

```bash
mysql> SELECT DATABASE();
+------------+
| DATABASE() |
+------------+
| menagerie  |
+------------+
1 row in set (0.00 sec)
```

### 创建表格

展示当前数据库中有哪些表格：

```bash
mysql> SHOW TABLES;
Empty set (0.00 sec)
```

创建新的表格：

```bash
mysql> CREATE TABLE pet (
    -> name VARCHAR(20),
    -> owner VARCHAR(20),
    -> species VARCHAR(20),
    -> sex CHAR(1),
    -> birth DATE,
    -> death DATE);
Query OK, 0 rows affected (0.06 sec)
```

查看表格的表头和描述：

```bash
mysql> DESCRIBE pet;
+---------+-------------+------+-----+---------+-------+
| Field   | Type        | Null | Key | Default | Extra |
+---------+-------------+------+-----+---------+-------+
| name    | varchar(20) | YES  |     | NULL    |       |
| owner   | varchar(20) | YES  |     | NULL    |       |
| species | varchar(20) | YES  |     | NULL    |       |
| sex     | char(1)     | YES  |     | NULL    |       |
| birth   | date        | YES  |     | NULL    |       |
| death   | date        | YES  |     | NULL    |       |
+---------+-------------+------+-----+---------+-------+
```

### 写入数据

使用文件载入数据：

```bash
mysql> LOAD DATA LOCAL INFILE '/usr/local/src/pet.txt' INTO TABLE pet;
Query OK, 8 rows affected, 1 warning (0.00 sec)
Records: 8  Deleted: 0  Skipped: 0  Warnings: 1
```

pet.txt 的内容如下：

```
Fluffy	Harold	cat	f	1993-02-04	\N
Claws	Gwen	cat	m	1994-03-17	\N
Buffy	Harold	dog	f	1989-05-13	\N
Fang	Benny	dog	m	1990-08-27	\N
Bowser	Diane	dog	m	1979-08-31	1995-07-29
Chirpy	Gwen	bird	f	1998-09-11	\N
Whistler	Gwen	bird	\N	1997-12-09	
Slim	Benny	snake	m	1996-04-29	\N
```

其中每条记录之间使用TAB分割，每个行结束符是`\r`，`\N`表示的是NULL值。

> 如果执行命令出错，可能需要先开启local_infile变量：
>
> ```bash
> mysql> set global local_infile = 'ON';
> ```
>
> 然后通过下述命令进入mysql交互环境：
>
> ```bash
> $ mysql --local-infile=1 -u root -p
> ```

同样地，我们可以通过INSERT语句来插入数据：

```bash
mysql> INSERT INTO pet
    -> VALUES ('Puffball', 'Diane', 'hamster', 'f', '1999-3-30', NULL);
Query OK, 1 row affected (0.00 sec)
```

### 从表格中获取信息

从表格获取信息的方式一般形式是：

```bash
SELECT what_to_select
FROM which_table
WHERE conditions_to_satisfy;
```

选择全部数据：

```bash
mysql> SELECT * FROM pet;
+----------+--------+---------+------+------------+------------+
| name     | owner  | species | sex  | birth      | death      |
+----------+--------+---------+------+------------+------------+
| Fluffy   | Harold | cat     | f    | 1993-02-04 | NULL       |
| Claws    | Gwen   | cat     | m    | 1994-03-17 | NULL       |
| Buffy    | Harold | dog     | f    | 1989-05-13 | NULL       |
| Fang     | Benny  | dog     | m    | 1990-08-27 | NULL       |
| Bowser   | Diane  | dog     | m    | 1979-08-31 | 1995-07-29 |
| Chirpy   | Gwen   | bird    | f    | 1998-09-11 | NULL       |
| Whistler | Gwen   | bird    | NULL | 1997-12-09 | 0000-00-00 |
| Slim     | Benny  | snake   | m    | 1996-04-29 | NULL       |
| Puffball | Diane  | hamster | f    | 1999-03-30 | NULL       |
+----------+--------+---------+------+------------+------------+
```

从表中我们发现Bowser的birth值不太正确，我们可以

+ 在pet.txt中修改文件，然后清空pet表格，接着载入数据

  ```bash
  mysql> DELETE FROM pet;
  mysql> LOAD DATA LOCAL INFILE '/usr/local/src/pet.txt' INTO TABLE pet;
  ```

+ 使用UPDATE语句：

  ```bash
  mysql> UPDATE pet SET birth = '1989-08-31' WHERE name = 'Bowser';
  Query OK, 1 row affected (0.00 sec)
  ```

有条件地选择可以通过WHERE来实现：

```bash
mysql> SELECT * FROM pet WHERE name = 'Bowser';
+--------+-------+---------+------+------------+------------+
| name   | owner | species | sex  | birth      | death      |
+--------+-------+---------+------+------------+------------+
| Bowser | Diane | dog     | m    | 1989-08-31 | 1995-07-29 |
+--------+-------+---------+------+------------+------------+

mysql> SELECT * FROM pet WHERE birth >= '1998-1-1';
+----------+-------+---------+------+------------+-------+
| name     | owner | species | sex  | birth      | death |
+----------+-------+---------+------+------------+-------+
| Chirpy   | Gwen  | bird    | f    | 1998-09-11 | NULL  |
| Puffball | Diane | hamster | f    | 1999-03-30 | NULL  |
+----------+-------+---------+------+------------+-------+

mysql> SELECT * FROM pet WHERE species = 'dog' AND sex = 'f';
+-------+--------+---------+------+------------+-------+
| name  | owner  | species | sex  | birth      | death |
+-------+--------+---------+------+------------+-------+
| Buffy | Harold | dog     | f    | 1989-05-13 | NULL  |
+-------+--------+---------+------+------------+-------+

mysql> SELECT * FROM pet WHERE species = 'snake' OR species = 'bird';
+----------+-------+---------+------+------------+-------+
| name     | owner | species | sex  | birth      | death |
+----------+-------+---------+------+------------+-------+
| Chirpy   | Gwen  | bird    | f    | 1998-09-11 | NULL  |
| Whistler | Gwen  | bird    | NULL | 1997-12-09 | NULL  |
| Slim     | Benny | snake   | m    | 1996-04-29 | NULL  |
+----------+-------+---------+------+------------+-------+

mysql> SELECT * FROM pet WHERE (species = 'cat' AND sex = 'm')
       OR (species = 'dog' AND sex = 'f');
+-------+--------+---------+------+------------+-------+
| name  | owner  | species | sex  | birth      | death |
+-------+--------+---------+------+------------+-------+
| Claws | Gwen   | cat     | m    | 1994-03-17 | NULL  |
| Buffy | Harold | dog     | f    | 1989-05-13 | NULL  |
+-------+--------+---------+------+------------+-------+
```

选择特定的列可以通过SELECT语句实现：

```bash
mysql> SELECT name, birth FROM pet;
+----------+------------+
| name     | birth      |
+----------+------------+
| Fluffy   | 1993-02-04 |
| Claws    | 1994-03-17 |
| Buffy    | 1989-05-13 |
| Fang     | 1990-08-27 |
| Bowser   | 1989-08-31 |
| Chirpy   | 1998-09-11 |
| Whistler | 1997-12-09 |
| Slim     | 1996-04-29 |
| Puffball | 1999-03-30 |
+----------+------------+

mysql> SELECT owner FROM pet;
+--------+
| owner  |
+--------+
| Harold |
| Gwen   |
| Harold |
| Benny  |
| Diane  |
| Gwen   |
| Gwen   |
| Benny  |
| Diane  |
+--------+

mysql> SELECT DISTINCT owner FROM pet;
+--------+
| owner  |
+--------+
| Benny  |
| Diane  |
| Gwen   |
| Harold |
+--------+

mysql> SELECT name, species, birth FROM pet
       WHERE species = 'dog' OR species = 'cat';
+--------+---------+------------+
| name   | species | birth      |
+--------+---------+------------+
| Fluffy | cat     | 1993-02-04 |
| Claws  | cat     | 1994-03-17 |
| Buffy  | dog     | 1989-05-13 |
| Fang   | dog     | 1990-08-27 |
| Bowser | dog     | 1989-08-31 |
+--------+---------+------------+
```

数据间的排序可以通过`ORDER BY`实现：

```bash
mysql> SELECT name, birth FROM pet ORDER BY birth;
+----------+------------+
| name     | birth      |
+----------+------------+
| Buffy    | 1989-05-13 |
| Bowser   | 1989-08-31 |
| Fang     | 1990-08-27 |
| Fluffy   | 1993-02-04 |
| Claws    | 1994-03-17 |
| Slim     | 1996-04-29 |
| Whistler | 1997-12-09 |
| Chirpy   | 1998-09-11 |
| Puffball | 1999-03-30 |
+----------+------------+

mysql> SELECT name, birth FROM pet ORDER BY birth DESC;
+----------+------------+
| name     | birth      |
+----------+------------+
| Puffball | 1999-03-30 |
| Chirpy   | 1998-09-11 |
| Whistler | 1997-12-09 |
| Slim     | 1996-04-29 |
| Claws    | 1994-03-17 |
| Fluffy   | 1993-02-04 |
| Fang     | 1990-08-27 |
| Bowser   | 1989-08-31 |
| Buffy    | 1989-05-13 |
+----------+------------+

mysql> SELECT name, species, birth FROM pet
       ORDER BY species, birth DESC;
+----------+---------+------------+
| name     | species | birth      |
+----------+---------+------------+
| Chirpy   | bird    | 1998-09-11 |
| Whistler | bird    | 1997-12-09 |
| Claws    | cat     | 1994-03-17 |
| Fluffy   | cat     | 1993-02-04 |
| Fang     | dog     | 1990-08-27 |
| Bowser   | dog     | 1989-08-31 |
| Buffy    | dog     | 1989-05-13 |
| Puffball | hamster | 1999-03-30 |
| Slim     | snake   | 1996-04-29 |
+----------+---------+------------+
```

和时间相关的处理：

```
mysql> SELECT name, birth, CURDATE(),
       TIMESTAMPDIFF(YEAR,birth,CURDATE()) AS age
       FROM pet;
+----------+------------+------------+------+
| name     | birth      | CURDATE()  | age  |
+----------+------------+------------+------+
| Fluffy   | 1993-02-04 | 2003-08-19 |   10 |
| Claws    | 1994-03-17 | 2003-08-19 |    9 |
| Buffy    | 1989-05-13 | 2003-08-19 |   14 |
| Fang     | 1990-08-27 | 2003-08-19 |   12 |
| Bowser   | 1989-08-31 | 2003-08-19 |   13 |
| Chirpy   | 1998-09-11 | 2003-08-19 |    4 |
| Whistler | 1997-12-09 | 2003-08-19 |    5 |
| Slim     | 1996-04-29 | 2003-08-19 |    7 |
| Puffball | 1999-03-30 | 2003-08-19 |    4 |
+----------+------------+------------+------+

mysql> SELECT name, birth, CURDATE(),
       TIMESTAMPDIFF(YEAR,birth,CURDATE()) AS age
       FROM pet ORDER BY name;
+----------+------------+------------+------+
| name     | birth      | CURDATE()  | age  |
+----------+------------+------------+------+
| Bowser   | 1989-08-31 | 2003-08-19 |   13 |
| Buffy    | 1989-05-13 | 2003-08-19 |   14 |
| Chirpy   | 1998-09-11 | 2003-08-19 |    4 |
| Claws    | 1994-03-17 | 2003-08-19 |    9 |
| Fang     | 1990-08-27 | 2003-08-19 |   12 |
| Fluffy   | 1993-02-04 | 2003-08-19 |   10 |
| Puffball | 1999-03-30 | 2003-08-19 |    4 |
| Slim     | 1996-04-29 | 2003-08-19 |    7 |
| Whistler | 1997-12-09 | 2003-08-19 |    5 |
+----------+------------+------------+------+

mysql> SELECT name, birth, CURDATE(),
       TIMESTAMPDIFF(YEAR,birth,CURDATE()) AS age
       FROM pet ORDER BY age;
+----------+------------+------------+------+
| name     | birth      | CURDATE()  | age  |
+----------+------------+------------+------+
| Chirpy   | 1998-09-11 | 2003-08-19 |    4 |
| Puffball | 1999-03-30 | 2003-08-19 |    4 |
| Whistler | 1997-12-09 | 2003-08-19 |    5 |
| Slim     | 1996-04-29 | 2003-08-19 |    7 |
| Claws    | 1994-03-17 | 2003-08-19 |    9 |
| Fluffy   | 1993-02-04 | 2003-08-19 |   10 |
| Fang     | 1990-08-27 | 2003-08-19 |   12 |
| Bowser   | 1989-08-31 | 2003-08-19 |   13 |
| Buffy    | 1989-05-13 | 2003-08-19 |   14 |
+----------+------------+------------+------+

mysql> SELECT name, birth, death,
       TIMESTAMPDIFF(YEAR,birth,death) AS age
       FROM pet WHERE death IS NOT NULL ORDER BY age;
+--------+------------+------------+------+
| name   | birth      | death      | age  |
+--------+------------+------------+------+
| Bowser | 1989-08-31 | 1995-07-29 |    5 |
+--------+------------+------------+------+

mysql> SELECT name, birth, MONTH(birth) FROM pet;
+----------+------------+--------------+
| name     | birth      | MONTH(birth) |
+----------+------------+--------------+
| Fluffy   | 1993-02-04 |            2 |
| Claws    | 1994-03-17 |            3 |
| Buffy    | 1989-05-13 |            5 |
| Fang     | 1990-08-27 |            8 |
| Bowser   | 1989-08-31 |            8 |
| Chirpy   | 1998-09-11 |            9 |
| Whistler | 1997-12-09 |           12 |
| Slim     | 1996-04-29 |            4 |
| Puffball | 1999-03-30 |            3 |
+----------+------------+--------------+

mysql> SELECT name, birth FROM pet WHERE MONTH(birth) = 5;
+-------+------------+
| name  | birth      |
+-------+------------+
| Buffy | 1989-05-13 |
+-------+------------+
```

模式匹配的规则如下：

```
mysql> SELECT * FROM pet WHERE name LIKE 'b%';
+--------+--------+---------+------+------------+------------+
| name   | owner  | species | sex  | birth      | death      |
+--------+--------+---------+------+------------+------------+
| Buffy  | Harold | dog     | f    | 1989-05-13 | NULL       |
| Bowser | Diane  | dog     | m    | 1989-08-31 | 1995-07-29 |
+--------+--------+---------+------+------------+------------+

mysql> SELECT * FROM pet WHERE name LIKE '%fy';
+--------+--------+---------+------+------------+-------+
| name   | owner  | species | sex  | birth      | death |
+--------+--------+---------+------+------------+-------+
| Fluffy | Harold | cat     | f    | 1993-02-04 | NULL  |
| Buffy  | Harold | dog     | f    | 1989-05-13 | NULL  |
+--------+--------+---------+------+------------+-------+

mysql> SELECT * FROM pet WHERE name LIKE '%w%';
+----------+-------+---------+------+------------+------------+
| name     | owner | species | sex  | birth      | death      |
+----------+-------+---------+------+------------+------------+
| Claws    | Gwen  | cat     | m    | 1994-03-17 | NULL       |
| Bowser   | Diane | dog     | m    | 1989-08-31 | 1995-07-29 |
| Whistler | Gwen  | bird    | NULL | 1997-12-09 | NULL       |
+----------+-------+---------+------+------------+------------+

mysql> SELECT * FROM pet WHERE name LIKE '_____';
+-------+--------+---------+------+------------+-------+
| name  | owner  | species | sex  | birth      | death |
+-------+--------+---------+------+------------+-------+
| Claws | Gwen   | cat     | m    | 1994-03-17 | NULL  |
| Buffy | Harold | dog     | f    | 1989-05-13 | NULL  |
+-------+--------+---------+------+------------+-------+

mysql> SELECT * FROM pet WHERE REGEXP_LIKE(name, '^b');
+--------+--------+---------+------+------------+------------+
| name   | owner  | species | sex  | birth      | death      |
+--------+--------+---------+------+------------+------------+
| Buffy  | Harold | dog     | f    | 1989-05-13 | NULL       |
| Bowser | Diane  | dog     | m    | 1979-08-31 | 1995-07-29 |
+--------+--------+---------+------+------------+------------+

mysql> SELECT * FROM pet WHERE REGEXP_LIKE(name, 'fy$');
+--------+--------+---------+------+------------+-------+
| name   | owner  | species | sex  | birth      | death |
+--------+--------+---------+------+------------+-------+
| Fluffy | Harold | cat     | f    | 1993-02-04 | NULL  |
| Buffy  | Harold | dog     | f    | 1989-05-13 | NULL  |
+--------+--------+---------+------+------------+-------+
```

统计查询数目的条数：

```
mysql> SELECT COUNT(*) FROM pet;
+----------+
| COUNT(*) |
+----------+
|        9 |
+----------+

mysql> SELECT owner, COUNT(*) FROM pet GROUP BY owner;
+--------+----------+
| owner  | COUNT(*) |
+--------+----------+
| Benny  |        2 |
| Diane  |        2 |
| Gwen   |        3 |
| Harold |        2 |
+--------+----------+

mysql> SELECT species, COUNT(*) FROM pet GROUP BY species;
+---------+----------+
| species | COUNT(*) |
+---------+----------+
| bird    |        2 |
| cat     |        2 |
| dog     |        3 |
| hamster |        1 |
| snake   |        1 |
+---------+----------+

mysql> SELECT sex, COUNT(*) FROM pet GROUP BY sex;
+------+----------+
| sex  | COUNT(*) |
+------+----------+
| NULL |        1 |
| f    |        4 |
| m    |        4 |
+------+----------+

mysql> SELECT species, sex, COUNT(*) FROM pet GROUP BY species, sex;
+---------+------+----------+
| species | sex  | COUNT(*) |
+---------+------+----------+
| bird    | NULL |        1 |
| bird    | f    |        1 |
| cat     | f    |        1 |
| cat     | m    |        1 |
| dog     | f    |        1 |
| dog     | m    |        2 |
| hamster | f    |        1 |
| snake   | m    |        1 |
+---------+------+----------+

mysql> SELECT species, sex, COUNT(*) FROM pet
       WHERE species = 'dog' OR species = 'cat'
       GROUP BY species, sex;
+---------+------+----------+
| species | sex  | COUNT(*) |
+---------+------+----------+
| cat     | f    |        1 |
| cat     | m    |        1 |
| dog     | f    |        1 |
| dog     | m    |        2 |
+---------+------+----------+

mysql> SELECT species, sex, COUNT(*) FROM pet
       WHERE sex IS NOT NULL
       GROUP BY species, sex;
+---------+------+----------+
| species | sex  | COUNT(*) |
+---------+------+----------+
| bird    | f    |        1 |
| cat     | f    |        1 |
| cat     | m    |        1 |
| dog     | f    |        1 |
| dog     | m    |        2 |
| hamster | f    |        1 |
| snake   | m    |        1 |
+---------+------+----------+
```

使用多个表格：

```
mysql> LOAD DATA LOCAL INFILE 'event.txt' INTO TABLE event;

mysql> SELECT pet.name,
       TIMESTAMPDIFF(YEAR,birth,date) AS age,
       remark
       FROM pet INNER JOIN event
         ON pet.name = event.name
       WHERE event.type = 'litter';
+--------+------+-----------------------------+
| name   | age  | remark                      |
+--------+------+-----------------------------+
| Fluffy |    2 | 4 kittens, 3 female, 1 male |
| Buffy  |    4 | 5 puppies, 2 female, 3 male |
| Buffy  |    5 | 3 puppies, 3 female         |
+--------+------+-----------------------------+

mysql> SELECT p1.name, p1.sex, p2.name, p2.sex, p1.species
       FROM pet AS p1 INNER JOIN pet AS p2
         ON p1.species = p2.species
         AND p1.sex = 'f' AND p1.death IS NULL
         AND p2.sex = 'm' AND p2.death IS NULL;
+--------+------+-------+------+---------+
| name   | sex  | name  | sex  | species |
+--------+------+-------+------+---------+
| Fluffy | f    | Claws | m    | cat     |
| Buffy  | f    | Fang  | m    | dog     |
+--------+------+-------+------+---------+
```

### 从数据库或者表格中获取相关信息

查询当前所有的数据库：

```
mysql> SHOW DATABASES;
```

查询当前数据库中含有的表格：

```
mysql> SHOW TABLES;
```

查询某个表格的表头和属性：

```
mysql> DESCRIBE pet;
```

查询当前所在的数据库：

```
mysql> SELECT DATABASE();
```

### 使用脚本运行MySQL指令

运行脚本的指令如下：

```bash
shell> mysql -u root -p < batch-file
Enter password: *****
```

可以通过如下方法来查看或者将输出保存到文件：

```
shell> mysql -u root -p < batch-file | more
shell> mysql -u root -p < batch-file > mysql.out
```

在batch模式和交互模式输出的内容会有不同，可以使用`-t`参数来得到交互模式下的输出；想要在输出语句中包含执行的指令，可以使用`-v`参数。

![1582114003008](./1582114003008.png)

也可以在连接mysql后通过`source`或者`\`来运行脚本：

```
mysql> source batch-file
mysql> \ filename
```

### 常用的查询语句

首先创建shop表单：

```
mysql> CREATE TABLE shop(
    -> article INT UNSIGNED DEFAULT '0000' NOT NULL,
    -> dealer CHAR(20) DEFAULT '' NOT NULL,
    -> price DECIMAL(16, 2) DEFAULT '0.00' NOT NULL,
    -> PRIMARY KEY(article, dealer));
```

接着插入数据：

```
mysql> INSERT INTO shop VALUES
    -> (1, 'A', 3.45), (1, 'B', 3.99), (2, 'A', 10.99), (3, 'B', 1.45),
    -> (3, 'C', 1.69), (3, 'D', 1.25), (4, 'D', 19.95);
```

1. 最大的article值：

   ```
   mysql> SELECT MAX(ARTICLE) FROM shop;
   ```

2. 找到价格最大的记录：

   ```
   mysql> SELECT * FROM shop WHERE price = (SELECT MAX(price) FROM shop);
   ```

3. 找到每种物品的最大价格：

   ```
   mysql> SELECT article, MAX(price) FROM shop
       -> GROUP BY article;
   ```

4. 对每种物品，找到最贵价格的dealer：

   ```
   mysql> SELECT article, dealer, price
   	  FROM   shop s1
   	  WHERE  price=(SELECT MAX(s2.price)
          		       FROM shop s2
                 	    WHERE s1.article = s2.article)
   	  ORDER BY article;
   ```

5. 使用用户定义的变量：

   ```bash
   mysql> SELECT @min_price:=MIN(price),@max_price:=MAX(price) FROM shop;
   mysql> SELECT * FROM shop WHERE price=@min_price OR price=@max_price;
   ```

### 使用AUTO_INCREMENT

我们可以创建animals的表格：

```
CREATE TABLE animals (
     id MEDIUMINT NOT NULL AUTO_INCREMENT,
     name CHAR(30) NOT NULL,
     PRIMARY KEY (id)
);
```

然后在插入的时候可以不用设置id的值：

```
INSERT INTO animals VALUES (NULL, 'dog'), (NULL, 'pig');
```

## MySQL备份和恢复

### SQL文件格式

备份全部数据库：

```
shell> mysqldump -u root -p --all-databases > dump.sql
```

备份某些特定的数据库：

```
shell> mysqldump -u root -p --databases db1 db2 > dump.sql
```

备份某个数据库的某些表格：

```
shell> mysqldump -u root -p db1 tb1 tb2 > dump.sql
```

恢复文件内容：

```
shell> mysql -u root -p < dump.sql
```

对于那些SQL文件中没有事先选择数据库的，可以先进入mysql，然后使用：

```
mysql> USE db1;
mysql> source dump.sql;
```

### 使用分割文本格式

备份数据库：

```
shell> mysqldump -u root -p --tab=/dir_name db1
```

> 如果报错：Got error: 1290: The MySQL server is running with the --secure-file-priv option so it cannot execute this statement when executing 'SELECT INTO OUTFILE'，我们可以使用如下方法来解决：
>
> `mysql> show global variables like '%secure%'`
> 
> 查看secure-file-priv对用的目录，然后将上面的`dirname`改为对应的目录就可以。

恢复文件内容：

```
shell> mysql -u root -p db1 < t1.sql
shell> mysqlimport db1 t1.txt
```

或者在mysql环境下：

```
mysql> USE db1;
mysql> LOAD DATA INFILE 't1.txt' INTO TABLE t1;
```

