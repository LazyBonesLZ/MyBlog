---
title: "Android Studio3.3.2 发布Kotlin项目到Jcenter"
date: 2019-04-17T11:42:49+08:00
draft: false
categories: [Android]
tags: [Android,Android Studio3.3.2,Kotlin,Push to JCenter]
---


# 概述
纸上得来终觉浅。

一直以为发布AAR到jcenter是非常简单的事，跟发布到私有服务器nexus应该没太多差别。没想到自己动手做过才知道千万道坑。

本文将记录在Android Studio 3.3.2下，如何上传用kotlin开发的aar到jcenter服务器以及遇到的问题。参考来自[这篇博文](https://www.open-open.com/lib/view/open1435109824278.html)，写的非常好，详细的介绍了许多的基本概念和发布步骤。

# 一、 注册Jcenter 个人账号

这里请注意，[Bintray官网](https://bintray.com)，请选择“For an Open Source Account” [注册账号](https://bintray.com/signup/oss)。

![](/img/01_jcenter/01.png)


# 二、创建Repository和Package

以本次测试的工程为例，我想在Jcenter上发布一个测试的Android SDK, 自定义命名为LazySDK, 该SDK下目前只包含一个Sub-SDK包：customviews, 该包主要是封装一些日常项目中常用的view。所以我可以在Bintray先创建一个仓库命名为LazySDK,然后在仓库中再创建一个包为customviews.

* 第一步：创建Reprository:

![](/img/01_jcenter/02.png)
点击"Add New Repository"
![](/img/01_jcenter/03.png)
输入仓库名称， Type选择“Maven”

* 第二部：创建Package

进入第一步创建的仓库“LazySDK",新建Package,然后填写Package name等基本信息后保存:

![](/img/01_jcenter/04.png)

点击“Add New Package”

![](/img/01_jcenter/05.png)

补充完整截图中选中的必填字段，其他信息不用管


# 三、配置Android Studio工程

在准备配置之前，请先确保工程没有错误。以本次测试为例：本地创建了一个LazySDK的工程，Kotlin为开发语言，工程中依赖Module：customviews.

![](/img/01_jcenter/06.png)




第一步：配置upload脚本

（1）在project build.gradle文件中配置dependencies:

``` shell
dependencies {

    classpath 'com.android.tools.build:gradle:3.3.2'

    classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"

    classpath 'com.jfrog.bintray.gradle:gradle-bintray-plugin:1.8.4'

    classpath 'com.github.dcendents:android-maven-gradle-plugin:2.1'

    classpath 'org.jetbrains.dokka:dokka-android-gradle-plugin:0.9.18'

}
```

(2)在project目录下创建:  [jcenter_push.gradle](https://github.com/LazyBonesLZ/LazySDK/blob/master/jcenter_push.gradle)

(3)在library moudle builde.gradle中引用 jcenter_push.gradle, 首先在ext中配置 jcenter_push.gradle需要用到的变量值，这个样做的目的是如果以后工程依赖多个module的时候，先在各自的build.gradle中定义跟自己相关的仓库名称等信息，然后共用一个jcenter_push.gradle. （未验证）

``` shell
ext {

    bintrayRepo ='LazySDK'

    bintrayName ='customviews'

    publishedGroupId ='com.lazy.sdk'

    libraryName ='customviews'

    artifact ='customviews'

    libraryDescription ='Custom vies on Android'

    siteUrl ='https://github.com/LazyBonesLZ/LazySDK.git'

    gitUrl ='https://github.com/LazyBonesLZ/LazySDK.git'

    libraryVersion ='0.0.1'

    developerId ='lazyboneslz'

    developerName ='TJL'

    developerEmail ='lazybonestjl@gmail.com'

    licenseName ='The Apache Software License, Version 2.0'

    licenseUrl ='http://www.apache.org/licenses/LICENSE-2.0.txt'

    allLicenses = ["Apache-2.0"]

}

apply from: '../jcenter_push.gradle'

```

# 四、install & upload

（1）执行 `./gradlew install`, 验证是否有问题，如果一切顺利，你会看到 Build Successful

(2) 然后执行： `./gradlew bintrayUpload`，如果一切顺利，你会看到 Build Successful

# 五、Add to Jcenter

到目前为止，上传的SDK还没有正式发布到Jcenter，只在你自己的Bintray的Maven仓库。你可以在project 的`build.gradle`中指定repository url来使用。

``` shell
repositories {

     maven{

        url 'https://dl.bintray.com/lazyboneslz/LazySDK/'

      }

        google()

        jcenter()

}
```

然后在app build.gradle添加`dependencies`

```shell
implementation com.lazy.sdk:customviews:0.0.1'
```

这种通过配置repository url来引用的方式，不是最好的方式，我们不可能有10个仓库，就配置10个URL吧？ 所以，需要把sdk发送到Jcenter服务器，这样我们就可以不用配置自定义的repository url了。


![](/img/01_jcenter/07.png)

直接点击"Add to JCenter"
 然后直接点击“Send"，不用填写任何信息都可以。
![](/img/01_jcenter/08.png)



点击send
然后就等JCenter 审核，一般需要几个小时。我是头一天12点左右发送的，但是等了一下午都没看到通过。第二天上班发现已经通过了，可以不配置自定义的repository url 直接引用JCenter所上传 SDK。
![](/img/01_jcenter/09.png)



审核通过后，会看到图标已经发生了变化
# 六、[Github源码](https://github.com/LazyBonesLZ/LazySDK)

# 七、备注

本次测试并没有按照所参考的博文那样，自动将内容同步到maven central , 所以并未配置GPG相关的信息。



=========================================>

# 八、遇到的问题

1. Javadoc generation failed. Generated Javadoc options file (useful for troubleshooting): 'xxx/javadoc/javadoc.options':

本项目是kotlin开发，在配置中如下配置：

(1) 在project build.gradle文件中配置`dependencies`:

``` shell
dependencies {

   ........

    classpath 'org.jetbrains.dokka:dokka-android-gradle-plugin:0.9.18'

}
```
(2) 在`jcenter_push.gradle`中加入：

``` shell
if (project.hasProperty("kotlin")) {//Kotlin libraries

    task sourcesJar(type: Jar) {

       classifier ='sources'

        from android.sourceSets.main.java.srcDirs

}

task javadoc(type: Javadoc,dependsOn: dokka) {

}

}else if (project.hasProperty("android")) {// Android libraries

    task sourcesJar(type: Jar) {

classifier ='sources'

        from android.sourceSets.main.java.srcDirs

}

task javadoc(type: Javadoc) {

source = android.sourceSets.main.java.srcDirs

classpath +=project.files(android.getBootClasspath().join(File.pathSeparator))

}

}else {// Java libraries

    task sourcesJar(type: Jar,dependsOn: classes) {

classifier ='sources'

        fromsourceSets.main.allSource

    }

}

//解决kotlin javadoc.options抱错

dokka {

outputFormat ='html'

    outputDirectory ="$buildDir/javadoc"

}
```

2 . Unable to upload files: Maven group, artifact or version defined in the pom file do not match the file path 'xx/xxxxx.pom'

这个错误困扰了我很久，在网上都各种research，发现大多都是说工程中的module名称必须和artifactid一致，我按照提示改成一致以后问题依然存在，百思不得琪姐。最后去[https://github.com/bintray/gradle-bintray-plugin] (https://github.com/bintray/gradle-bintray-plugin) 查解释，也没发现什么特别需要的注意的地方。后来仔细对比官方demo的gradle，发现它还声明了group的值，而我是参看博文中的脚本来做，却没有group的相关声明，最后加上去，完美上传。

``` shell
version = libraryVersion


//important, if null, will issue: Maven group, artifact or version not match ...

group = publishedGroupId
```

3. JCenter审核通过前，配置repository url引用sdk失败，原因是配置的URL错误，不能直接拷贝Bintray的仓库地址

``` shell
    maven{

       url 'https://bintray.com/lazyboneslz/LazySDK/customviews'

    }
```

正确的地址是：

``` shell
maven{

       url 'https://dl.bintray.com/lazyboneslz/LazySDK/customviews'

    }
```

---
English DOC
---

# Overview
The paper is finally light.

I always thought that publishing AAR to jcenter is very simple, and it should be no different from publishing to a private server nexus. I didn’t expect to know how many pits I had when I did it myself.

This article will be recorded in Android Studio 3.3.2, how to upload aar to jcenter server developed with kotlin and the problems encountered. The reference is from [this blog post](https://www.open-open.com/lib/view/open1435109824278.html), which is very well written and introduces many basic concepts and release steps in detail.

# Register Jcenter Personal Account

Please note here, [Bintray's official website](https://bintray.com), please select "For an Open Source Account", [Registered Account](https://bintray.com/signup/oss).

![](/img/01_jcenter/01.png)


# create Repository and Package

Take the project of this test as an example. I want to release a test Android SDK on Jcenter. The custom name is LazySDK. Currently, the SDK only contains one Sub-SDK package: customviews. This package is mainly used to package some daily projects. Commonly used views. So I can create a repository in Bintray and name it LazySDK, then create another package in the repository as customviews.

* Step 1: Create Reprository:

![](/img/01_jcenter/02.png)
Click "Add New Repository"

![](/img/01_jcenter/03.png)
Enter the warehouse name, `Type`select "Maven"

* Step 2: Create a Package

Go to the reprository "LazySDK" created in the first step, create a new package, and then fill in the basic information such as Package name and save it:

![](/img/01_jcenter/04.png)

Click on "Add New Package"

![](/img/01_jcenter/05.png)

Supplement the required fields selected in the full screenshot, no other information


# Configure Android Studio project

Make sure there are no errors in the project before preparing for configuration. Take this test as an example: a LazySDK project is created locally, Kotlin is the development language, and the project depends on Module:customviews.

![](/img/01_jcenter/06.png)




The first step: configure the upload script

(1) Configure dependencies in the project build.gradle file:

```shell
Dependencies {

    Classpath 'com.android.tools.build:gradle:3.3.2'

    Classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"

    Classpath 'com.jfrog.bintray.gradle:gradle-bintray-plugin:1.8.4'

    Classpath 'com.github.dcendents:android-maven-gradle-plugin:2.1'

    Classpath 'org.jetbrains.dokka:dokka-android-gradle-plugin:0.9.18'

}
```

(2) Created in the project directory: [jcenter_push.gradle](https://github.com/LazyBonesLZ/LazySDK/blob/master/jcenter_push.gradle)

(3) Reference jcenter_push.gradle in library moudle builde.gradle, first configure the variable value needed by jcenter_push.gradle in ext. The purpose of this is to use the multiple modules in the future. Build.gradle defines the repository name and other information related to itself, and then share a jcenter_push.gradle. (unverified)

```shell
Ext {

    bintrayRepo = 'LazySDK'

    bintrayName = 'customviews'

    publishedGroupId = 'com.lazy.sdk'

    libraryName = 'customviews'

    Artifact = 'customviews'

    libraryDescription = 'Custom vies on Android'

    siteUrl = 'https://github.com/LazyBonesLZ/LazySDK.git'

    gitUrl = 'https://github.com/LazyBonesLZ/LazySDK.git'

    libraryVersion = '0.0.1'

    developerId = 'lazyboneslz'

    developerName = 'TJL'

    developerEmail = 'lazybonestjl@gmail.com'

    licenseName = 'The Apache Software License, Version 2.0'

    licenseUrl = 'http://www.apache.org/licenses/LICENSE-2.0.txt'

    allLicenses = ["Apache-2.0"]

}

Apply from: '../jcenter_push.gradle'

```

# install & upload

(1) Execute `./gradlew install` to verify if there is a problem. If all goes well, you will see Build Successful.

(2) Then execute: `./gradlew bintrayUpload`, if all goes well, you will see Build Successful

# Add to Jcenter

So far, the uploaded SDK has not been officially released to Jcenter, only in your own Bintray Maven repository. You can use the repository url in the project's `build.gradle`.

```shell
Repositories {

     Maven{

        Url 'https://dl.bintray.com/lazyboneslz/LazySDK/'

      }

        Google()

        Jcenter()

}
```

Then add `dependencies` in app build.gradle

```shell
Implementation com.lazy.sdk:customviews:0.0.1'
```

This way of referencing by configuring the repository url is not the best way. We can't have 10 repositories, just configure 10 URLs? So, you need to send sdk to the Jcenter server so that we don't have to configure a custom repository url.


![](/img/01_jcenter/07.png)

Click "Add to JCenter" directly
 Then just click on "Send" and you don't have to fill in any information.
![](/img/01_jcenter/08.png)



Click send
Then wait for the JCenter review, which usually takes a few hours. I sent it around 12 o'clock on the first day, but I didn't see it through the afternoon. The next day, I found that I have passed the work. I can directly reference the SDK uploaded by JCenter without configuring a custom repository url.
![](/img/01_jcenter/09.png)



After the review is approved, you will see that the icon has changed.
#[Github source](https://github.com/LazyBonesLZ/LazySDK)

# Marks

This test did not automatically synchronize the content to maven central as in the blog post referenced, so GPG-related information was not configured.



==================================================

# encountered problems

1. Javadoc generation failed. Generated Javadoc options file (useful for troubleshooting): 'xxx/javadoc/javadoc.options':

This project is developed by kotlin and is configured as follows in the configuration:

(1) Configure `dependencies` in the project build.gradle file:

```shell
Dependencies {

   ........

    Classpath 'org.jetbrains.dokka:dokka-android-gradle-plugin:0.9.18'

}
```
(2) Add in `jcenter_push.gradle`:

```shell
If (project.hasProperty("kotlin")) {//Kotlin libraries

    Task sourcesJar(type: Jar) {

       Classifier = 'sources'

        From android.sourceSets.main.java.srcDirs

}

Task javadoc(type: Javadoc,dependsOn: dokka) {

}

}else if (project.hasProperty("android")) {// Android libraries

    Task sourcesJar(type: Jar) {

Classifier = 'sources'

        From android.sourceSets.main.java.srcDirs

}

Task javadoc(type: Javadoc) {

Source = android.sourceSets.main.java.srcDirs

Classpath +=project.files(android.getBootClasspath().join(File.pathSeparator))

}

}else {// Java libraries

    Task sourcesJar(type: Jar,dependsOn: classes) {

Classifier = 'sources'

        fromsourceSets.main.allSource

    }

}

/ / Solve kotlin javadoc.options wrong

Dokka {

outputFormat = 'html'

    outputDirectory ="$buildDir/javadoc"

}
```

2 . Unable to upload files: Maven group, artifact or version defined in the pom file do not match the file path 'xx/xxxxx.pom'

This error has plagued me for a long time. I have various researches on the Internet. I found that most of the modules in the project must be the same as the artifactid. After I changed the instructions to the same, the problem still exists. I can't think of Qi. Finally, go to [https://github.com/bintray/gradle-bintray-plugin](https://github.com/bintray/gradle-bintray-plugin) to check and explain, and have not found any special attention. Later, I carefully compared the gradle of the official demo and found that it also declared the value of the group. I did the script in the blog post, but there was no related statement for the group. Finally, I added it and uploaded it perfectly.

```shell
Version = libraryVersion


//important, if null, will issue: Maven group, artifact or version not match ...

Group = publishedGroupId
```

3. Before the JCenter audit is passed, the configuration repository url fails to reference sdk. The reason is that the configured URL is incorrect. You cannot directly copy the Bintray repository address.

```shell
    Maven{

       Url 'https://bintray.com/lazyboneslz/LazySDK/customviews'

    }
```

The correct address is:

```shell
Maven{

       Url 'https://dl.bintray.com/lazyboneslz/LazySDK/customviews'

    }
```
