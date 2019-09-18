---
title: "Firebase In-App Messaging:triggerEvent not working"
date: 2019-09-18T14:55:36+08:00
draft: false
categories: [Android]
tags: [Firebase,In-App Messaging not working]
---

#### 什么是Firebase In-App Messaging？
官方解释：

> Firebase In-App Messaging helps you engage your app's active users by sending them targeted, contextual messages that encourage them to use key app features. For example, you could send an in-app message to get users to subscribe, watch a video, complete a level, or buy an item. You can customize messages as cards, banners, modals, or images, and set up triggers so that they appear exactly when they'd benefit your users most.
Use Firebase In-App Messaging to encourage exploration and discovery: highlight a sale or coupon in your ecommerce app, give clues or tips in your game, or prompt a like or share in your social media app.

#### 集成 Firebase In-App Messaging
令人发指的简单，竟然只需要按照官方文档集成了sdk就完事儿，几乎零代码。

```shell
dependencies {
    // ...

    // Add the In-App Messaging and Analytics dependencies:
    implementation 'com.google.firebase:firebase-inappmessaging-display:19.0.0'
    implementation 'com.google.firebase:firebase-analytics:17.2.0'

    // Check that Firebase core is up-to-date:
    implementation 'com.google.firebase:firebase-core:17.2.0'
}
```

准备工作都完成之后，根据我们的业务需求来进行具体的实现，在对比了直接使用firebase event触发等默认的实现方式之后，我们决定通过其提供的`triggerEvent`方法来实现。因为我们使用的Bata版测试过程中，发现如果用默认的firebase event:例如`on_foreground`等等来触发In-App Messaging,很多行为不可控。

但是，大量的测试现象表明在app第一次启动的时候，居然无法触发In-App Messaging,尽管debug调试已经成功的调用过`triggerEvent`:

```shell
public void inAppMsgTriggerEvent(String triggerEvent){
        if (TextUtils.isEmpty(triggerEvent)) {
            Log.e(TAG,"Trigger event can NOT be NULL");
            return;
        }
        registerFIAMListeners();
        FirebaseInAppMessaging.getInstance().triggerEvent(triggerEvent);
    }

```
####分析：
在最初阶段，我们认为可能是sdk目前还在beta版，还不太稳定。但是，app在resume之后，就能很好的触发In-App Messaging。有了一定的规律之后，就不能简单的归罪于sdk的bug了。是否我们的测试demo的代码有问题？在Logcat通过`FIAM`关键字来过滤，分析In-App Messaging 的log输出发现，在app启动进入MainAcitiy后，有如下的输出：
>I/FIAM.Headless: Removing display event listener
I/FIAM.Headless: Removing display event listener

连续两次remove了某种event listener, 看起来不太正常。去源码看看能否找到相关的。

借助Andorid Studio，在`Project`模式下，展开`External Libraries`,找到In-App Messaging SDK. 在 `FirebaseInAppMessaging.class`找到了如下方法：

```shell
@Keep
    @KeepForSdk
    public void clearDisplayListener() {
        Logging.logi("Removing display event listener");
        this.listener = Maybe.empty();
    }
```
然后经过一番人肉搜索，在`FirebaseInAppMessagingDisplay.class`中找到了`clearDisplayListener()`的调用。

``` shell 
 @Keep
    public void onActivityPaused(Activity activity) {
        this.headlessInAppMessaging.clearDisplayListener();
        this.imageLoader.cancelTag(activity.getClass());
        this.removeDisplayedFiam(activity);
        super.onActivityPaused(activity);
    }

    @Keep
    public void onActivityDestroyed(Activity activity) {
        this.headlessInAppMessaging.clearDisplayListener();
        this.imageLoader.cancelTag(activity.getClass());
        this.removeDisplayedFiam(activity);
        super.onActivityDestroyed(activity);
    }


```
至此，虽然我们不清楚SDK中的具体逻辑，但是可以判定该方法的调用跟app中的Activity生命周期方法是有关联的。

然后首先是去demo工程中，查看各个Activity的AndroidManifest.xml中的声明，跳转情况。发现了demo的启动Activity并非MainActivity,而是`WelcomeActivity`,在其`onCreate`方法中跳转后立马调用了`finish()`方法。

```shell
 @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        TLog.e(TAG,"activity on create call------");
        boolean bTestAds = AdsTools.isTestAds(this);
        if (bTestAds){
            Intent intent = new Intent(this,AdsUnitIDActivity.class);
            startActivity(intent);
        }else {
            Intent intent = new Intent(this,NativeActivity.class);
            startActivity(intent);
        }

       finish();
    }

```
这就是导致前面提到的奇怪log为什们会输出两次。最后两种解决方案：

* 直接注释掉`finish()`调用
* 将MainActivity声明为启动Activity.

但是为什么直接调用`finish()`方法关闭掉前一个Activity后，In-App Messaging在App每次启动，就会出现`triggerEvent`失效的情况，是不是又回到了SDK内部有问题的结论了呢？等待官方解释。。。