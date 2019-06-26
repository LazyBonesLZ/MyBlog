---
title: "Android:Zbar 解码、ZXing 管理相机的补充（Zbar支持64位）"
date: 2015-09-24T16:22:52+08:00
draft: false
categories: [Android]
tags: [Android,ZXing,Zbar,扫描解码]
---

# 一. 前言

      最近公司项目用到了扫描的功能，参考网上的博文解决大部分的问题（[http://blog.csdn.net/b2259909/article/details/43273231](http://blog.csdn.net/b2259909/article/details/43273231)（对原文作者表示感谢）），但是后来APK在客户的64位设备上运行时，出现了崩溃的问题，联调时因为参考上述文章的资料，只有32位的so库。
      
为了备忘和帮助像我遇到同样问题的同学，特写此文。



# 二 编译

    原文作者已经提供了足够的资源，现在我们主要是对Zbar的源码重新编译一下，生成支持64位设备的so库。

1.NDK安装：

   （1）操作系统：Win10，64位。

   （2）下载最新的NDK，我下载的是android-ndk-r10d ，直接网上找到的exe安装包，点击下载[android-ndk-r10d-windows-x86_64.exe](https://download.csdn.net/download/guangzhen87/8500163)，安装完成后，配置NDK环境变量。



　1) 添加两个系统环境变量：

　　NDK_ROOT 你的文件位置:F:\01_Android\02_Cocos2dx\android-ndk-r10d

　　PATH 添加一条%NDK_ROOT%;

         

    2)管理员命令提示符输入：ndk-build -version，如下表示配置成功

![](/img/04_zxing/01.png)

2. 下载Zbar  NDK 工程（修改后的）
，[点击下载](https://download.csdn.net/download/long1216/9136757)

原文作者也有提供该工程的下载连接，但是下载后不能编译，需要稍微修改一下jni文件夹下的Android.mk和Application.mk,(原工程Android.mk配置的路径需要重新修改），使得工程可编译通过且支持64位的android设备。

3. 编译工程

（1）进入下载解压后的工程目录，shift +右键，打开命令窗口，执行ndk-build命令，如图所示

     ![](/img/04_zxing/02.png)

     ![](/img/04_zxing/03.png)

（2） 等待执行编译结束，如下图所示
 
	![](/img/04_zxing/04.png)
      

（3）编译结束后，在工程根目录/libs下，就生成了对应的的so库，如图所示，拷贝到android工程中，就可以使用了。

![](/img/04_zxing/05.png)