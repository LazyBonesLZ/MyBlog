---
title: "Android ps查询进程线程信息"
date: 2020-04-23T16:00:24+08:00
draft: fasle
categories: [Android]
tags: [Android,进程线程信息]
---

Android应用开发过程中，可能需要分析进程中的线程信息来为优化性能提供帮助。

在Android 8版本之前的设备，可以直接使用`adb shell ps`来查询所有的进程信息，也可使用 `adb shell ps -t|grep <pid>`来查询某个具体进程的线程信息。

但是在Android 8以及之后版本的设备上，无法直接使用`adb shell ps`命令，取而代之的是`adb shell ps -A`来查询所有进程信息。但是无法再查询某个进程里线程的信息。

参考博客: [https://blog.csdn.net/aaajj/article/details/86702289](https://blog.csdn.net/aaajj/article/details/86702289)
