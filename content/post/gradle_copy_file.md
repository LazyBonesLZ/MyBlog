---
title: "Gradle Copy File"
date: 2019-08-16T10:59:48+08:00
draft: false
categories: [Android]
tags: [Gradle,Copy File]
---

Android Studio 在Build工程之前，如果要将一些应用必须的配置文件拷贝到assets目录下，可以自定义task,在build之前先执行。<!--more-->

```shell 
task copyFile(type: Copy){
    println 'copy file...'
    //读取工程根目录下的文件‘file.json’
    String fileName = 'file.json'
    File jsonFile =  project.file(fileName)
    
    if (jsonFile.exists()){
        from jsonFile.getAbsolutePath() //source dir
        into 'src/main/assets' //target dir
    }else {
        println 'json file is NOT found'
        throw new CompletionException(fileName + " is NOT found")

    }

}

//在编译之前先执行拷贝任务
project.afterEvaluate {
    preBuild.dependsOn(copyFile)
}

```

