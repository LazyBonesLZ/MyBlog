---
title: "Mac OS Andriod Studio:Gradle 3.3 requires Java 7 or later to run.You are currently using Java 6"
date: 2017-11-12T16:45:46+08:00
draft: false
categories: [Android]
tags: [Android,Android Studio,Mac,JDK1.8,Gradle3.3]
---

1.project structure设置界面中设置jdk路径是jdk1.7或以上的版本:`File->Project Structure->SDK Location`


![](/img/05_mac_jdk/01.png)





2.修改AS置默认的jdk版本。
(如果是jdk1.8版本的话还需要修改`/Application/Android Studio/Contents/info.plist`)

如何找到该路径？ `Android Studio.app -> 右键 -> 显示包内容`

修改前：

```
<key>JVMVersion</key> <string>1.6*,1.7+</string>

```
修改后：

```
<key>JVMVersion</key> <string>1.8.0_121</string> 
#（这里的版本号根据实际安装的jdk版本来修改）
```