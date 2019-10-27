---
title: 使用 mongoose 连接 mongoDB Atlas 云数据库
date: 2019-10-27 14:19:55
tags: ["Nodejs", "MongoDB"]
---

MongoDB 官方提供免费的 500M 的云数据库，该白嫖一波了~

<!--  More  -->

## 获取云数据库

官方提供的数据库需要一个 MongoDB Atlas 账号，在这个页面注册一个就好了。

![signup.png](./signup.png)

注册完成后，可以申请创建一个免费的集群。

![buildcluster.png](./buildcluster.png)

![createcluster.png](./createcluster.png)

接下来就可以创建一个数据库了。

## 云端创建一个数据库

要创建数据库很简单，按照以下步骤：

![createdatabase](./createdatabase.png)

![createcolle](./createcolle.png)

数据库的名字可以自己取，在这里，我选择的是Student数据库，下面有一个 list 的collection。

接下来添加自己IP的白名单：

![whitelist](./whitelist.png)

## 本地连接数据库

现在使用 nodejs 下面的 mongoose 连接我们的数据库。首先需要获取远程数据库的连接：

![connect](./connect.png)

接下来就是启动nodejs，安装mongoose 包：
```js
npm i mongoose -S
```

接着在入口文件中写上测试代码：
```js
const mongoose = require('mongoose');

const uri = "mongodb+srv://strike:<password>@cluster0-u5k7q.mongodb.net/students?retryWrites=true&w=majority";
mongoose.connect(uri, {useNewUrlParser: true, useUnifiedTopology: true})
  .then(() => console.log('connected'))
  .catch(() => console.log('err'));
```

不出意外的话，控制台输出`connected`。同样登录官网也可以查询已经连接到的客户机。



