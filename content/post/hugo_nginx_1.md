---
title: "Hugo+Nginx： 利用webhook自动部署静态网站到远程CentOS服务器（一）"
date: 2019-04-24T11:13:24+08:00
draft: false
categories: [Web]
tags: [Web,Nginx,CentOS,Github,Webhook,自动部署]
---

# 概述
最近心血来潮想捣腾一下服务器方面的东西，一冲动在阿里云买了一台小小云服务器(HongKong)[(推荐链接)](https://promotion.aliyun.com/ntms/yunparter/invite.html?userCode=lpl70fmt)（5年，算下来真是比买一个国外的VPS划算得太多，关键是响应速度超级完美，看图），想来搭个博文网站练（zhuang)练(zhuang)手(bi)，也是不错的。
            ![hugo_1_2.png](https://upload-images.jianshu.io/upload_images/6174818-1d32ece02cdd0295.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

既然练练手，搭个小小的静态博文网站再合适不过了。接下来就是选择什么样的博客框架来的快。作为菜鸟中的战斗鸡，也就不用去对比wordpress, hexo,ghost这些框架了，查看大量的博文后觉得Hugo最适合自己，简单直接。

既然想要捣腾服务器，就选nginx。咱也不太懂也不敢问，就是八百年前被赶鸭子上架接触一两天这个玩意儿，别的也不清楚。

好了，画个示意图来描述一下要干事儿。
![hugo_1_1.png](https://upload-images.jianshu.io/upload_images/6174818-833befed68fd3ff4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

示意图解释：

* 本地先安装hugo,博客内容使用markdown编辑
* Hugo将博客内容自动转换为html等静态文件
* 创建github远程仓库，同时仓库中配置webhook。
* 将本地生成的静态文件上传到github服务器，与此同时会触发webhook，向监听git push event的服务器发送一个post请求.
* 远程服务器已启动的webhook service,监听来自github 的post 请求。
* 触发执行远程服务器上的git pull脚本
* 更新远程服务器上的静态网页文件，完成自动化部署。

# 艰苦历程
所谓菜鸟，就是知其然不知其所以然。接下来的操作，只能算是记录流水账，希望对您有所帮助。技术概念啥的咱也不懂，反正要做的就是上述示意图的这个事儿，遇到问题都是stackoverflow,google+度娘，万分感谢文末各位技术大牛的无私分享。

由于流水账截图过多，所以我将分为三篇文档进行阐述。

* [Hugo+Nginx： 利用webhook自动部署静态网站到远程CentOS服务器（一）]()
* [Hugo+Nginx： 利用webhook自动部署静态网站到远程CentOS服务器（二）]()
* [Hugo+Nginx： 利用webhook自动部署静态网站到远程CentOS服务器（三）]()

## 准备
* 本地环境：
     * MacOS 10.14.2， 64位
     * github 
     * hugo
     
*  服务器环境：
     * CentOS 6.9， 64位 （因为某些特殊原因，购买服务器的时候特地选的centos6.+）
     * github
     * nginx
     * nodejs
     * pm2
* 创建Github仓库

## 具体步骤
由于服务器需要设置的东西相对较多，所以我们按照从易到难的顺序来记录各个部分的具体内容：
本地环境 --> Github --> 远程服务器。

### 安装本地环境
* 安装github
由于macOS在安装xcode开发工具已经自带Git,所以我们略过。如果您是windowsOS，请自行查找安装GitHub的教程。
* 安装Hugo
进入官方[快速入门](https://gohugo.io/getting-started/quick-start/)的链接，已经详尽的描述的安装步骤，不再赘述。

### 创建Github仓库
登录Github（如果您还没有Github账号，请先在官网注册），创建两个仓库，分别用来上传本地Hugo的网站源码文件和生成的静态网站文件。参考：[Host on GitHub.](https://gohugo.io/hosting-and-deployment/hosting-on-github/)
本文创建的两个仓库，分别命名位`MyBlog`和`LazyBonesLZ.github.io`，为了简单起见，创建的两个空仓库，不要有任何初始化的文件:

* [MyBlog](https://github.com/LazyBonesLZ/MyBlog.git)
    用来保存网站源码
* [LazyBonesLZ.github.io](https://github.com/LazyBonesLZ/LazyBonesLZ.github.io.git)
    用来保存要发布到远程服务器的静态网站文件。请注意该仓库的命名方式，因为本菜鸟想留一手，如果以后没钱维护购买的服务器了，还可以用Github Pages作为服务器的方式，重新配置Hugo baseUrl来维护Hugo网站，但是前提是仓库必须按照`<GithubUserName>/github.io`的格式命名。
* 为了方便之后我们使用脚本发布网站，`LazyBonesLZ.github.io` 将作为  `MyBlog` 的外链仓库。之后我们将详细讲解操作步骤。

### 远程服务器环境
本文假设您跟我一样，是购买的一台全新服务器。如果还没有买的话，请通过[(推荐链接)](https://promotion.aliyun.com/ntms/yunparter/invite.html?userCode=lpl70fmt)购买一个香港的服务器，好处想必你在文章开头已经看到了。由于某些特殊原因，我特地选择购买的CentOS 6.+的操作系统。

* 登录阿里云。
如果没有账号，请先自行注册并且按照提示进行实名认证，因为在大陆注册的账号是需要完成实名认证后，才能购买服务器。
* 购买服务器
    * 选择基础配置,请注意地域是选择： `香港`

      ![hugo_1_3.png](https://upload-images.jianshu.io/upload_images/6174818-d314ffd86d358ae9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
    * 选择操作系统和存储空间：如果没有太多的空间需求，可以考虑稍微选择小一点，比如20G，还能省下不少钱。
    ![hugo_1_4.png](https://upload-images.jianshu.io/upload_images/6174818-e7dbd4e6bc1c539c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
    * 网络：请注意我选择的是网络带宽是“按照使用流量”
    ![hugo_1_5.png](https://upload-images.jianshu.io/upload_images/6174818-34848e5ef26233fd.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
    * 设置安全组：

      ```
      截图中，
      第3步：添加的是监听 Github的 push event的service所在的端口:7777；
      第4步：0.0.0.0/0 表示授权接收所有ip的访问。
      ```
      ![hugo_1_7.png](https://upload-images.jianshu.io/upload_images/6174818-ec87daab9b684e38.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
    * 配置登录用户名和密码，然后直接确认订单。付款。
      ![hugo_1_8.png](https://upload-images.jianshu.io/upload_images/6174818-4cd81512371e8eb6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
    * 成功付款后，即可运行实例了。

* SSH登录服务器
在本地终端Terminal, 执行 ` ssh -p 22 root@xx.xx.xx.xx`登录, 其中`xx.xx.xx.xx`表示你的服务器IP地址，连接成功后即可方便的操控远程服务器。
如果是第一次连接服务器，终端会有一个鉴权提示，

  ```
  The authenticity of host 'xxx.xxx.xxx.xxx' can't be established.
  RSA key fingerprint is SHA256:dfjkdjgdjgdjgjldjgflajgljdkljglkdjgljldjggj.
  Are you sure you want to continue connecting (yes/no)?
  ```
   直接输入`yes`,表示同意。在终端输入正确的登录密码，完成ssh登录。

     ![hugo_1_9.png](https://upload-images.jianshu.io/upload_images/6174818-4b7762a66fd98c37.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

鉴于内容过多，服务器的环境配置我们放在下一篇继续。