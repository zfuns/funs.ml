---
layout: post
title:  "在Termux安装各种linux系统"
date:   2017-03-02 10:42:06 +0800
categories: Termux
image:
tags: Termux
comments: true
---
只支持`aarch64``arm`   
下载安装脚本:   
`$ wget http://funs.ml/file/atilo`   
设置执行权利:   
`$ chmod +x atilo`   
`$ ./atilo`   
用法试例:   
`$ ./atilo arch`   将会安装archlinux在termux里   
`$ ./atilo -r arch`    将会删除arch所有文件   

### 设置中文
修改`/etc/locale.gen`文件   
去掉#zh_CN.UTF-8前面的#号   
保存后输入   
`$ locale-gen zh_CN.UTF-8`   
`$ export LC_ALL="zh_CN.UTF-8"`   
就成中文了   

### 启动桌面:
先安装xserver xsdl.apk    
打开xserver xsdl   
`$ pacman -S lxde`   
`$ export DISPLAY=:0`   
`$ export PULSE_SERVER=tcp:127.0.0.1:4712`   
`$ startlxde`   
回到xserver xsdl就显示桌面了.-   
