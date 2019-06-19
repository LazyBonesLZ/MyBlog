---
title: "填坑：有工程依赖时，Gradle uploadArchives to Nexus/Maven"
date: 2018-07-12T14:35:36+08:00
draft: false
categories: [android]
tags: [Android,Nexus,Private Maven,Multiple Module Dependencies]
---

很多时候，Android Studio中所创建的工程，会依赖一个或多个Module。Module 生成的AAR库，可以上传到maven或者私服Nexus作为公用的SDK。Gradle子工程之间通过 compile/implementation project(":XXX")这种方式依赖是非常便利的，但是这样的时候，如果用uploadArchives上传AAR到Maven，生成的pom.xml是不正确的,以致于在工程中依赖我们上传的库时，无法找到它如下图所示：

![](/img/02_nexus/01.png)
<div align="center">示意图</div>

所以本文记录在这种情况下，如何上传AAR到Maven或[Nexus](https://www.sonatype.com/download-oss-sonatype).

# 一. 前提：
本文以上传到Nexus为例说明，如何本地配置Nexus,请参见[这里](https://help.sonatype.com/repomanager3/installation)。

# 二. 具体步骤
我们以测试demo的创建过程进行详细说明。工程结构如图所示：其中mylibrary依赖于common库

![](/img/02_nexus/03.png)
<div align="center">工程结构，其中mylibrary依赖于common库</div>

## 1 创建工程
### 1.1 创建Android工程，新建module：common和mylibrary
### 1.2 配置project级 `gradle.properties`:

![](/img/02_nexus/03.png)
<div align="center">project gradle.properties</div>

### 1.3 在`common module`下，新建`gradle.properties`文件，用来声明该module的名称和版本号。

![](/img/02_nexus/04.png)
<div align="center">common gradle.properties</div>



### 1.4 `mylibrary module`下进行同样的步骤，参见上一步2.3.
### 1.5 创建上传aar的`gradle`文件，实现上传的task. 
在project级目录下，新建mvn_push.gradle文件

``` shell 
apply plugin: 'maven'

def getRepositoryUsername() {

    return hasProperty('NEXUS_USERNAME') ? NEXUS_USERNAME : ""

}

def getRepositoryPassword() {

    return hasProperty('NEXUS_PASSWORD') ? NEXUS_PASSWORD : ""

}

uploadArchives {

    configuration = configurations.archives

    repositories {

        mavenDeployer {

            repository(url: NEXUS_URL) {

                authentication(userName: getRepositoryUsername(), password: getRepositoryPassword())

                pom.groupId = GROUP_ID

                pom.artifactId = ARTIFACT_ID

                pom.version = VERSION

            }

            pom.whenConfigured { pom ->

                pom.dependencies.forEach { dep ->

                    if (dep.getVersion() == "unspecified") {

                        println("--modify the dependenies module in pom.xml--->>" + dep.getArtifactId())

                        dep.setGroupId(GROUP_ID)

                        dep.setVersion(VERSION)

                    }

                }

            }

        }

    }

}
```

### 1.6 引用mvp_push.gradle
分别在common 和 mylibrary 的build.gradle中添加如下代码：

```
apply from:'../mvn_push.gradle'

```

如图所示：

![](/img/02_nexus/05.png)


## 2. 上传common库和mylibrary库
执行 `gradlew upload` 或者 分别执行`uploadArchives task`,完成后即可在nexus仓库中查看。

![](/img/02_nexus/06.png)
<div align="center"> uplaodArchives </div>





## 3.引用上传的库
### 3.1 在project的build.gradle中添加如下配置，该url即nexus仓库的位置：

```
maven { url"http://localhost:8081/repository/android/" }
```




### 3.2 在app的build.gradle中添加依赖
``` shell 
dependencies {

     implementation fileTree(dir:'libs',include: ['*.jar'])

    implementation'com.android.support:appcompat-v7:27.1.1'

    implementation'com.android.support.constraint:constraint-layout:1.1.2'

    testImplementation'junit:junit:4.12'

    androidTestImplementation'com.android.support.test:runner:1.0.2'

    androidTestImplementation'com.android.support.test.espresso:espresso-core:3.0.2'

    implementation'test.com.ssc.libs:mylibrary:1.0.0'

    implementation'test.com.ssc.libs:common:1.0.0'

}
```

以上。

源码地址：[https://github.com/LazyBonesLZ/NexusTest](https://github.com/LazyBonesLZ/NexusTest)，demo中配置的nexus仓库url是我本地服务地址，请改成你创建好的nexus仓库地址。

参考：

* [https://stackoverflow.com/questions/37250675/how-to-setup-dependencies-in-a-multi-module-android-gradle-project-with-interdep](https://stackoverflow.com/questions/37250675/how-to-setup-dependencies-in-a-multi-module-android-gradle-project-with-interdep)

* [https://github.com/hannesstruss/WindFish](https://github.com/hannesstruss/WindFish)