---
title: Java连接高版本mysql数据库(8.0)的坑
date: 2018-09-22 16:21:56
tags: 
- Java
- mysql  

categories:  
- 编程语言
- Java

---
今天在写java连接mysql数据库时，遇到了无法连接的问题。
<!-- more -->
报错信息如下:  

Loading class 'com.mysql.jdbc.Driver'. This is deprecated. The new driver class is `com.mysql.cj.jdbc.Driver'. The driver is automatically registered via the SPI and manual loading of the driver class is generally unnecessary.

Sat Sep 22 16:28:36 GMT+08:00 2018 WARN: Establishing SSL connection without server's identity verification is not recommended. According to MySQL 5.5.45+, 5.6.26+ and 5.7.6+ requirements SSL connection must be established by default if explicit option isn't set. For compliance with existing applications not using SSL the verifyServerCertificate property is set to 'false'. You need either to explicitly disable SSL by setting useSSL=false, or set useSSL=true and provide truststore for server certificate verification.

java.sql.SQLException: The server time zone value '???ú±ê×??±??' is unrecognized or represents more than one time zone. You must configure either the server or JDBC driver (via the serverTimezone configuration property) to use a more specifc time zone value if you want to utilize time zone support.

这三段意思是说：
- 驱动不再是之前的com.mysql.jdbc.Driver而是'com.mysql.cj.jdbc.Driver'；
- mysql8.0不需要使用ssl连接，因此需要设置手动设置useSSL=false；
- mysql返回的时间与实际不一样，需要设置在jdbc连接的url后面加上serverTimezone=GMT(即时区)。  

因此应该这么写：
```java
	Class.forName("com.mysql.cj.jdbc.Driver");
//	Class.forName("com.mysql.jdbc.Driver");
	conn = DriverManager.getConnection("jdbc:mysql://localhost/EXAMPLE?useSSL=false&serverTimezone=GMT","root","password");
//	conn = DriverManager.getConnection("jdbc:mysql://localhost/EXAMPLE","root","password");
```

注释里是之前的写法。