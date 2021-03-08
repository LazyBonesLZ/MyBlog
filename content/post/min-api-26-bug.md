---
title: "Invoke-customs are only supported starting with android 0 --min-api 26"
date: 2019-09-18T16:41:39+08:00
draft: false
categories: [Android]
tags: [Android Studio 3.5,Invoke-customs]


 Android Studio升级到3.5，工程在编译时出现错误：

 ```
 Invoke-customs are only supported starting with android 0 --min-api 26

 ```
 解决方案：

 ```shell
 	android{
 	//...
 	 compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }
 	//...
 	}

 ```
 JavaVersion请根据您开发环境中实际的版本设置。



 参考链接：
 [https://stackoverflow.com/questions/49891730/invoke-customs-are-only-supported-starting-with-android-0-min-api-26](https://stackoverflow.com/questions/49891730/invoke-customs-are-only-supported-starting-with-android-0-min-api-26)
