---
title: "Linux Alias 别名传入参数"
date: 2021-07-09T18:03:55+08:00
draft: false
categories: [Linux]
tags: [Linux,Alias,Parameters]
---

Linux alias命令用来设置指令的别名，对一些较长的命令进行简化。使用alias时，必须使用单引号将原来的命令包含，防止特殊字符导致错误。

```shell
alias 别名='原命令 -选项/参数'
```
但是 `alias`是不能直接接受参数输入。以`CocoaPods`的`pod update` 命令为例，其原始命令为：

```shell
pod update --project-directory=<project path>
```
每次执行`pod update`都需要传入`podfile`文件所在的工程目录路径。所以，为了简化该命令，可以在`.brash_profile`中加入`alias`:

```shell
alias podupdate='myfunction(){ pod update --project-directory=$1;  unset -f myfunction; }; myfunction'
```
即自定义方法`myfunction`,以`$1`接受传入的参数。所以简化之后，就可以以别名执行：

```shell
podupdate <your-ios-projcet path>
```

参考：[https://stackoverflow.com/questions/7131670/make-a-bash-alias-that-takes-a-parameter](https://stackoverflow.com/questions/7131670/make-a-bash-alias-that-takes-a-parameter)