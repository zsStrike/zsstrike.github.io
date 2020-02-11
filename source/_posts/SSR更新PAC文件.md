---
title: SSR更新PAC文件
date: 2020-02-11 13:03:23
tags: ["SSR"]
---

SSR项目已经不再维护，它的PAC文件更新功能已经失效，本文我们将gfwlist.txt转换为pac.txt给SSR软件使用。

<!-- More -->

虽然原来的PAC地址已经失效了，但是gfwlist项目组维护了被墙的网站，GitHub地址：https://github.com/gfwlist/gfwlist/ 。首先，我们下载gfwlist.txt：

```bash
curl https://raw.githubusercontent.com/gfwlist/gfwlist/master/gfwlist.txt > gfwlist.txt
```

接下来，我们需要安装Python的包`genpac`：

```bash
pip install genpac
```

安装完成后，使用`genpac`将文件gfwlist.txt转换为pac.txt：

```bash
genpac --pac-proxy="SOCKS 127.0.0.1:1080" --gfwlist-local="./gfwlist.txt" -o pac.txt
```

接下来将生成的pac.txt文件覆盖掉原来SSR软件的pac.txt即可。