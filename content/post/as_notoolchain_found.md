---
title: "No toolchains found in the NDK toolchains folder for ABI with prefix: mips64el-linux-android"
date: 2019-06-14T16:27:33+08:00
draft: false
categories: [Android]
tags: [Android Studio,No toolchains found,mips64el-linux-android]
---

最近新项目需求可能用到身份证的扫描读取功能，就提前研究一下百度提供的OCR接口，下载官方demo导入Android studio后居然报错：
```
No toolchains found in the NDK toolchains folder for ABI with prefix: mips64el-linux-android
```
 突然就懵逼了。这是个什么错误？
 无从下手的情况下，只好开启Google大法。

 因为本地安装的 AS版本是3.2，但是百度demo中配置的是gradle 2.2.3

 ``` shell
 dependencies {
     classpath 'com.android.tools.build:gradle:2.2.3'

 }
 ```
 最直接的解决方案就是改成gradle3.2.1

 ``` shell
 dependencies {
     classpath 'com.android.tools.build:gradle:3.2.1'

 }
 ```

 作为开发经验简单记录一下。最根本的原因应该是本地的ndk-bundle中toolchain安装不全导致。。。详细的分析和解决方案：[点我吧！！](https://medium.com/@ivancse.58/how-to-resolve-no-toolchains-found-in-the-ndk-toolchains-folder-for-abi-with-prefix-b37086380193)

 ---
 English Doc
 ---


Recently, the demand for new projects may use the scanning and reading function of the ID card. I will study the OCR interface provided by Baidu in advance, and download the official demo to import Android Studio and report an error:
 ```
 No toolchains found in the NDK toolchains folder for ABI with prefix: mips64el-linux-android
 ```
 Suddenly it was forced. What is wrong with this? In the absence of the start, I had to open Google Dafa.

Because the locally installed AS version is 3.2, but the Baidu demo is configured with gradle 2.2.3.

  ``` shell
  dependencies {
      classpath 'com.android.tools.build:gradle:2.2.3'

  }
  ```
  The most straightforward solution is to change to gradle3.2.1

  ``` shell
  dependencies {
      classpath 'com.android.tools.build:gradle:3.2.1'

  }
  ```

Simply record as a development experience. The most fundamental reason should be caused by the incomplete installation of the toolchain in the local ndk-bundle. . . Detailed analysis and solutions：[Click me!!](https://medium.com/@ivancse.58/how-to-resolve-no-toolchains-found-in-the-ndk-toolchains-folder-for-abi-with-prefix-b37086380193)
