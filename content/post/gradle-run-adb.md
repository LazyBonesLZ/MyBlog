---
title: "Gradle Run Adb"
date: 2019-09-18T16:57:37+08:00
draft: false
categories: [Android]
tags: [gradle,adb]
---


I wrote an article about [python executing the adb command](https://www.harddone.com/post/python_adb/). The main function is to create a folder on the device and then upload the file to the created directory. The business requirement is to upload the obb file to the device, but to execute the python script, you need to pass in too many parameters: obb path, app package name, and version number. Too many parameters lead to inconvenience, and you forget it for a long time. <!--more-->

Therefore, in the project directly use the gradle task to rewrite the work, so open the terminal directly in the anroid stuido, execute the task.
The benefits of doing this are as follows:

* Less incoming parameters: only need to pass obb local path on the development machine
* No need for `python` environment

To implement `gradle task` to execute `adb`, you can do this by executing `gradle` `Command Line`. See [Exec](https://docs.gradle.org/current/dsl/org.gradle.api.tasks.Exec.html#org.gradle.api.tasks.Exec)

```shell
Task stopTomcat(type:Exec) {
  workingDir '../tomcat/bin'

  //on windows:
  commandLine 'cmd', '/c', 'stop.bat'

  //on linux
  commandLine './stop.sh'

  //store the output instead of printing to the console:
  standardOutput = new ByteArrayOutputStream()

  //extension method stopTomcat.output() can be used to obtain the output:
  Ext.output = {
    Return standardOutput.toString()
  }
}
```

In theory, we can directly execute our previous `obb_push.py` script, but in the actual test process, the logic in the python script is actually multi-task execution, and the simple execution script can't get the correct result. Therefore, the task of the python script is decomposed into multiple `gradle task`s, and the corresponding `adb` commands are executed respectively.

So the problems we need to solve are as follows:

* gradle multitasking
* gradle task order
* gradle run adb
* gradle task dynamic parameters are passed in

Directly on the script `copyobb.gradle`:

```shell
/**
 * How to use task: pushObb?
 * 1. open a terminal in Android Studio;
 * 2. input the command:
 * ./gradlew -PobbPath="the obb file path on your mac which exported from unity" pushObb
 *
 * [[For example]]:
 * ./gradlew -PobbPath="/Users/ColorfulDark/tmp/BSG0030/BSG0030.main.obb" pushObb
 *
 *
 */

Task mkdirs(type:Exec){
    workingDir './'
    String packageName = project.AppBundleId
    Println 'get package name = ' + packageName

    Println ' (1)================Preparing dirs...'
    String obbDestPath = 'sdcard/Android/obb/' + packageName
    commandLine 'adb', 'shell', 'mkdir', '-p', obbDestPath // recursively create a folder
}

/ / You must create a good target path on the device before you can push the file, so use dependsOn
Task pushObb(type: Exec,dependsOn:mkdirs) {
    workingDir './'
    String packageName = project.AppBundleId
    String version = project.AppVersionCode
    String obbFilePath = project.hasProperty("obbPath") ? obbPath : null

    Println ' (2)===============> parsing obb file name...'
    If (obbFilePath == null || obbFilePath == "") {
        Println 'you should input a obb file\'s path !'
        Return
    }

    String[] obbSubDirs = obbFilePath.split('/')
    String obbFileName = obbSubDirs[obbSubDirs.length - 1]

    If (obbFileName == null || !obbFileName.contains('.obb')) {
        Println 'can not find a obb file in the path !'
        Return

    } else
        Println " " + obbFileName

    Println ' (3)================ adb push obb file to device...'
    String obbDestPath = 'sdcard/Android/obb/' + packageName
    commandLine 'adb', 'push', obbFilePath.replace(' ', '\\ '), '/' + obbDestPath + '/'

//You must wait until the upload is complete before you can perform the rename task
    doLast {
        Exec {
            Println ' (4)================ adb rename obb file...'
            String newObbFileName = "main." + version + "." + packageName + ".obb"
            String oldFileFullPath = '/' + obbDestPath + '/' + obbFileName
            String newFileFullPath = '/' + obbDestPath + '/' + newObbFileName
            Println ' old name:' + oldFileFullPath
            commandLine 'adb', 'shell', 'mv', oldFileFullPath, newFileFullPath
            Println ' new name:' + newFileFullPath

            Println ' (5)===============> Completed!!!'
        }


    }

}

```

### How to use task: pushObb?

* Add `apply from: 'copyobb.gradle'` in app level gradle.
* Open a terminal in Android Studio;
* Input the command and pass parameter with `-P`:

```shell
  ./gradlew -PobbPath="the obb file path on your mac which exported from unity" pushObb
 
  [[For example]]:
  ./gradlew -PobbPath="/Users/ColorfulDark/tmp/BSG0030/BSG0030.main.obb" pushObb
 
```

===中文===
---

之前写过一篇关于[python执行adb命令的文章](https://www.harddone.com/post/python_adb/),主要功能是在设备上创建文件夹，然后向创建的目录下上传文件。业务需求是上传obb文件到设备上，但是执行该python脚本，需要传入太多的参数：obb路径，app package name, 以及版本号等等。参数过多导致使用不便，且时间久了自己也就忘了。

所以，在工程中直接使用gradle task来重写该功，这样直接在anroid stuido打开终端，执行task即可。
这样做的好处如下：

* 传入参数少：只需要传入obb在开发机上的本地路径
* 不需要`python`环境

想要实现`gradle task` 执行 `adb`, 可以通过执行`gradle`的 `Command Line`。参见[Exec](https://docs.gradle.org/current/dsl/org.gradle.api.tasks.Exec.html#org.gradle.api.tasks.Exec)

``` shell
task stopTomcat(type:Exec) {
  workingDir '../tomcat/bin'

  //on windows:
  commandLine 'cmd', '/c', 'stop.bat'

  //on linux
  commandLine './stop.sh'

  //store the output instead of printing to the console:
  standardOutput = new ByteArrayOutputStream()

  //extension method stopTomcat.output() can be used to obtain the output:
  ext.output = {
    return standardOutput.toString()
  }
}
```

理论上，可以直接执行我们之前的`obb_push.py`脚本，但是在实际测试过程发现，python脚本里的逻辑其实是多任务的执行，简单的执行脚本根本无法得到正确的结果。所以，将该python脚本的任务分解为多个`gradle task`,分别执行对应的`adb`命令。

所以，我们需要解决的问题如下：

* gradle 多任务执行
* gradle 任务顺序
* gradle run adb
* gradle task 动态参数传入

直接上脚本`copyobb.gradle`:

```shell
/**
 * How to use task: pushObb?
 * 1. open a terminal in Android Studio;
 * 2. input the command:
 * ./gradlew -PobbPath="the obb file path on your mac which exported from unity" pushObb
 *
 * [[For example]]:
 * ./gradlew -PobbPath="/Users/ColorfulDark/tmp/BSG0030/BSG0030.main.obb" pushObb
 *
 *
 */

task mkdirs(type:Exec){
    workingDir './'
    String packageName = project.AppBundleId
    println 'get package name = ' + packageName

    println '  (1)===============>Preparing dirs...'
    String obbDestPath = 'sdcard/Android/obb/' + packageName
    commandLine 'adb', 'shell', 'mkdir','-p', obbDestPath //递归创建文件夹
}

//必须在设备上创建好目标路径之后，才能push file,所以利用dependsOn
task pushObb(type: Exec,dependsOn:mkdirs) {
    workingDir './'
    String packageName = project.AppBundleId
    String version = project.AppVersionCode
    String obbFilePath = project.hasProperty("obbPath") ? obbPath : null

    println '  (2)===============> parsing obb file name...'
    if (obbFilePath == null || obbFilePath == "") {
        println 'you should input a obb file\'s path !'
        return
    }

    String[] obbSubDirs = obbFilePath.split('/')
    String obbFileName = obbSubDirs[obbSubDirs.length - 1]

    if (obbFileName == null || !obbFileName.contains('.obb')) {
        println 'can not find a obb file in the path !'
        return

    } else
        println "  " + obbFileName

    println '  (3)===============> adb push obb file to device...'
    String obbDestPath = 'sdcard/Android/obb/' + packageName
    commandLine 'adb', 'push', obbFilePath.replace(' ', '\\ '), '/' + obbDestPath + '/'

//必须等到上传完成之后，才能执行重命名任务
    doLast {
        exec {
            println '  (4)===============> adb rename obb file...'
            String newObbFileName = "main." + version + "." + packageName + ".obb"
            String oldFileFullPath = '/' + obbDestPath + '/' + obbFileName
            String newFileFullPath = '/' + obbDestPath + '/' + newObbFileName
            println '  old name:' + oldFileFullPath
            commandLine 'adb', 'shell', 'mv', oldFileFullPath, newFileFullPath
            println '  new name:' + newFileFullPath

            println '  (5)===============> Completed!!!'
        }


    }

}

```

### How to use task: pushObb?

* Add `apply from: 'copyobb.gradle'` in app level gradle.
* Open a terminal in Android Studio;
* Input the command and pass parameter with `-P`:

```shell
  ./gradlew -PobbPath="the obb file path on your mac which exported from unity" pushObb

  [[For example]]:
  ./gradlew -PobbPath="/Users/ColorfulDark/tmp/BSG0030/BSG0030.main.obb" pushObb

```
