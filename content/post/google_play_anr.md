---
title: "Google Play Console: 如何通过Android Vitals记录的日志来优化App的ANR"
date: 2021-03-15T11:52:29+08:00
draft: false
categories: [Android]
tags: [Google play console, Android vitals, ANR]
---

 在Android应用开发中，最令开发人员抓狂的是各种莫名其妙的ANR，出现这种问题时，很少能在自己的测试设备或者开发环境中重现。但是ANR出现的频率过高却又十分影响用户的体验。

 Google play console提供了 Android vitals工具，以供开发人员检查应用上线之后的性能表现。其ANR数据记录了用户设备的详尽数据和ANR发生时的日志。但是，开发人员在检查这些日志的时候，通常也很懵，无从下手。

 但是Google官方没有具体的说明文档告知开发者应该如何分析这些stacktrace日志记录来优化app的性能。所以借助最近要解决公司已上线的游戏出现的 ANR 问题，简单总结一下我是怎么处理的。

 查找Google官方的文档，最多也是告知ANR出现的原理以及如何尽量避免ANR的建议，根本就没有说如果有了后台所记录ANR发生时的stack trace 日志来具体处理问题。好在找到一篇国外大神几年的一篇博客 [Deadlocks and ANRs](http://zenandroid.io/deadlocks-and-anrs/)，通过说明互斥锁和死锁原理，和死锁问题导致ANR时，他是如何利用Android vitals的ANR数据最终达到优化目的的，可以借鉴。


 而我的处理步骤是这样的：

### 1.[StrictMode](https://developer.android.com/reference/android/os/StrictMode)

StrictMode是一个开发人员工具，可以检测到您可能偶然执行的操作并将其引起您的注意，以便您可以进行修复。 在应用上线之前，开启改模式可以帮助开发人员找到一些可能引起ANR的问题代码：比如在主线程上调用第三方sdk的网络请求接口、主线程上有耗时计算的逻辑或者在BroadcastRecevier中有耗时的计算等等。

StrictMode主要检测两大问题，一个是线程策略，即TreadPolicy，另一个是VM策略，即VmPolicy。
#### ThreadPolicy线程策略检测

* 自定义的耗时调用 使用detectCustomSlowCalls()开启
* 磁盘读取操作 使用detectDiskReads()开启
* 磁盘写入操作 使用detectDiskWrites()开启
* 网络操作 使用detectNetwork()开启

#### VmPolicy虚拟机策略检测

 * Activity泄露 使用detectActivityLeaks()开启
 * 未关闭的Closable对象泄露 使用detectLeakedClosableObjects()开启
 * 泄露的Sqlite对象 使用detectLeakedSqlLiteObjects()开启
 * 检测实例数量 使用setClassInstanceLimit()开启


所以，在开发阶段，我们可以尽可能的早的开启StrictMode. 在Application 或者 Activity的onCreate方法中均可，但是需要注意的是，通过测试发现，如果是在Application开启StrictMode,可能导致无法检测到某些自定义的耗时逻辑：
   [点我看这里](https://stackoverflow.com/questions/23997448/why-setting-up-strictmode-not-working-in-application-without-handler)

   ```shell

   public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        StrictMode.setThreadPolicy(new StrictMode.ThreadPolicy.Builder()
                .detectCustomSlowCalls() //API等级11，使用StrictMode.noteSlowCode
                .detectDiskReads()
                .detectDiskWrites()
                .detectNetwork()   // or .detectAll() for all detectable problems
                .penaltyDialog() //弹出违规提示对话框
                .penaltyLog() //在Logcat 中打印违规异常信息
                .penaltyFlashScreen() //API等级11
                .build());
        StrictMode.setVmPolicy(new StrictMode.VmPolicy.Builder()
                .detectLeakedSqlLiteObjects()
                .detectLeakedClosableObjects() //API等级11
                .penaltyLog()
                .penaltyDeath()
                .build());
        Log.e(TAG,"onCreate : " + this);
        // ...
    }

   ```

   分析StrictMode log,主要是查看网络请求或者I/O操作等是否在主线程上，如果是的话就要优化自己的代码。

   ```shell
   adb logcat | grep StrictMode
   ```

   但是要注意的是：

   * 只在开发阶段启用StrictMode，发布应用或者release版本一定要禁用它。
   * 严格模式无法监控JNI中的磁盘IO和网络请求。
   * 应用中并非需要解决全部的违例情况，比如有些IO操作必须在主线程中进行。


 ### 2. 尽量使用线程池来管理线程,因为每个子线程的创建，对于系统的开销是非常大的。

 ### 3. 尽量少使用Timer来处理计时逻辑，可以使用ScheduledExecutorService代替Timer.


 ### 参考：
 1. Deadlocks and ANRs： [http://zenandroid.io/deadlocks-and-anrs/](http://zenandroid.io/deadlocks-and-anrs/)
 2. Java 四种线程池newCachedThreadPool,newFixedThreadPool,newScheduledThreadPool,
 newSingleThreadExecutor: [https://www.cnblogs.com/zhujiabin/p/5404771.html](https://www.cnblogs.com/zhujiabin/p/5404771.html)
 3. StrictMode: [https://developer.android.com/reference/android/os/StrictMode](https://developer.android.com/reference/android/os/StrictMode)
 4. ANR: [https://developer.android.com/topic/performance/vitals/anr.html](https://developer.android.com/topic/performance/vitals/anr.html)
 5. Android严苛模式StrictMode使用详解 [https://blog.csdn.net/mynameishuangshuai/article/details/51742375](https://blog.csdn.net/mynameishuangshuai/article/details/51742375)