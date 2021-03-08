---
title: "Nexus:Upload AAR files Manully"
date: 2019-09-18T13:57:06+08:00
draft: false
categories: [Android]
tags: [Nexus,upload AAR manually]

Nexus作为公司内部或个人的SDK私有仓库，不仅可以通过gradle脚本上传生成的aar格式SDK,以便在android studio中快速集成，还可以手动上传一些单个的aar文件。
比如，如果遇到这样的使用场景：第三方的SDK,并没有上传到jcenter 或maven仓库，但是给开发者提供了下载链接。直接将aar内置在工程中也可以，但是如果工程有多个module的话，这种直接内置的方式就不太友好。所以，我们可以将其上传到nexus,然后像集成jcenter或maven仓库的sdk一样，在工程的dependices中直接使用。

管理员登录nexus,创建仓库：

![](/img/09_nexus_aar_upload/01.jpg)

上传AAR

![](/img/09_nexus_aar_upload/02.jpg)

![](/img/09_nexus_aar_upload/03.jpg)

查看是否上传成功

![](/img/09_nexus_aar_upload/04.jpg)

![](/img/09_nexus_aar_upload/05.jpg)

Android Studio 集成
如果按照上图所示的方式样集成的话，android studio是无法编译通过的，会提示找不到相应的文件，正确的使用方式是在版本号之后加上“@aar”:
```
implementation ‘com.ssc.libs:Cocos2dxSingleTouch:1.0.0@aar’
```
