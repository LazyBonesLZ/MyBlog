---
title: "Git：上传大文件报错解决方法"
date: 2021-03-15T11:08:08+08:00
draft: false
categories: [Git]
tags: [git,大文件上传报错]
---

问题描述：
git本地仓库提交之后，向远程仓库推送时报错,提示大文件问题。

```
error: pack-objects died of signal 13
error: failed to push some refs to 'git@github.com:example/example.git' 

```

在[stackoverflow](https://stackoverflow.com/questions/18559015/cant-push-to-github-error-pack-objects-died-of-signal-13),找到解决方案提示是因为文件大小限制导致。
所以就直接到已提交到本地仓库的找到大文件xxx.hrpof，然后删除后立马又提交了本地仓库。但是推送的时候依然之前的错误。原因是只是删除了文件，但是git仓库还是有大文件的记录，所以应该是先删除大文件的git跟踪，然后再删除大文件，最后提交后再推送。

所以，我们必须先回退到生产了xxx.hrpof的那个git提交版本，再按照上述步骤操作。

``` shell
#1. 强制回退到某个git版本

 git reset --hard <commit_id>

#2. 删除文件跟踪
  git rm -r --cached <file>
  # Stage our giant file for removal, but leave it on disk

  git commit --amend -CHEAD
  # Amend the previous commit with your change
  # Simply making a new commit won't work, as you need
  # to remove the file from the unpushed history as well

#3. git 推送
  git push 
  # Push our rewritten, smaller commit

```