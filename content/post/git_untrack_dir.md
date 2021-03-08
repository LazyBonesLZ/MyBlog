---
title: "git : remove directories tracked"
date: 2019-04-30T14:33:57+08:00
draft: false
categories: [Git]
tags: [git,取消跟踪,文件目录]
---


如果文件和目录已经被提交到git仓库，是可以通过git 命令来取消文件和目录的跟踪。

我们常用的sourcetree也提供了该功能，如果是某目录下已经有文件被提交过了，那么就不能再改工具中直接对文件夹取消跟踪，只能对显示有更改的文件一个一个取消，UI操作还要等刷新，费时费力。

为了防止误操作，先列出需要取消跟踪的文件：

```
git rm -r -n --cached <file or dir>

# -r  表示递归
# -n 表示先不删除，只是列出文件

```
在确认无误后，取消跟踪文件或目录：

```
git rm -r --cached <file or dir>
```
将已经取消的文件或目录加到 `.gitignore`,
然后将所有的改动提交仓库。
