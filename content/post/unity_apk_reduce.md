---
title: "How to reduce the apk size of Unity Game"
date: 2019-06-14T16:54:06+08:00
draft: false
categories: [Unity]
tags: [Android Studio,Unity-Lua,Apk大小]
---



# 问题背景
由于本人非专业游戏开发者，本文不讨论如何专业的处理游戏资源和工程配置来减小安装包大小问题。只简单记录一下如何在打包时减小apk。

Unity项目,Lua开发子游戏逻辑。Unity中如何使用Lua开发不展开说明，我也不会。该问题的背景是老板要求我们将lua开发的子app提出来发布为单独的应用，所以标题其实改为“Unity-lua项目如何进一步减小apk大小”。

熟悉这种开发方式的同学应该都知道，lua逻辑能够顺利运行，游戏场景应该都打好的assetbundle资源。这是我们如何进一步在打包apk时减小大小的关键。如果项目中有多个场景，在untiy editor导出Android studio 工程时，只需要将第一个场景导出即可。这样，剩下的游戏场景就不用被重复编译成资源，直接通过lua逻辑从assetbundle中加载即可。

# 举例说明

项目A只有两个场景:LaunchScene 和 MainScene; 要顺利发布lua项目，第一个启动场景需要完成所有assetbundle和lua资源的加载以及加载动画的展示，所以第一个场景时必须要导出的；而主场景的加载则是在此之后lua的逻辑来控制了，其资源当然就是从预先加载好的assetbundle获取到的。

如果在导出的时候，我们勾选了所有的场景：

![](/img/06_unity_apk/01.png)

通过解压apk我们可以看到：

![](/img/06_unity_apk/02.png)

`level0 `和 `level1` 分别对应两个场景，对应的还有`sharedassets0.assets`和`sharedassets1.assets`文件，截图中以`sharedassetsXXX.assets.splitXXX`分包的方式存在，这些都是unity自带跟场景相关的资源，非常大。对apk的大小影响非常明显。

当我们不勾选MainScene导出，

![](/img/06_unity_apk/03.png)

解压发现文件名为`sharedassets1.asstes.splitXXX`和 `level1`的文件都不见了，且apk减少将近15M。

本文仅记录而已，解释不对的地方请鄙视。希望能对您减小apk时有所帮助。
