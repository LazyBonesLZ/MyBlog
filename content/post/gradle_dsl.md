---
title: "Android Studio: Could not find method classpath() for arguments"
date: 2019-10-23T15:12:26+08:00
draft: false
categories: [Android]
tags: [Android Studio 3.5, Not find method classpath()]
---

Some misoperations lead to errors `Could not find method classpath()` when complie an Android project. <!--more-->

```
 Could not find method classpath() for arguments [com.android.tools.build:gradle:3.5.0] on object of type org.gradle.api.internal.artifacts.dsl.dependencies.DefaultDependencyHandler.
```

Please double check if the project level `build.gradle` is correct. Pay attention to that: the node `dependencies` should be included in `buildscript`.

This is my case, maybe there are other case, hope this can help you.
