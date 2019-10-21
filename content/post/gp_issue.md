---
title: "Google IAP : Check list for unable-purchase"
date: 2019-05-13T11:02:03+08:00
draft: fasle
categories: [Android]
tags: [google iap,无法购买]
---


Google IAP has been a nightmare for the project test team. All kinds of inexplicable can not be purchased, whenever the project has been updated, the test involving IAP will have to sort through the code logic, and most of the cases are caused by non-code logic.

Therefore, to sort out the problems encountered, memo, may help others. <!--more-->

Google IAP test, check item memo:

* Check if the app bundle id is correct;
* Check if the google play public key is correct;
* Check if the IAP function is enabled;
* Online debugging to check the log, check whether the purchased IAP item id is correct;
* The above steps are all checked. If there are still problems, check whether the iap background is configured.
* Make sure the tester account has been added to the background and configured correctly;
* Make sure the tester account is the only account that is logged in on the test device;
* If the app has been removed, re-upload an alpha test apk;
* If it is a test subscription function, be careful not to confuse the test case because the same account is logged in on different devices.

===中文===
---

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
