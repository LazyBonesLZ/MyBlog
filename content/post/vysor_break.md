---
title: "最新版Vysor pro Mac Chrome插件破解"
date: 2019-06-26T15:21:15+08:00
draft: false
categories: [Android]
tags: [Chrome Extension, Vysor pro 2.1.7_0, 破解]
---

# 声明：
本文仅作学习研究，请勿用做商业用途,请支持正版。侵删！！！

# Vysor
vysor是什么？官方描述翻译过来是：Vysor把你的Android界面投影到一个窗口上，你可以通过这个窗口用鼠标操作Android手机并把画面实时呈现给用户，当然，你也可以通过手指触摸手机去操作软件，它也能够把画面实时呈现给用户，也就是说，操作控制是双向的！

厉害的是不需要android root 且免费使用，画面的超高流畅度以及超高码率（免费版清晰度马马虎虎，但是pro版画质几乎跟真机差不多）。

由衷感谢这款免费软件，不管你是开发人员还是测试人员，都有用到它的机会。不用再长时间低头趴在设备前，保护你脆弱的颈椎。

但是，免费版是会每15分钟显示一次全屏广告，偶尔一两次感觉没什么，毕竟人家免费给你用了，看一下广告让人赚点吃饭加个鸡腿钱也是可以理解的。但是的但是，当你正全神贯注关注测试过程中，三番五次来这么一下，打断工作。就不太友好了。

不想看广告，给钱升级到pro版，画质清晰，无广告。可是对于我们这些可用于长期投资还差9.9w才到10w的“赤屌”（赤裸的屌丝）来说，已经是一笔相当可观的支出了。又想用人家好的服务，又不想给钱，活该一直被鄙视。

没办法，还是想办法先搞一个破解版试试吧。

# 安装Vysor

* [进入官网](https://www.vysor.io/)

	![](/img/07_vysor/01.png)

* 下载Chrome 插件

	![](/img/07_vysor/02.png)
* 在chrome应用商店

	![](/img/07_vysor/03.png)

本文假设你的pc环境都已经配置好：

* ADB Drivers （Windows系统需要配置环境变量，同理macOS）
* 手机端已经打开了开发者设置：
	
	允许usb调试 以及 USB设备调试（允许usb修改权限或模拟点击，小米手机需要）

# 破解
## 免费版
可以看到未破解情况下，提示用户在Android端是要每个15分钟显示广告的

![](/img/07_vysor/04.png)

## 开始破解 
* 详细步骤，请参考[https://blog.csdn.net/qq_32175491/article/details/82758381#_37](https://blog.csdn.net/qq_32175491/article/details/82758381#_37)
* 打开`uglify.js`
	
	需要注意的是，按照上述文档可能查不到Vysor ID，摸索了一番，发现其ID应该是固定的， 以`gidgen`开始，以`ffefm `结尾的md5字符串？比如：`gidgenxxxxxxxxxxxxxxxxffefm `
	
	所以你可以先进到 
`/Users/youname/Library/Application Support/Google/Chrome/Default/Extensions/`
目录，然后搜索一下该目录下是否存在上述ID目录。不出意外的话，
`uglify.js`就在该目录下对应版本号路径之下。

本文尝试的是上述链接中的第二种破解方法，但是Vysor v2.1.7_0需要改动的地方是：在`uglify.js`中，搜索`Account Management` 
然后将

```
g=!1,b=!1,k="Account Management"
```
改为

``` 
g=1,b=1,k="Account Management"
```

最后保存，重启Vysor。 如图所示即表示破解成功。

![](/img/07_vysor/05.png)