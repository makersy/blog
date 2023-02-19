---
title: eclipse建立web项目时忘了生成xml文件的解决办法
date: 2018-12-13 22:03:31
tags:
- eclipse

categories:
- 发现
---

刚学web没多久，建立项目时忘了去勾选建立web.xml文件的选项。当我写了好多代码，接下来需要修改这个文件的时候才发现，我没有生成它...接下来在摸索中找到了解决办法。
<!-- more -->
首先在创建的项目上右键，找到Java EE Tools，然后点击Generate Deployment Descriptor Stub，如下图（我的已经生成了所以是灰色）。完了之后会发现，web.xml躺在WEB-INF文件夹下~

![流程](https://img-blog.csdnimg.cn/20181213221307683.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L21ha2Vyc3k=,size_16,color_FFFFFF,t_70)

（完）