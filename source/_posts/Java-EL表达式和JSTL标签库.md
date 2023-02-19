---
title: Java-EL表达式和JSTL标签库
date: 2018-12-13 20:50:54
tags:
- Java
- EL表达式
- JSTL标签库

categories:
- Java
- Web
---
#### 关于EL表达式
**EL表达式**全名为Expression Language，是一种为了在JSP中计算和输出Java对象的简单语言。
基本语法： `${expression}`
以上语句中，*expression*为有效的表达式。该表达式可以和静态文本混合，还可以与其他表达式结合成为更大的表达式。  
<!-- more -->
#### EL四个作用域对象  
![](https://img.mukewang.com/climg/5c0dd2980001c66619201080.jpg)
如果我们在jsp页面调用Servlet的数据信息时，不写这个范围，那么EL就会从在小到大的范围内依次去寻找我们调用的这些数据。（因此最好写上）

#### EL表达式输出
语法：`${[作用域.]属性名[.子属性]}`
EL支持绝大多数对象输出，本质是执行*toString*方法
例：
>${title}
${requestScope.student.name}
${emp.salary + 300}
${ 1<=3 && 2>4 }

获取数据：
我们可以使用EL的内置对象*param*来简化获取**url**或者**请求体**中的数据
语法：`${param.参数名}`
例如当url是 *https://class.makersy.com/lesson?mid=17331*
在Servlet中，我们用request.getParameter("mid")获取
而现在可以用`${param.mid}`获取了
其实，`${param.参数名}`就是`request.getParameter（“参数名”);`的简化形式  

#### JSTL标签库
##### 使用JSTL表达式

JSTL是JSP标准标签库的简称，它提供的标签能一定程度上代替Java代码，例如`<c:forEach/>`标签能实现Java语言中的循环功能。

使用前：
1.下载*jstl.jar*和*standard.jar*包

2将这两个包复制到*web-inf\lib* 目录下

3.在JSP页面中添加指令，例如：

核心标签库初始化
`<%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix = "c" %>`
或
格式标签库初始化
`<%@ taglib uri = "http://java.sun.com/jsp/jstl/fmt" prefix = "fmt" %>`

#### JSTL标签库
JSTL有五个标签库，分别是：核心标签库、格式标签库、函数标签库、SQL标签库、XML标签库。
主要用**前两者**。

核心标签库主要完成JSP页面常用功能，包括JSTL表达式标签、URL标签、流程控制标签和循环标签等。其中，表达式标签有

1. 和显示操作有关的
`<c:out value=" ${ news.title }"/>`输出属性的值 数据库中给出的标签可以显示；
`<c:set var="uid" value="admin" scope="request"/>` 存入变量,把uid的变量存入request中;
`<c:remove var="uid" value="admin" scope="request"/>`移除变量  把request中的uid的变量移除.

2. 实现程序逻辑相关的
**c:foreach标签**
`<c:forEach var="对象" items=”保存在request中的数组" varStatus="status">循环的的变量<c:forEach />`
`<c:forEach>`标签具有以下一些属性：
	- var：迭代参数的名称。在迭代体中可以使用的变量的名称，用来表示每一个迭代变量。类型为String。 
	- items：要进行迭代的集合。对于它所支持的类型将在下面进行讲解。 
   	- varStatus：迭代变量的名称，用来表示迭代的状态，可以访问到迭代自身的信息。 
   	- begin：如果指定了items，那么迭代就从items[begin]开始进行迭代；如果没有指定items，那么就从begin开始迭代。它的类型为整数。 
	- end：如果指定了items，那么就在items[end]结束迭代；如果没有指定items，那么就在end结束迭代。它的类型也为整数。 
	- step：迭代的步长。

`<c:forEach>`标签的items属性支持Java平台所提供的所有标准集合类型。此外，您可以使用该操作来迭代数组（包括基本类型数组）中的元素。它所支持的集合类型以及迭代的元素如下所示： 
​            java.util.Collection：调用iterator()来获得的元素。             java.util.Map：通过java.util.Map.Entry所获得的实例。 
​            java.util.Iterator：迭代器元素。 
​            java.util.Enumeration：枚举元素。 
​            Object实例数组：数组元素。 
​            基本类型值数组：经过包装的数组元素。 
​            用逗号定界的String：分割后的子字符串。 
​            javax.servlet.jsp.jstl.sql.Result：SQL查询所获得的行。 
​          不论是对整数还是对集合进行迭代， `<c:forEach>`的varStatus属性所起的作用相同。和var属性一样，varStatus用于创建限定了作用域的变量（改变量只在当前标签体内起作用）。不过，由varStatus属性命名的变量并不存储当前索引值或当前元素，而是赋予*javax.servlet.jsp.jstl.core.LoopTagStatus*类的实例。该类包含了一系列的特性，它们描述了迭代的当前状态，如下这些属性的含义如下所示： 
​            current：当前这次迭代的（集合中的）项。 
​            index：当前这次迭代从0开始的迭代索引。 
​            count：当前这次迭代从1开始的迭代计数。 
​            first：用来表明当前这轮迭代是否为第一次迭代，该属性为boolean类型。 
​            last：用来表明当前这轮迭代是否为最后一次迭代，该属性为boolean类型。 
​            begin：begin属性的值。 
​            end：end属性的值 
​            step：step属性的值
​            
下面是一个使用的小例子，判断x的值并输出他所在的区间。  
```html
<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
request.setAttribute("x", "11");
%>
<c:choose>
<c:when test="${x>0 && x<=10 }">
<h1 style="color:blue">1-10之间的整数</h1>
</c:when>
<c:when test="${x>10 && x<=20 }">
<h1 style="color:lightcoral">11-20之间的整数</h1>
</c:when>

</c:choose>
</body>
</html>
```

**格式化日期**
```html
jstl日期格式化
代码
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
request.setAttribute("amt", "1898923.234");
request.setAttribute("now", new Date());
request.setAttribute("html", "<a href='index.html'>index</a>");
request.setAttribute("nothing", null);
%>
<!-- 
formatDate patttern
yyyy - 四位年
MM = 两位月
dd = 两位日
HH - 24小时制
hh - 12小时制
mm - 分钟
ss - 秒数
SSS - 毫秒
-->
<h2>
<fmt:formatDate value="${requestScope.now }" pattern="yyyy年MM月dd日HH时mm分ss秒SSS毫秒" />	
</h2>
</body>
</html>
```