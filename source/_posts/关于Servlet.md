---
title: 关于Servlet和JSP
date: 2018-12-09 22:44:38
tags: 
- Java
- Web
- Servlet
categories:
- Java
- Web
---

#### 请求转发和响应重定向  
- 请求转发： 是服务器跳转，只产生一次请求
`request.getRequestDispatcher(url).forward(request,response）`

<!-- more -->

![](https://img.mukewang.com/climg/5c0b3dc60001192819201080.jpg)  
- 响应重定向： 是浏览器端跳转，会产生两次请求
地址栏会变成最后的url （处理完成第一个请求之后返回一个特殊的响应给浏览器由浏览器重新发起另一个请求到新的资源）
`response.sendRedirect(url);`
![](https://img.mukewang.com/climg/5c0b3e150001b54219201080.jpg)
#### HTTP状态码
打开网页可根据出现的状态码来判断处于什么状态。
![](https://img.mukewang.com/climg/5c0a572d000116ba19201080.jpg)

#### ContentType的作用
ContentType决定浏览器采用何种方式对相应体进行处理
![](https://img.mukewang.com/climg/5c0a58e00001c00019201080.jpg)

#### Cookie
Cookie是浏览器保存在本地的文本内容
Cookie常用于保存登录状态、用户资料等小文本
Cookie具有时效性，Cookie内容会伴随请求发送给Tomcat  
```java
//Cookie部分doGet函数
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    System.out.println("用户登录成功！");
    Cookie cookie = new Cookie("user", "admin");
    cookie.setMaxAge(60*60*24*7);//有效期七天内有效
    response.addCookie(cookie);
    response.getWriter().println("login success");
}
//使用cookie的函数
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    Cookie[] cookies = request.getCookies();
    if( cookies==null ) {
    	response.getWriter().println("user not login");
	}
	String user = null;
    for( Cookie cookie : cookies ) {
        System.out.println(cookie.getName() + ":" + cookie.getValue());
        if( cookie.getName().equals("user") ) {
            user = cookie.getValue();
            break;
    	}
	}
    if( user == null ) {
    	response.getWriter().println("user not login");
    }else {
    	response.getWriter().println("user : " + user);
    }

}
```

#### Session
Session(用户会话)： 用于保存于“浏览器窗口”对应的数据。它与Cookie的不同是：Cookie保存的数据在**客户端**，二Session保存的数据在**服务器**。

session是与**窗口**绑定的，保存在tomcat服务器的数据是30分钟.

Session通过浏览器Cookie的<u>SessionId</u>提取对应用户的数据

浏览器第一次向服务器发送请求时，服务器在内存中开辟一块儿空间用于存放这个会话的信息，并把这块空间的id（sessionId）返回给浏览器。浏览器将sessionId存放在cookie中，之后<u>每次向服务器发起请求都会携带这个cookie</u>，告知服务器当前的会话。  

#### JavaWeb三大作用域对象
- HttpServletRequest -- 请求响应完毕就消失了。
- HttpSession -- 第一次请求被创建，默认30分钟没有被访问就被销毁。此时把浏览器关掉其实是将存储在cookie中的sessionid抛弃，并没有被销毁。
- ServletContext web -- 应用启动时被创建，重启或关闭时被销毁。

程序开发时，为了便于维护，<u>能用小作用域对象就用小作用域对象。</u>

#### JSP九大内置对象
![](https://img.mukewang.com/climg/5c0b7dfc0001e32919201080.jpg)

更新中，未完待续...