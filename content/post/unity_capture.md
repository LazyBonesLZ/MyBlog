---
title: "Unity ScreenCapture"
date: 2020-04-23T15:01:15+08:00
draft: false
categories: [Unity]
tags: [Unity,Editor Screenshot,截屏]
---

我发现为iOS应用商店提供屏幕截图非常耗时，因为它们必须具有iOS设备分辨率。 在所有设备上构建和运行，截屏并上传需要花费大量时间。

利用Unity Scripts 提供的 API，可以做一个功能菜单，开发人员只需要切换不同的屏幕分辨率，然后直接点击`Screenshot/Grab`菜单即可得到不同尺寸的截图。简化操作流程，为游戏开发人员节省大量时间。

![](/img/13_unity_screen/01.png)

创建ScreenshotGrabber类，放在`Editor`文件夹目录下（如果没有，则创建一个并命名为`Editor`）。
直接上代码:

``` shell
using UnityEditor;
using UnityEngine;
 
public class ScreenshotGrabber
{
    [MenuItem("Screenshot/Grab")]
    public static void Grab()
    {
        ScreenCapture.CaptureScreenshot("Screenshot.png", 1);
    }
}

```

使用方法：打开想要截图的场景，然后如图执行

![](/img/13_unity_screen/02.png)

截图保存路径为Unity工程`根目录`,文件名为`Screenshot.png `。需要注意的是，每次截图都会生成新的文件覆盖旧文件。

![](/img/13_unity_screen/03.png)