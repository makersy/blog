---
title: Java大数基本用法
date: 2018-09-05 15:44:16
tags:  

- Java

categories:  

- 编程语言  
- Java  

---
最近学Java有接触到大数运算，感觉比用c++自己写个算法方便太多，在此记录下代码。
<!-- more -->
java中用于操作大数的类主要有两个，一个是BigInteger，代表大整数类，用于对大整数进行操作；另一个是BigDecimal，代表高精度类，用于对比较大或精度比较高的浮点型数据进行操作。两个比较像。
## 基本用法
### 1、新建一个值为123的大整数对象 
```java
BigInteger a=new BigInteger(“123”); //第一种，参数是字符串 
BigInteger a=BigInteger.valueOf(123); //第二种，参数可以是int、long
```
### 2、大整数的四则运算 
```java
a. add(b); //a,b均为BigInteger类型，加法 
a.subtract(b); //减 法 
a.divide(b); //除法 
a.multiply(b); //乘法
```
### 3、大整数比较大小 
```java
a.equals(b); //如果a、b相等返回true否则返回false 
a.compareTo(b); //a小于b返回-1，等于返回0，大于返回1
```
### 4、常用方法 
```java
a.mod(b); //求余 
a.gcd(b); //求最大公约数 
a.max(b); //求最大值 
a.min(b); //求最小值  
```
## 例子

[HDU1002 a+b](http://acm.hdu.edu.cn/showproblem.php?pid=1002)

```java
import java.util.*;
import java.math.*;
public class Main {
    public static void main(String[] args) {
    	Scanner sc = new Scanner(System.in);
    	int t = sc.nextInt();
    	BigInteger a, b, c;
    	for( int i=1; i<=t; i++ ) {
    		System.out.println("Case " + i + ":");
    		a = sc.nextBigInteger();
    		b = sc.nextBigInteger();
    		System.out.println(a + " + " + b + " = " + a.add(b));
    		if( i!=t ) {
    			System.out.println();
    		}
    	}
    }
     
}

```
