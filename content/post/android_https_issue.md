---
title: "Android https 突然提示证书验证失败"
date: 2018-08-13T16:14:33+08:00
draft: false
categories: [android]
tags: [Android,Https,证书验证失败]
---

    项目中一直有https的请求，没有用到第三方的SDK,都是使用HttpUrlConnec tion去实现的请求。一直相安无事，突然测试人员报告说出现证书验证问题。网上各种查看资料解决，方案无非是加入自定义证书到工程或者是用信任所有证书的方式解决。但是，我们并没有用到自定义证书，如果用信任所有证书的方式，对于自身app的安全又无法保障了。

仔细分析每次https请求的异常log,提示证书不可用：

``` shell
W/System.err: javax.net.ssl.SSLHandshakeException: Chain validation failed
W/System.err:     at com.android.org.conscrypt.OpenSSLSocketImpl.startHandshake(OpenSSLSocketImpl.java:368)
W/System.err:     at com.android.okhttp.Connection.connectTls(Connection.java:1510)
W/System.err:     at com.android.okhttp.Connection.connectSocket(Connection.java:1458)
W/System.err:     at com.android.okhttp.Connection.connect(Connection.java:1413)
W/System.err:     at com.android.okhttp.Connection.connectAndSetOwner(Connection.java:1700)
W/System.err:     at com.android.okhttp.OkHttpClient$1.connectAndSetOwner(OkHttpClient.java:133)
W/System.err:     at com.android.okhttp.internal.http.HttpEngine.connect(HttpEngine.java:466)
W/System.err:     at com.android.okhttp.internal.http.HttpEngine.sendRequest(HttpEngine.java:371)
W/System.err:     at com.android.okhttp.internal.huc.HttpURLConnectionImpl.execute(HttpURLConnectionImpl.java:503)
W/System.err:     at com.android.okhttp.internal.huc.HttpURLConnectionImpl.getResponse(HttpURLConnectionImpl.java:438)
W/System.err:     at com.android.okhttp.internal.huc.HttpURLConnectionImpl.getResponseCode(HttpURLConnectionImpl.java:567)
W/System.err:     at com.android.okhttp.internal.huc.DelegatingHttpsURLConnection.getResponseCode(DelegatingHttpsURLConnection.java:105)
W/System.err:     at com.android.okhttp.internal.huc.HttpsURLConnectionImpl.getResponseCode(HttpsURLConnectionImpl.java)

```


是否跟证书的有效期限有关系呢?

果然，去查看系统的时间设置是否正常，发现原来测试人员由于测试需要，改变了系统的日期和时间的设置。

解决方案：

修改系统时间，打开“自动设置日期和时间”开关，让系统时间恢复当前正常时间。