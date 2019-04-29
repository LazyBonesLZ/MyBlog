---
title: "Google play billing Alpha / Beta 测试"
date: 2018-07-11T15:29:05+08:00
draft: false
categories: [Android]
tags: [Android,GP,Billing,IAP, Alpha/Bata Test]
---

本文假设你已经集成Google play billing SDK ，根据google官方提供的[文档说明](https://developer.android.com/google/play/billing/billing_testing)，提供了几种验证应用内购买逻辑的方式。

本文记录的是alpha或beta测试的一些操作细节。供参考。

**！！！！！前方多图预警！！！！！！**

# 一 前提

1.已注册Google play console账号；

2.已注册Google账号：gmail账号或其他；

3.签名打包apk，备用。

# 二 具体步骤

1.登陆 [Google play console]().

2.创建App

2.1 Create application

![](/img/03_gp_billing/00.png)
---
![](/img/03_gp_billing/01.png)
---
2.2 完善App的其他信息

![](/img/03_gp_billing/02.png)
---

2.3 上传app的截图和资源

![](/img/03_gp_billing/03.png)
---

2.4 App的其他信息

![](/img/03_gp_billing/04.png)
---
![](/img/03_gp_billing/05.png)
---
3 发布apk到alpha渠道，后续几道步骤，需要在该步骤上传完apk后方可继续。操作步骤相见截图：

![](/img/03_gp_billing/06.png)
---
![](/img/03_gp_billing/07.png)
---
![](/img/03_gp_billing/08.png)
---
![](/img/03_gp_billing/09.png)
---
![](/img/03_gp_billing/10.png)
---
4. 完善 Content rating信息

![](/img/03_gp_billing/11.png)
---
![](/img/03_gp_billing/12.png)
---
![](/img/03_gp_billing/13.png)
---
![](/img/03_gp_billing/14.png)
---
![](/img/03_gp_billing/15.png)
---
5.设置App付费信息

![](/img/03_gp_billing/16.png)
---
![](/img/03_gp_billing/17.png)
---
![](/img/03_gp_billing/18.png)
---
![](/img/03_gp_billing/19.png)
---
6.完成以上步骤后，如果没有问题，则app的配置信息就完成了。如下图所示，则表示所有配置都完成。

![](/img/03_gp_billing/20.png)
---


7.配置应用内购买的商品信息和订阅信息

7.1 配置Managed商品信息

7.1.1 创建Managed Products

![](/img/03_gp_billing/21.png)
---
7.1.2 设置Managed Product

![](/img/03_gp_billing/22.png)
---
![](/img/03_gp_billing/23.png)
---
![](/img/03_gp_billing/24.png)
---
![](/img/03_gp_billing/25.png)
---
7.2 创建Subscription

![](/img/03_gp_billing/26.png)
---
![](/img/03_gp_billing/27.png)
---
![](/img/03_gp_billing/28.png)
---
![](/img/03_gp_billing/29.png)
---
![](/img/03_gp_billing/30.png)
---
8.添加测试者账号
将你申请作为测试的Google账号添加为测试者。

![](/img/03_gp_billing/31.png)
---
![](/img/03_gp_billing/32.png)
---
![](/img/03_gp_billing/33.png)
---
![](/img/03_gp_billing/34.png)
---
![](/img/03_gp_billing/35.png)
---
![](/img/03_gp_billing/36.png)
---
9.完成tester账号设置后，就可以将app推出，等待google的审核。

![](/img/03_gp_billing/37.png)
---
![](/img/03_gp_billing/38.png)
---
![](/img/03_gp_billing/39.png)
---

10.等待审核
![](/img/03_gp_billing/40.png)
---

一切顺利的话，就可以等待Google的审核了，通常这个过程会花费2-3个小时不等。审核通过后，在Android 设备Google play store上登陆你的测试者账号，就可以搜索你上传的的app了，之后就可以发起正常的购买流程，不需要绑定银行卡，因为不会真正的付费。

在测试购买的过程中，有可能发现bug了，改了之后需要再上传apk么？不用，直接像开发其他功能一样，直接连着IDE开发调试，购买流程完全不受影响，前提：设备上需要在google play store登陆测试者账号。

以上。