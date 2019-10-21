---
title: "Unity Call Android native method with array parameters"
date: 2018-07-11T01:59:34+08:00
draft: false
categories: [Android]
tags: [Android,Unity,Method,Array Params,参数,数组]
---
In the Unity development process, if you want to call the java method of the Android side, the parameters of the method are variable parameters or arrays. The call method provided by the AndroidJavaObject of unity directly passes the c# array. It is necessary to do some processing on the array parameters.<!--more--> for example:

The java method is as follows:

```shell
Public void addList(String... values){

}
```
When unity c# is called, you need to convert the passed parameter array into an AndroidJavaObject, and then call the call method provided by AndroidJavaObject.

```shell
Public void add(string[] values){

        AndroidHelper.getIapManagerAndroidObject().Call (_javaMethodName,javaArrayFromCS(values));

}

```

```shell
Private AndroidJavaObject javaArrayFromCS(string[] values){

AndroidJavaClass arrayClass = new AndroidJavaClass("java.lang.reflect.Array");

AndroidJavaObject arrayObject = arrayClass.CallStatic("newInstance",new AndroidJavaClass("java.lang.String"), values.Count());

For(int i=0; i < values.Count(); ++i){

arrayClass.CallStatic("set", arrayObject, i,newAndroidJavaObject("java.lang.String", values[i]));

}

Return arrayObject;

}

```

===中文===
---

Unity开发过程中，如果要调用Android端的java方法，恰巧该方法的参数是可变参数或者数组，使用unity的AndroidJavaObject提供的call方法直接传递c#数组，是需要对数组参数做一下处理。举例说明：

java方法如下：

``` shell
public void addList(String... values){

}
```
unity c#调用时，需要把传入的参数数组转化成一个AndroidJavaObject，然后再调用AndroidJavaObject提供的call方法。

``` shell
public void add(string[] values){

        AndroidHelper.getIapManagerAndroidObject().Call (_javaMethodName,javaArrayFromCS(values));

	}

```

``` shell
private AndroidJavaObject javaArrayFromCS(string[] values){

	AndroidJavaClass arrayClass  = new AndroidJavaClass("java.lang.reflect.Array");

	AndroidJavaObject arrayObject = arrayClass.CallStatic("newInstance",new AndroidJavaClass("java.lang.String"), values.Count());

	for(int i=0; i < values.Count(); ++i){

		arrayClass.CallStatic("set", arrayObject, i,newAndroidJavaObject("java.lang.String", values[i]));

	}

	return arrayObject;

	}

```




参考：
[https://stackoverflow.com/questions/42681410/androidjavaobject-call-array-passing-error-unity-for-android](https://stackoverflow.com/questions/42681410/androidjavaobject-call-array-passing-error-unity-for-android)
