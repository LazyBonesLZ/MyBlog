---
title: "Android Unity Game Popups “Screen Overlay Deteched"
date: 2019-08-08T09:15:12+08:00
draft: false
categories: [Android]
tags: [Android,Unity3d,屏幕重叠层检测,Screen Overlay Deteched]
---

闲话少说，直接来看问题。
在三星平板T710设备上，系统版本为Android 6.0.1。Unity引擎开发的游戏在申请Android危险权限时，会弹出“屏幕重叠层检测”的提示对话框。如图所示：

![](/img/08_screenoverlay/01.png)

遇到这种毫无头绪的情况都是直接开启Google大法。按照网上最多的说法都是根据提示，去Setting界面将“可出现在其他app上的”app，全部关闭。做了，无效。问题在哪？

![](/img/08_screenoverlay/02.png)

测试过程中发现如下情况：

* 在其他型号6.0+以上的设备却没有相同的问题。
* 在该设备上原生的测试app没有问题。

推断出，该问题可能跟Untiy的Android工程配置有关。通过排查，果不其然，发现在AndroidManifest.xml中如下配置：

``` shell
<!--此项配置跟unity 项目相关，设置在app启动时，是否跳过权限提示框的弹出（其它项目请忽略）-->
        <meta-data
            android:name="unityplayer.SkipPermissionsDialog"
            android:value="true"/>
```
如果将该配置取消掉，问题就没有了。可是，这样就不满足项目需求了，原因如上代码注释所述。去掉的话，app一启动就会自动申请权限，即使当前逻辑还没用到该权限。严重影响用户体验，所以必须保留。

一开始以为是unity5.6版本的问题，但是在unity2018测试也一样存在。排除了unity版本问题，或者至少可以说unity版本切换，不足以避免该问题。最后实在没办法了，就在想为什么会出现这种“屏幕重叠层检测”的问题，根本原因是什么？参照网上说法，这种提示框是因为在屏幕上有悬浮视图才会在试图修改权限的时候弹出。但是我当前的屏幕上并没有其他app的悬浮窗口啊，如360的加速球之类的控件，令人抓狂，最后发现在权限对话框弹出的同时，我的应用在不停的用Toast显示应用中广告请求的信息，邪魅一笑，Toast也是悬浮控件吧？

***关闭应用中控制显示Toast的开关，世界清净了，阿弥陀佛！***

后续：上文说到，在该设备上，运行原生测试应用时，也在不停的显示toast，同时申请权限，就不会弹出“屏幕重叠层检测”的对话框。原来是因为控制toast是否显示的开关被我默认关掉了，挖坑埋自己，还归罪unity。汗！
