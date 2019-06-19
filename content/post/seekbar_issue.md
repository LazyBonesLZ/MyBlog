---
title: "自定义seekbar遇到的问题"
date: 2018-11-07T15:00:47+08:00
draft: false
categories: [android]
tags: [Android,Seekbar,自定义进度条]
---

项目需要自定义seekbar样式，记录一下这个过程中的问题和解决方案。
UI设计样式如图：宽度填满父view

![tmp4ddd6566.png](https://upload-images.jianshu.io/upload_images/6174818-fd13ec969ae73a52.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

在实现的过程中出现过一些问题：

1.thumb在滑动的过程中，出现了压缩

![tmp47659cb3.png](https://upload-images.jianshu.io/upload_images/6174818-fb2552f76dddf0a5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

2.thumb在起点和终点只显示来一半

![tmp6edf23a5.png](https://upload-images.jianshu.io/upload_images/6174818-8cb323146c1c3cd0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

3.seekbar宽度并未填充满父view,而是在左右两侧保留了默认的间距。

![tmp22ee10af.png](https://upload-images.jianshu.io/upload_images/6174818-25d62127527b6c67.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


解决问题:
*  由于thumb设置了“press”的效果，发现按下时的资源尺寸和正常时的尺寸不一样导致压缩。
* 设置 

```
android:thumbOffset="0dp"
```
* 在设置padding，在android5.0之前，修改paddingLeft 和 paddingRight就够了，但是android5.0之后，还需要加上paddingStart和paddingEnd

``` shell
android:paddingLeft="0dp"
android:paddingRight="0dp"
android:paddingStart="0dp"
android:paddingEnd="0dp"
```
这样就把这三个问题解决。

* 最终的代码

``` shell
<SeekBar
            android:id="@+id/bottom_seek_progress"
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:layout_gravity="center_vertical"
            android:max="100"
            android:maxHeight="6dp"
            android:minHeight="1dp"
            android:paddingLeft="0dp"
            android:paddingRight="0dp"
            android:paddingStart="0dp"
            android:paddingEnd="0dp"
            android:progressDrawable="@drawable/jz_bottom_seek_progress"
            android:splitTrack="false"
            android:thumb="@drawable/jz_bottom_seek_thumb"
            android:thumbOffset="0dp" />
```
1.进度条的三层背景：`jz_bottom_seek_progress.xml`

```shell 
<?xml version="1.0" encoding="utf-8"?>
<layer-list xmlns:android="http://schemas.android.com/apk/res/android">
    <item android:id="@android:id/background">
        <shape>
            <solid android:color="#a5ffffff" />
            <size android:height="6dp" />
            <corners android:radius="9dip" />
        </shape>
    </item>
    <item android:id="@android:id/secondaryProgress">
        <clip>
            <shape>
                <solid android:color="#1F551CA5" />
                <size android:height="6dp" />
                <corners android:radius="9dip" />
            </shape>
        </clip>
    </item>
    <item android:id="@android:id/progress">
        <clip>
            <shape>
                <solid android:color="#551CA5" />
                <size android:height="6dp" />
                <corners android:radius="9dip" />
            </shape>
        </clip>
    </item>
</layer-list>
```
2.thumb的背景：`jz_bottom_seek_thumb.xml`

``` shell 
<?xml version="1.0" encoding="utf-8"?>
<selector xmlns:android="http://schemas.android.com/apk/res/android">
    <item android:drawable="@drawable/jz_seek_thumb_pressed" android:state_pressed="true" />
    <item android:drawable="@drawable/jz_seek_thumb_normal" />
</selector>
```
3.thumb按下状态的背景：`jz_seek_thumb_pressed.xml`

```shell 
<?xml version="1.0" encoding="utf-8"?>
<shape xmlns:android="http://schemas.android.com/apk/res/android"
    android:shape="oval">
    <solid android:color="#ffffffff" />
    <size
        android:width="20dp"
        android:height="20dp" />
</shape>
```
4.thumb正常状态的背景：`jz_seek_thumb_normal.xml`

``` shell
<?xml version="1.0" encoding="utf-8"?>
<shape xmlns:android="http://schemas.android.com/apk/res/android"
    android:shape="oval">
    <solid android:color="#fff0f0f0" />
    <size
        android:width="20dp"
        android:height="20dp" />
    <stroke android:width="6dp"
        android:color="#551CA5"/>
</shape>
```

