---
title: Nodejs 用户注册登录和授权处理
date: 2020-04-11 15:27:40
tags: ["Nodejs"]
---

本文介绍 Nodejs 搭配 Express 框架实现服务器中常见的功能：用户注册登录和授权的处理。

<!-- More -->

## 用户注册逻辑

首先我们新建一个 Express 服务器：

```js
// server.js
const express = require('express')

const app = express()
// 处理 POST 中的 Body 数据
app.use(express.json())

app.listen(3000)
```

接着使用 MongoDB 来新建一个 Collection 的 Model 对象：

```js
// models.js
const mongoose = require('mongoose')

mongoose.connect('mongodb://localhost:27017/test', {
  useNewUrlParser: true,
  useUnifiedTopology: true,
  useCreateIndex: true
})

const UserSchema = new mongoose.Schema({
  username: {
    type: String,
    required: true,
    unique: true
  },
  password: {
    type: String,
    required: true,
  }
})

const User = mongoose.model('User', UserSchema)

module.exports = { User }

```

其中，`username`是不能重复的。

接下来，创建用户注册请求路由：

```js
// server.js
app.post('/api/register', (req, res) => { 
  const jsonData = req.body
  const user = new User(jsonData)
  user.save((err, user) => {
    if(err){
      res.json({msg: 'failed to save'})
      return console.log(err)
    }
    res.json(user)
  })
})
```

为了测试接口，可以下载 VSCode 扩展商店中`REST Client`，用于发送 HTTP 请求和检测响应的数据。

安装完成后，编写用户注册请求：

```txt
// test.http
@baseUrl=http://localhost:3000/api

### 注册
POST {{baseUrl}}/register HTTP/1.1
Content-Type: application/json

{
    "username": "user1",
    "password": "password1"
}
```

当发送请求后，可以得到服务器返回的数据。

但是这样的话，**我们存入的用户密码是明文存储的，不是很安全**，为此我们需要在数据存入的时候，对密码进行 hash 处理，在此使用`bcrypt`进行哈希：

```js
// models.js
const bcrypt = require('bcrypt')

const UserSchema = new mongoose.Schema({
  username: {
    type: String,
    required: true,
    unique: true
  },
  password: {
    type: String,
    required: true,
    set(val) {	// 存入的时候先进行 hash 
      return bcrypt.hashSync(val, 10)
    }
  }
})
```

> A library to help you hash passwords. Based on the [Blowfish](https://en.wikipedia.org/wiki/Blowfish_(cipher)) cipher.

### 用户登录

接下来，创建用户登录请求路由：

```js
// server.js
app.post('/api/login', (req, res) => {
  const userData = req.body
  User.findOne({
    username: userData.username
  }, (err, user) => {
    if(err || !user) {
      return res.status(422).json({msg: '非法用户名'})
    }
    const isValid = bcrypt.compareSync(userData.password, user.password)
    if(!isValid){
      return res.status(422).json({msg: '密码错误'})
    }
    res.json({
      user
    })
  })
})
```

根据用户输入的密码和哈希处理的密码进行比对，判断用户输入的密码是否正确。这是基本的用户登录流程的处理。

但是我们希望用户登录之后能够保存这些状态，传统处理方法是：用户登陆成功后，产生 Session_ID 并且将其发送给客户端使其保存在 Cookie 中，之后客户端每次请求都携带 Session_ID。

在此，我们使用 JsonWebToken 来保存我们的数据，将其发送到客户端，客户端保存在 LocalStorage 中，根据其中的数据来保存用户的状态。

修改用户登录路由：

```js
app.post('/api/login', (req, res) => {
  console.log(req.body)
  const userData = req.body
  User.findOne({
    username: userData.username
  }, (err, user) => {
    if(err || !user) {
      return res.status(422).json({msg: '非法用户名'})
    }
    const isValid = bcrypt.compareSync(userData.password, user.password)
    if(!isValid){
      return res.status(422).json({msg: '密码错误'})
    }
   	// jwt token
    const token = jwt.sign({
      id: user._id
    }, SECRET)
    res.json({
      user,
      token
    })
  })
})
```

注意，本文中为了演示，将`SECRET`硬编码进了 server.js 中，更实际的情况时我们将其保存在一个被 gitignore 的文件中，通过读取文件配置 `SECRET`。

### 用户授权

当用户登录之后，客户端保存下来了 token 值，接下来假设用户想要获取个人信息，这只有在用户登录之后才有权限进行操作，为此就需要 token 的帮助了：

```
### 获取个人信息
GET {{baseUrl}}/profile HTTP/1.1
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjVlOTE2OWVhYmNlZWNkM2I2YTI0NDg2OSIsImlhdCI6MTU4NjU4ODYyMn0.VZb_0Rlw27mAShcJCRpoURenfy8IoluGgQ-VDwkqyFM
```

上面是用户发送的请求，其中 Authorization 头部的格式如下：

`Authorization: <type> <credentials>`

接下来处理这个请求路由：

```js
app.get('/api/profile', (req, res) => {
  const tokenData = req.headers.authorization.split(' ').pop()
  const token = jwt.verify(tokenData, SECRET)
  User.findOne({
    _id: token.id
  }, (err, user) => {
    if(err){
      return res.json({msg: 'error token'})
    }
    res.json({msg: 'your profile', user: req.user})
  })
})
```

这样我们就能够根据请求的 Authorization 头获取到用户的信息了。这就是用户授权的基本过程。

另外，如果有很多需要用户登陆之后操作，我们需要将用户验证这个操作转换成中间件的形式，这样就能够在多个路由中使用这个中间件了：

```js
const auth = (req, res, next) => {
  const tokenData = req.headers.authorization.split(' ').pop()
  const token = jwt.verify(tokenData, SECRET)
  User.findOne({
    _id: token.id
  }, (err, user) => {
    if(err){
      return res.json({msg: 'error token'})
    }
    req.user = user
    next()
  })
}

app.get('/api/profile', auth, (req, res) => {
  res.json({msg: 'your profile', user: req.user})
})
```

至于 token 的过期时间我们可以使用预定义的键`exp`来设置过期时间。