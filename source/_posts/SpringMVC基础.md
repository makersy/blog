---
title: SpringMVC基础
date: 2019-07-09 22:00:37
tags:
---



### DispatcherServlet

![mark](http://qn.haoliny.top/blog/20190709/2G4zSnBzzDvB.jpg?imageslim)

Spring采用了一个Dispatcherservlet来进行请求分发，所有请求都会经过这个servlet，然后根据现有mapping handler进行请求uri匹配进行处理。

