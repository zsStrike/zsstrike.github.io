---
title: hexo和typora搭配写博客
date: 2020-10-21 14:17:54
tags: ["Hexo", "Typora"]
---

本文介绍使用Typora写博客，使用Hexo发布文章的技巧。主要涉及图片的路径问题。

<!-- More -->

## 解决Hexo图片路径问题

在使用Typora的时候，首先进入到Typora的设置里面，将图片插入格式改为如下设置：

![image-20201021142301183](hexo和typora搭配写博客/image-20201021142301183.png)

这样的话，在写作的时候，我们就可以实时预览到自己插入的图片了。

接着，在博客仓库的`_config.yml`中设置`post_asset_folder: true`。

但是这样设置的话会产生一个问题，就是在执行`hexo g`的时候，得到的博客文章路径会多一个`{{title}}`,导致图片在发布的时候渲染不出来。为了解决这个问题，可以使用`hexo-typora-img`，

```bash
npm i hexo-typora-img
```

这个插件会将原来的路径在渲染前将其改为Hexo可以识别的图片路径，从而在预览发布的时候也可以看到图片。