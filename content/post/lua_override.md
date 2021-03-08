---
title: "Lua Override Methods"
date: 2019-04-18T10:01:05+08:00
draft: false
categories: [Lua]
tags: [Lua,override,方法重载]


最近在更新一个Lua项目中，很多地方调用了同一个方法，想在不改动调用逻辑的情况下，如何不执行原来的方法逻辑，而执行新的方法逻辑呢？
我们可以直接重载该方法，但是前提是必须在**第一次调用**该方法前就完成了重载。

```
请注意这种方式的前提：一定是要在该方法第一次被调用前完成你的重载，否则无效。
```

举例说明： ads_plugin_manager是一个全局对象，在其类文件中已经实现了方法showBanner的逻辑，项目中许多直接调用ads_plugin_manager:showBanner()。现在我想不改动任何调用该方法地方的代码。怎么操作？

* 创建lua文件：OverrideAdsPluginManager.lua

``` shell
ads_lua_manager.showBanner = function(...)
--override start
-- 请注意，如果方法实现需要访问类的其他方法或者变量，都可以通过ads_lua_manager.xxx的方式直接调用
-- override end
end
```
* 尽早引用OverrideAdsPluginManager.lua

```
require "libii/common/OverrideShowBanner"
```
