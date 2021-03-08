---
title: "Placeholders In Library Module"
date: 2019-09-24T15:34:44+08:00
draft: false
categories: [Android]
tags: [Placeholders,Main module,Library module]


Android Studio 工程有多个module组成，相互工程依赖。最常见的方式是app moudule 依赖于 library module。如果所依赖的library module 最终还会作为一个公共SDK供其他项目使用的话，而内部用到的一些又需要根据具体项目配置的不同值时，就需要在library moudule的`AndroidManifest.xml`中使用manifest placehodlers占位符。

但是，在Android Studio升级到3.5之后，如果library module的`AndroidManifest.xml`中使用placeholders占位符配置某个`meta-data`值之后却不在该module的`build.gradle`中定义，就会抛出编译错误：

```
ERROR: Manifest merger failed with multiple errors, see logs
Error:Execution failed for task':app:processDebugManifest'

```

但是，如果直接在library module的gradle文件中定义这些占位符的值，那么在编译出SDK的`AndroidManifest`中就会包含有默认的`meta-data`值。虽然在项目的gradle可以再次定义占位符对应的值来替换library module中的默认值，但是，如果在具体项目中重新定义的某一个占位符为空值，根据Android Studio合并`Manifest`的优先级规则，该占位符在最终编译合并生成的`AndroidManifest.xml`中肯定会使用library module中配置的默认值：或空或非空。这就不符合我们的预期了。

所以最终的解决方案：在library module的gradle中也要定义占位符,注意配置中的单引号：`''`:

```shell
android {
   //...

    defaultConfig {
     //...
        //fake placeholder

        manifestPlaceholders =
                [CustomValue1           : '${CustomValue1}',
                 CustomValue2           : '${CustomValue2}'
                ]
    }

   //...
}
```

然后在main module的gradle中要定义占位符真正要用到的值：

```shell
android {
   //...

    defaultConfig {
     //...
        //real placeholder

        manifestPlaceholders =
                [CustomValue1           : "Real Value1",
                 CustomValue2           : "Real Value2"
                ]
    }

   //...
}
```





 参考链接：[https://stackoverflow.com/questions/35150388/android-studio-is-it-possible-to-define-library-module-manifest-placeholders-in](https://stackoverflow.com/questions/35150388/android-studio-is-it-possible-to-define-library-module-manifest-placeholders-in)
