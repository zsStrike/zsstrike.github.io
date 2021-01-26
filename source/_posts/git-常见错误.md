---
title: git 常见错误
date: 2019-10-27 20:32:26
tags: ["Git"]
---

整理在使用 Git 过程中的一些总结。

<!--  More -->

## cherry-pick

用于将一些修改应用到当前工作的分支上：

```bash
git cherry-pick <commitHash> | <HashA>..<HashB>
```

上面的命令分别表示应用 `<commitHash>` 以及 (HashA, HashB] 到当前工作的分支上。

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

