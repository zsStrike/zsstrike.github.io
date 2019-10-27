---
title: git 常见错误
date: 2019-10-27 20:32:26
tags: ["git"]
---

整理在使用 git 过程中遇到的问题以及解决方法。

<!--  More -->

## shallow update not allowed

这个问题的产生原因是在克隆远程仓库的时候采用了以下命令：

```bash
git clone --depth=<num> <remote-url>
```

这将会导致`shallow clone`(浅复制)。这将会使得这个仓库不能向远程仓库进行`push`。
通过以下命令可修复：
```bash
git fetch --unshallow <remote-repo>
```

