---
title: "Hugo+Nginx： 利用webhook自动部署静态网站到远程CentOS服务器（二）"
date: 2019-04-25T05:13:24+08:00
draft: false
categories: [website]
tags: [Web,Nginx,CentOS,Github,Webhook,自动部署]
---

# 前篇提要
在上一篇文章，我们详细记录了如何购买阿里云服务器的步骤和搭建博客网站的部分准备工作。本文将继续记录安装服务器环境的步骤。

# 服务器软件环境安装
## 1. 安装git

```
sudo yum install git
```
## [2. 安装Nginx](https://blog.csdn.net/hanshileiai/article/details/54571028)
Nginx是一个高性能的web服务器软件。它是一个比apache更灵活和轻量级的程序。

* 第一步 - 安装EPEL
  EPEL代表企业Linux的额外包。因为yum作为软件包管理器不在其默认存储库中包括nginx的最新版本，安    装EPEL将确保CentOS上的nginx保持最新。

  要安装EPEL，请打开终端并输入：
  
  ```
  sudo yum install epel-release
  ```

* 第二步 - 安装nginx
  要安装nginx，打开终端并输入：
  
  ```
  sudo yum install nginx
  ```
  在您对提示两次回答yes（第一次涉及导入EPEL gpg-key）后，nginx将在您的虚拟专用服务器上完成安装。

* 第三步 - 启动nginx
  nginx不会自己启动。要运行nginx，请输入：
  
  ```
  sudo /etc/init.d/nginx start
  ```
  您可以通过将浏览器定向到您的IP地址来确认nginx已安装在您的VPS上。
  
  ```
  http://xxx.xxx.xxx.xxx
  ```
  在页面上，您将看到单词“Welcome to nginx”。
  恭喜！你现在已经安装了nginx。
 * 如果你看到的是如下错误信息，请移步查看Troubleshoting

```
nginx: [emerg] socket() [::]:80 failed (97: Address family not supported by protocol)
```
# 3. [安装Nodejs 和 npm](https://tecadmin.net/install-latest-nodejs-and-npm-on-centos/)
由于我们之后在服务器上需要启动一个监听Gihtub的push事件Js脚本服务，所以需要nodejs支持。

npm是什么东东？npm其实是Node.js的包管理工具（package manager）。

为啥我们需要一个包管理工具呢？因为我们在Node.js上开发时，会用到很多别人写的JavaScript代码。如果我们要使用别人写的某个包，每次都根据名称搜索一下官方网站，下载代码，解压，再使用，非常繁琐。于是一个集中管理的工具应运而生：大家都把自己开发的模块打包后放到npm官网上，如果要使用，直接通过npm安装就可以直接用，不用管代码存在哪，应该从哪下载。

更重要的是，如果我们要使用模块A，而模块A又依赖于模块B，模块B又依赖于模块X和模块Y，npm可以根据依赖关系，把所有依赖的包都下载下来并管理起来。否则，靠我们自己手动管理，肯定既麻烦又容易出错。

讲了这么多，npm究竟在哪？

其实npm已经在Node.js安装的时候顺带装好了。所以，我们只需要安装nodejs就行，然后检查一下各自的版本号确认是否安装成功。
* 添加NodeJs Yum Repository

```
yum install -y gcc-c++ make
curl -sL https://rpm.nodesource.com/setup_10.x | sudo -E bash -
```
* 安装NodeJs

```
sudo yum install nodejs
```
* 检查nodejs和npm 版本

```
node -v
npm -v
```
# 4.安装pm2
pm2是一个很好用的Node应用的进程管理器，具有守护进程，监控，日志等一整套完整的功能，用它可以非常方便地启动、重启Node应用，并且可以实现Node应用的开机启动。用npm安装pm2：

```
npm install pm2@latest -g
```
至此，服务器端的软件配置基本完成。我们将在下一篇详细说明如何在本地利用hugo生成静态网站文件以及自动上传等脚本的配置。

# Troubleshoting
* 1. nginx: [emerg] socket() [::]:80 failed (97: Address family not supported by protocol)

```
centos6.5环境

修改nginx配置文件后，重启报错：

nginx: [emerg] socket() [::]:80 failed (97: Address family not supported by protocol)

解决办法：

1.打开终端界面，输入 
vim /etc/nginx/conf.d/default.conf

2.然后点击“i”键进入输入模式：
将
listen       80 default_server;
listen       [::]:80 default_server;


改为：
listen       80;
#listen       [::]:80 default_server;

3. 点击“Esc”键，输入“:wq”保存。

4. 在终端界面输入如下命令重启nginx：
   sudo /etc/init.d/nginx start

```
