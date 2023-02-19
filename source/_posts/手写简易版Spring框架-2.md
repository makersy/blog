---
title: 手写简易版Spring框架-2
date: 2019-07-09 22:41:16
tags:
- Spring

categories:
- Spring
---

### 前言

Spring框架作为当前最流行的JavaEE框架之一，简化了代码，提升了性能。而在这其中最主要的技术就是依赖注入了。所谓依赖注入，就是创建被调用者的工作由spring来完成，然后将其注入调用者。

本篇主要介绍了依赖注入和控制反转，并分析了上一篇中，依赖注入的代码实现原理。

<!-- more -->

### 关于Bean

Bean的特点：

- 生命周期较长
- 在整个虚拟机内可见
- 维护成本高，单例存在

Bean优势

- 运行期效率高
- 统一维护，便于管理和扩展
- 维护成本高，因此单例存在

### Bean的创建

#### 普通创建方式

![mark](http://qn.haoliny.top/blog/20190706/2w4UqJTEdmEm.jpg?imageslim)

上图中就可以看到，如果按照普通的类创建方式，A类中有成员C，B类中有成员C，C类中有成员B，那么我们如果为A、B、C类各创建有一个对象，那么堆中就会有1个A对象、2个B对象、1个C对象和3个Z对象，十分地浪费资源。

#### Spring实现方式

- 包扫描并自动装配<font color="red">（反射）</font>
- BeanFactory<font color="red">（统一管理）</font>
- 依赖注入

**控制反转 / 依赖注入**

- IoC（Invension of Control）：思想
- DI（Dependency Injection）：方式

**Bean创建方式**

Spring中采用了BeanFactory来管理Bean，需要时就将Bean注入。其创建方式如下图：

![mark](http://qn.haoliny.top/blog/20190706/9hISTQQNC83n.jpg?imageslim)

使用单例BeanFactory来管理Bean，使得所有的Bean都是单例，在JVM中只有一个，相比于普通类创建方式，大大地节约了资源。

**实现依赖注入**

- 扫描包获得类定义
- 初始化Bean，并实现依赖注入
- 解决Bean初始化顺序问题

**依赖注入次序问题**

![mark](http://qn.haoliny.top/blog/20190706/v2MlXBpapQpR.png?imageslim)

由图中可以看出整个依赖注入的流程，首先就是判断要创建的Bean里面是否含有依赖，如果没有依赖就直接创建并放入BeanFactory，如果有依赖就进行下一步；判断BeanFactory中是否含有所需的依赖，如果有的话就直接set到Bean中，如果没有就先放弃创建当前Bean，先创建后面的，后面的创建完了再来从头遍历前面创建失败的Bean。这里要注意一个问题：如果Bean之间相互依赖就会出现死循环问题。要解决它，我们可以在遍历完后检查要创建的Bean是否减少，如果Bean没有减少，说明陷入循环依赖，这时就要抛出异常，退出死循环。