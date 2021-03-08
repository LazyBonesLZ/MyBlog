---
title: "Google IAP : Check list for unable-purchase"
date: 2019-05-13T11:02:03+08:00
draft: fasle
categories: [Android]
tags: [google iap,无法购买]


Google IAP一直是项目测试组的噩梦。各种莫名其妙的无法购买，每当项目已更新，涉及IAP的测试都会要去梳理一遍代码逻辑，结果大多数情况都是非代码逻辑导致。

所以，把遇到的问题做一个梳理，备忘，或许可以帮到别人。<!--more-->

Google IAP 测试，检查项备忘：

*  检查app bundle id 是否正确；
*  检查google play public key 是否正确；
*  检查是否开启了IAP功能；
*  联机调试查看log,检查购买的 IAP item id是否正确；
*  以上步骤都检查完了，如果还有问题，查看iap后台是否配置；
*  确保tester账号已被加到后台且配置正确；
*  确保tester账号在测试设备上是唯一登陆的账号；
*  如果是app被下架过，重新上传一次alpha测试apk;
*  如果是测试订阅功能，注意不要因同一个账号在不同设备被登陆的情况造成test case混淆。
