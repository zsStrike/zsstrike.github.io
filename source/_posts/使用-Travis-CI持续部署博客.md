---
title: 使用 Travis CI持续部署博客
date: 2020-04-11 17:38:33
tags: ["CI/CD"]
---

本文主要介绍使用 Travis 来自动将我们的博客内容 push 到 Github Page 上，也就是所谓的持续集成/持续部署。

<!-- More -->

## 持续集成

Travis CI 提供的是持续集成服务（Continuous Integration，简称 CI）。它绑定 Github 上面的项目，只要有新的代码，就会自动抓取。然后，提供一个运行环境，执行测试，完成构建，还能部署到服务器。

持续集成指的是只要代码有变更，就自动运行构建和测试，反馈运行结果。确保符合预期以后，再将新代码"集成"到主干。

持续集成的好处在于，每次代码的小幅变更，就能看到运行结果，从而不断累积小的变更，而不是在开发周期结束时，一下子合并一大块代码。

## 使用 Travis 持续部署博客

我们的博客使用 Hexo 生成，博客的仓库是名是`<username>.github.io`。有两个分支，其中 master 分支用于放置我们的内容，而 hexo-project 分支用于存储我们的 hexo 工程文件。

首先登录到官网：travis-ci.org，接着点击右上角个人头像，选择博客的仓库，并且打开开关。一旦我们激活了这个仓库，那么 Travis 就能监听这个仓库的所有变化。

## .travis.yml

Travis 要求项目的根目录下面，必须有一个.travis.yml文件。这是配置文件，指定了 Travis 的行为。该文件必须保存在 Github 仓库里面，一旦代码仓库有新的 Commit，Travis 就会去找这个文件，执行里面的命令。

对于我们的要求，我们只需要配置如下就行：

```yaml
# 开发语言和版本
language: node_js
node_js: stable
# 监听分支
branches:
  only: hexo-project
# 缓存  
cache: 
  directories:
    - node_modules
    
before_install:
  - npm install -g hexo-cli
# 安装依赖  
install: 
  - npm install
  - npm install hexo-deployer-git --save
# 执行脚本  
script:
  - hexo clean
  - hexo g
# 将博客内容部署到 master 分支中
after_success:
  - cd ./public
  - git init
  - git add --all .
  - git commit -m "Travis CI Auto Build"
  - git config user.name "username"
  - git config user.email "emial"
  - git push --quiet --force https://${GH_TOKEN}@${GH_REF} master:master
# 设置环境变量  
env:
  global:
    - GH_REF: github.com/<username>/<username>.github.io.git
```

其中，我们需要获取到`{GH_TOKEN}`，这是用于我们能够正常访问 Github API 的基础。

> Tokens you have generated that can be used to access the [GitHub API](https://developer.github.com/).

可以在`用户->setting->Personal access token`中创建 Token。

之后，在 Travis 网站相应的仓库中设置环境变量就可以了。

另外，如果想要获取 build 的状态图片，可以在 Travis 中将图片的 markdown 格式复制下来，放在 readme.md 中。