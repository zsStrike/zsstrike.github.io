---
title: CentOS 7安装常用软件方法
date: 2020-02-18 16:53:47
tags: ["Linux", "MySQL", "Python"]
---

本文将会在CentOS 7的情况下安装一下常用的开发软件，主要记录在软件安装中遇到的问题和解决问题的方法。

<!-- More -->

## 概述

由于国内的网络等原因，国外的一些资源或者被墙，或者是网络连接的速度慢，这个时候就需要我们使用镜像等网络资源来提高自己获取资源的速度。

## 实例

### MySQL 8.0安装

CentOS 7中可能已经预安装了Mariadb，我们首先可以查询一下是否安装了Mariadb，如果安装了就直接卸载这个数据库：

```bash
rpm -qa | grep mariadb*
rpm -e --nodeps mariadb*
```

接下来下载MySQL官方的Yum Repository并且进行安装，注意具体的版本可以自己选择：

```bash
wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm #根据版本选择
rpm -ivh mysql-community-release-el7-5.noarch.rpm
yum install mysql-server # 安装
```

但是由于网络原因，资源下载速率很慢，这个时候我们可以根据输出信息来决定下载的包。可以在[清华镜像源](https://mirrors.tuna.tsinghua.edu.cn/mysql/yum/mysql80-community-el7/)中下载相应的包，然后按照依赖的关系依次安装。

![1582026273567](./1582026273567.png)

成功安装完成后，我们使用`systemctl start mysqld.service`来启动MySQL，然后通过下面命令登录：

```bash
mysql -u root -p	# 无密码登录，输入密码行回车就行
```

进入到了mysql后，首先赋予用户密码：

```bash
mysql> ALTER user 'root'@'localhost' IDENTIFIED BY '123456';
mysql> FLUSH PRIVILEGES;
```

如果执行第一步报错，说密码太简单：ERROR 1819 (HY000): Your password does not satisfy the current policy requirements。我们可以设置密码的规则：

```bash
mysql> set global validate_password.policy=0;
mysql> set global validate_password.length=1;
```

需要注意的是，在MySQL 5.7中应该按照下列方法设置：

```bash
mysql> set global validate_password_policy=0;
mysql> set global validate_password_length=1;
```

### Python 3.7安装

在CentOS 7中，安装Python 3.7的步骤通常如下：

```bash
# 安装相关编译工具
yum -y install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel

# 下载安装包并且解压
wget https://www.python.org/ftp/python/3.7.0/Python-3.7.0.tar.xz
tar -xvJf Python-3.7.0.tar.xz

# 编译安装
cd Python-3.7.0
./configure
make && make install

# 检验是否成功安装
python3 -V
pip3 -V
```

问题的关键点在于python.org被GFW墙了，根本不能下载Python源码。为此，我们可以在[淘宝镜像](https://npm.taobao.org/mirrors/python/)上先下载源码包，然后按照上述方法安装就行。

### pip2安装

CentOS 7中默认安装了Python 2.7，但是没有预安装pip2命令，使用下面的方法安装就行：

```bash
# 先安装EPEL(Extra Packages for Enterprise Linux)源
yum -y install epel-release
# 接下来安装pip2
yum install python-pip
# 检验安装是否成功
pip2 -V
```

## 总结

遇到外网下载资源不佳的情况下，可以考虑使用国内的镜像源，根据自己下载的软件版本和系统的架构选择相应的软件下载下来，然后编译安装就行。