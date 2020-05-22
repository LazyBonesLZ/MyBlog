---
title: "Android app bundle tool for Mac"
date: 2020-05-22T10:14:27+08:00
draft: false
categories: [Python]
tags: [python,adb, Android app bundle tool, java]
---

As google says, you can use [`bundletool`](https://developer.android.com/studio/command-line/bundletool) to test your app bundle locally. But the command line is not very convenient to use, so we developed this GUI application based on python.<!--more-->

```
After you build your Android App Bundle, you should test how Google Play uses it to generate APKs and how those APKs behave when deployed to a device. There are two ways you should consider testing your app bundle: locally using the bundletool command line tool and through Google Play by uploading your bundle to the Play Console and using a test track. This page explains how to use bundletool to test your app bundle locally.

bundletool is the underlying tool that Gradle, Android Studio, and Google Play use to build an Android App Bundle or convert an app bundle into the various APKs that are deployed to devices. bundletool is also available to you as a command line tool, so you can recreate, inspect, and verify Google Play’s server-side build of your app’s APKs.

You should use Android Studio and the Android plugin for Gradle to build and sign an Android App Bundle. However, if using the IDE is not an option (for example, because you’re using a continuous build server), you can also build your app bundle from the command line and sign it using jarsigner.

Note: You can not use apksigner to sign your app bundle.
By default, the IDE does not use app bundles to deploy your app to a local device for testing. However, you can modify your run/debug configuration and select the option to deploy APK from app bundle to see how it affects your app's execution.
```



## System Requirement
* Mac OSX 10.14.+
* Python 2.7
* JDK 1.8+
* Android Studio 3.5+ (optional)

	```
	ADB is required, and Android studio can help you to download Android SDK which contains the adb file. Then the app will auto to check the adb file path. 
	You can also download an adb file manully without Android Studio, but you should to set the adb local path in `Setting` tab manully.
	```
	

## How to use
* Download the app's zip file form dirctionary [`mapApp/AndroidBundleTool`](https://github.com/LazyBonesLZ/AndroidBundleTool/tree/master/macApp/AndroidAppBundleTool.zip), then unzip.
* Download file `bundletool.jar` from [here](https://github.com/google/bundletool/releases), then choose tab `Setting` to set the local path of it.

	![](/img/14_aab_tool/setting.png)
	
	***Pls note***: if it is the frist time you run this app, Mac OS will show a alert and you need to allow it, see how to deal with this case as follow:
	
	* English: [https://support.apple.com/en-us/HT202491](https://support.apple.com/en-us/HT202491)
	* 中文：[https://support.apple.com/zh-cn/HT202491](https://support.apple.com/zh-cn/HT202491)

* Choose the tab `AAB Tool`, then set all parameters listed on the UI.

	![](/img/14_aab_tool/aabtool.png)
	
	* Export Apks: output the apks file in the specified directory
	* Open in Finder: open Finder to show output apks file 
	* Install Apk: choose an apks file to install on a device
	* Apk Size: get the min and max size of apk, will show the size information in the console text area.

## TroubleShot
This is an application based on python 2.7, UI is implemented by Tkinter. I am new to python, so it may not work properly on your mac. If so, it may be because your version does not match. You can modify the source code to be compatible with other versions of the Python interface.

[`Platypus`](https://sveinbjorn.org/files/manpages/PlatypusDocumentation.html) is a script packaging tool. If you complete a new version of the script, you can use this tool to package it into a Mac app. But when packing, you need to pay attention to the following: 

* Script Type : `Python`
* Select your script
* Interface: `None`
* Uncheck the option: `Remain running after execution`
* Add the default config file.

	![](/img/14_aab_tool/py2app1.png)

* Uncheck the option: `Create symlink to script and bundled files`

	![](/img/14_aab_tool/py2app2.png)

## Source Code 
Github: [https://github.com/LazyBonesLZ/AndroidBundleTool.git](https://github.com/LazyBonesLZ/AndroidBundleTool.git)

