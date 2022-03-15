---
title: Deepin 使用手册
date: 2022-04-03 16:41:22
tags: ["Linux"]
---

本文用于记录在使用 Deepin 20.x 过程中遇到的问题以及解决方案。

<!-- More -->

## 阿里云盘挂载

通过 [aliyundrive-webdav](https://github.com/messense/aliyundrive-webdav) 下载插件为阿里云盘提供 webdav 服务，获取 refresh_token 后在命令行执行命令即可开启 webdav 服务器。

安装 [rclone](https://github.com/rclone/rclone) ，该插件可以为 webdav 服务提供中间层，在其上创建一个 vfs，同时能够提供缓存等功能，这样的话，使用 Deepin 文管能够流畅访问云数据。

在 `～/.config/autostart` 中添加对应的 desktop 文件，用于自启动 webdav 服务器，同时通过 `rclone mount` 用来挂载对应的云盘数据。

启动脚本如下：

```shell
#!/bin/bash

nohup /home/strike/.local/bin/aliyundrive-webdav \
-r 537e938f650f4cfe97f4997825186e17 \
--port 7963 \
-U admin \
-W admin \
> /home/strike/.config/autostart/aliyun.log 2>&1 &

sleep 3

# not support poll-interval
nohup /usr/bin/rclone mount aliyun:/ /mnt/aliyun \
--cache-dir /media/strike/HHD/AliyunCache \
--dir-cache-time 100h \
--vfs-cache-mode full \
--vfs-cache-max-age 500h \
--vfs-read-chunk-size 10M \
--vfs-read-ahead 10M \
--buffer-size 10M \
--vfs-read-chunk-size-limit 100M \
--log-file /home/strike/.config/autostart/aliyun.log \
--log-level INFO &

```

