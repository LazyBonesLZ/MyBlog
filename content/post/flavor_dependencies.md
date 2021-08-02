---
title: "Flavor与dependencies"
date: 2021-08-02T15:12:26+08:00
draft: false
categories: [Android]
tags: [Flavor, dependencies]
---

build 变体是 Gradle 使用一组特定规则将在 build 类型和产品变种中配置的设置、代码和资源组合在一起所得到的结果。虽然您无法直接配置 build 变体，但可以配置组成它们的 build 类型和产品变种。

创建产品变种与创建 build 类型类似：将其添加到构建配置中的 productFlavors 代码块并添加所需的设置。产品变种支持与 defaultConfig 相同的属性，这是因为，defaultConfig 实际上属于 ProductFlavor 类。这意味着，您可以在 defaultConfig 代码块中提供所有变种的基本配置，每个变种均可更改其中任何默认值，例如 applicationId。

[Android devoloper官网](https://developer.android.com/studio/build/build-variants?hl=zh-cn)详尽的描述了如果创建多个应用变体。但是这些仅仅是针对应用来描述的，试想：如果公司开发业务是分工合作，每个项目只进行各种业务开发，在最后打包发布之前，再把公共业务部分整合进来。例如游戏开发公司的项目组只进行游戏内容的开发，而创造营收的广告功能则作为每个项目需要整合的公共业务。负责公共业务的广告功能，则作为公共的sdk来提供支持。

当然，按照Google的官方文档，每个项目的开发者也可做到每个项目配置不同的变体来生成不同的变体apk,但是，这样就需要每个项目都需要负责项目的程序猿清楚如何正确的配置。对于个人开发者，这应该不是什么难题，而对于业务高度细分的团队或公司而言，有可能游戏开发者并不了解Android的打包配置，即使了解之后，也会出现相同的事情重复做，这样无形中增加了开发的周期。所以，将公共业务部分剥离出来，作为一个sdk来提供支持，可以大大简化业务组的工作。如何通过几个简单的配置就可以达到变体apk的生成呢？

基本原理还是用到gradle的变体设置。我们可以通过将要生成的变体信息，抽离成数组的形式，然后再模块级的build.gradle中解析变体数组信息，动态配置productFlavors和dependencies.

### 1. 在`projcet-level build.gradle`配置变体信息数组。

```shell

project.ext {

    productFlavors = [
            [
                    sdkVersion          : '1.3.1',
                    marketName          : 'googleplay',
                    applicationId       : 'com.internal.demo',
                    versionCode         : 10,
                    versionName         : '1.0',
                    manifestPlaceholders: [
                            KEY_ITEM_1            : "",
                            KEY_ITEM_2            : "",
                            KEY_ITEM_3            : "",
                            KEY_ITEM_4            : ""
                    ]
            ],
            [
                    sdkVersion          : '1.3.1',
                    marketName          : 'huwei',
                    applicationId       : 'com.internal.demo.huawei',
                    versionCode         : 10,
                    versionName         : '1.0',
                    manifestPlaceholders: [
                            KEY_ITEM_1            : "",
                            KEY_ITEM_2            : "",
                            KEY_ITEM_3            : "",
                            KEY_ITEM_4            : ""
                    ]
            ]
    ]

}

```

### 2. 接下来，需要在 `app-level build.gradle`中配置动态创建flavors的代码：

 ```shell
 android{
 		flavorDimensions "market"
  		productFlavors {
        	rootProject.ext.productFlavors.each {
            def flavor = productFlavors.create(it.marketName)
            flavor.setApplicationId(it.applicationId)
            flavor.setVersionCode(it.versionCode)
            flavor.setVersionName(it.versionName)
            flavor.setManifestPlaceholders(it.manifestPlaceholders)
        }
   }
 }
 
 ```
### 3. 最后,在 `app-level build.gradle`中添加依赖
 
 还是在 `app-level build.gradle`中，根据业务需求，添加不同的变体apk所要依赖的sdk或第三方sdk，即遍历配置的变体数组信息，根据每个变体的名称来配置不同的依赖内容。
 
 ```shell
 
 dependencies {
    implementation fileTree(include: ['*.jar'], dir: 'libs')
    rootProject.ext.productFlavors.each {
        dependencies.add("${it.marketName}Api",
                "com.ssc.libs:sdk:${it.sdkVersion}")
        dependencies.add("${it.marketName}Api",
                "com.ssc.libs:base:${it.sdkVersion}")
        if (it.marketName != 'googleplay'){
             dependencies.add(
                        "${it.marketName}Api",
                        "com.ssc.libs:ads:1.0.0")
        }
    }
}

 ```
 
 最后总结，这样做的好处：
 
 * 统一的工程配置模板。
 * 项目组开发者仅需简单拷贝配置文件，无需过多关注具体的依赖内容以及各种配置名称和概念。
 * 方便公共业务SDK开发者维护。
 