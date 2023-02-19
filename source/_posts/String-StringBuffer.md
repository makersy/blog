---
title: String&StringBuffer
date: 2018-09-06 20:58:15
tags:  
- Java
categories:  
- 编程语言
- Java
---



## String

### 介绍

<!-- more -->

String是Java中很常见的类，是一个final修饰的**不可变**的数组，用来存放字符的容器。不可变是什么意思呢，意思是被赋值后就不能被改变了，如果再进行修改的话实质上是创建一个新对象，并将引用指向新对象，原来的对象被当做垃圾回收掉了。这是效率很低的。

****

### 用法

**1.求字符串某一位置字符**

```java
char charAt(int index)//返回字符串中指定位置的字符；注意字符串中第一个字符索引是0，最后一个是length()-1。
```

```java
String str = new String("asdfzxc");
```



**2获取角标**

```java
Int indexOf(char c) 
```

例如：

```java
String s=”Java”;    Int a=s.indexOf(a); 
```



**3判断**

- **字符串是否包含某个字符串**

```java
boolean contains(str)//判断源字符串是否包含str字符串并返回boolean值 
```

例如：String str=”My love Java”;

Boolean b=str.contains(love);

结果：true

- **字符串是否有内容**

```java
boolean isEmpty()
```

例如：booleanb=str.isEmpty();

- **字符串是否以指定内容开始**

```java
 boolean startsWith(str)
```

例如：booleanb=str.startsWith(“My”);

- **字符串是否以指定内容结束**

```java
boolean endsWith(str);
```
用法如上

- **判断内容是否相同**

```java
boolean equals(str)      //String类重写了Object类中的equals方法，该方法用于判断字符串内容是否相同而非判断地址
```
例如:

```java
String str1=”Java”;

String str2=”love”;

boolean s=str1.equals(str2);

```

- **判断内容是否相同，并忽略大小写**

```java
Boolean equalsIngoreCase(str)
```
用法同上

**4提取子串**
用String类的substring方法可以提取字符串中的子串，该方法有两种常用参数:

- public String substring(int beginIndex)	//该方法从beginIndex位置起，从当前字符串中取出剩余的字符作为一个新的字符串返回。
- public String substring(int beginIndex, int endIndex)	//该方法从beginIndex位置起，从当前字符串中取出到endIndex-1位置的字符作为一个新的字符串返回

```java
1 String str1 = new String("asdfzxc");
2 String str2 = str1.substring(2);//str2 = "dfzxc"
3 String str3 = str1.substring(2,5);//str3 = "dfz"
```

**5字符串比较**
- public int compareTo(StringanotherString)		//该方法是对字符串内容按字典顺序进行大小比较，通过返回的整数值指明当前字符串与参数字符串的大小关系。若当前对象比参数大则返回正整数，反之返回负整数，相等返回0。
- public int compareToIgnore(StringanotherString)	//与compareTo方法相似，但忽略大小写。
- public boolean equals(ObjectanotherObject)	//比较当前字符串和参数字符串，在两个字符串相等的时候返回true，否则返回false。

**6字符串中字符的大小写转换**
- public String toLowerCase()	//返回将当前字符串中所有字符转换成小写后的新串
- public String toUpperCase()	//返回将当前字符串中所有字符转换成大写后的新串

```java
1 String str = new String("asDF");
2 String str1 = str.toLowerCase();//str1 = "asdf"
3 String str2 = str.toUpperCase();//str2 = "ASDF"
```

**7字符串中字符的替换**

- public String replace(char oldChar, charnewChar)	//用字符newChar替换当前字符串中所有的oldChar字符，并返回一个新的字符串。
- public String replaceFirst(String regex,String replacement)		//该方法用字符replacement的内容替换当前字符串中遇到的第一个和字符串regex相匹配的子串，应将新的字符串返回。
- public String replaceAll(String regex,String replacement)             //该方法用字符replacement的内容替换当前字符串中遇到的所有和字符串regex相匹配的子串，应将新的字符串返回。

```java
1 String str = "asdzxcasd";
2 String str1 = str.replace('a','g');//str1 = "gsdzxcgsd"
3 String str2 = str.replace("asd","fgh");//str2 = "fghzxcfgh"
4 String str3 = str.replaceFirst("asd","fgh");//str3 = "fghzxcasd"
5 String str4 = str.replaceAll("asd","fgh");//str4 = "fghzxcfgh"
字符串分隔
String[] split(String str)//将str作为分隔符进行字符串分解，分解后的字字符串在字符串数组中返回。
1 String str = "asd!qwe|zxc#";
2 String[] str1 = str.split("!|#");//str1[0] = "asd";str1[1] = "qwe";str1[2] = "zxc";
```

**8字符串与基本类型的转换**

字符串转换为基本类型java.lang包中有Byte、Short、Integer、Float、Double类的调用方法:

- public static byte parseByte(String s)

- public static short parseShort(String s)

- public static short parseInt(String s)

- public static long parseLong(String s)

- public static float parseFloat(String s)

- public static double parseDouble(String s)

字符串基本类型时，如int short dobule字符串中的数据一定要是数字，否则会出现异常。

例如：

```java
1 int n = Integer.parseInt("12");
2 float f = Float.parseFloat("12.34");
3 double d = Double.parseDouble("1.124");
```

**9基本类型转换为字符串类型**

String类中提供了String valueOf()放法，用作基本类型转换为字符串类型。

- static String valueOf(char data[])
- static String valueOf(char data[], intoffset, int count)
- static String valueOf(boolean b)
- static String valueOf(char c)
- static String valueOf(int i)
- static String valueOf(long l)
- static String valueOf(float f)
- static String valueOf(double d)

例如：

```java
1 String s1 = String.valueOf(12);
2 String s1 = String.valueOf(12.34);
```

**10和数组有关的方法**

| 返回类型 | 方法名        | 作用                         |
| :------- | :---------- | :---------------------------- |
| byte[]   | getBytes()    | 将一个字符串转换成字节数组   |
| String[] | split(String) | 将一个字符串按照指定内容劈开 |
| char[]   | toCharArray() | 将一个字符串转换成字符数组   |

**11判断是否为空**

`public boolean isEmpty()`

**当且仅当** length()为 0 时返回 true。

## String Buffer

### 常用方法

- public StringBuffer append(boolean b)

  该方法的作用是追加内容到当前StringBuffer对象的末尾，类似于字符串的连接。调用该方法以后，StringBuffer对象的内容也发生改变，

- public StringBuffer deleteCharAt(int index)

  该方法的作用是删除指定位置的字符，然后将剩余的内容形成新的字符串。

- public StringBuffer deleteCharAt(int index)
- 该方法的作用是删除指定位置的字符，然后将剩余的内容形成新的字符串。

- public StringBuffer insert(int offset, boolean b)

  该方法的作用是在StringBuffer对象中插入内容，然后形成新的字符串。

- public StringBuffer reverse()

  该方法的作用是将StringBuffer对象中的内容反转，然后形成新的字符串。

- public void setCharAt(int index, char ch)

  该方法的作用是修改对象中索引值为index位置的字符为新的字符ch。