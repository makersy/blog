---
title: Java的注解
date: 2019-07-06 19:38:52
tags:
- Java
- 注解

categories:
- 编程语言
- Java
---

### 介绍

注解（Annotation ），有标记、注释的意思，也被称为元数据，他为我们在代码中添加信息提供了一种形式化的方法，使我们可以在稍后某个时刻非常方便地使用这些数据。在 Java 中注解是一个很重要的知识点。

Java 注解是从 Java SE5 引入的。他可以提供用来完整描述程序所需的信息，为程序的元素（类、方法、成员变量）加上更直观更明了的说明，这些说明信息是与程序的业务逻辑无关，并且是供指定的工具或框架使用的。
Annontation像一种修饰符一样，应用于包、类型、构造方法、方法、成员变量、参数及本地变量的声明语句中。

<!-- more -->



### 标准注解

注解的语法比较简单，除了@符号的使用之外，基本与Java固有语法无异。JDK5内置了三种，定义在java.lang中的注解：

- `@Override`，表示当前方法定义将覆盖超类中方法。如果将这个单词拼写错误，或者方法签名对应不上被覆盖的方法，那么编译器就会发出错误提示。
- `@Deprecated`，如果使用了注解为这个单词的元素，那么编译器就会发出警告。
- `@SuppressWarnings`，关闭不当的编译器警告信息。

### 元注解

元注解专职负责注解其他注解，Java5.0定义了4个标准的meta-annotation类型，它们被用来提供对其它 annotation类型作说明。

**@Target：用于描述该注解的适用范围：**

```
取值(ElementType)有：
　　　　1.CONSTRUCTOR:用于描述构造器
　　　　2.FIELD:用于描述域（包括enum实例）
　　　　3.LOCAL_VARIABLE:用于描述局部变量
　　　　4.METHOD:用于描述方法
　　　　5.PACKAGE:用于描述包
　　　　6.PARAMETER:用于描述参数
　　　　7.TYPE:用于描述类、接口(包括注解类型) 或enum声明
```



**@Retention：表示需要在什么级别保存该注解信息 (生命周期)**

某些Annotation仅出现在源代码中，而被编译器丢弃；而另一些却被编译在class文件中；编译在class文件中的Annotation可能会被虚拟机忽略，而另一些在class被装载时将被读取（请注意并不影响class的执行，因为Annotation与class在使用上是被分离的）。使用这个meta-Annotation可以对 Annotation的“生命周期”限制。

```
取值（RetentionPoicy）有：
　　　　1.SOURCE:在源文件中有效（即源文件保留），会被编译器丢弃
　　　　2.CLASS:在class文件中有效（即class保留），但会被VM丢弃
　　　　3.RUNTIME:在运行时有效（即运行时保留），可以通过反射机制读            		取注解的信息
```

**@Documented：包含在Javadoc中**

描述其它类型的annotation应该被作为被标注的程序成员的公共API，因此可以被例如javadoc此类的工具文档化

**@Inherited：允许子类继承父类中的注解**

如果一个超类被 @Inherited 注解过的注解进行注解的话，那么如果它的子类没有被任何注解应用的话，那么这个子类就继承了超类的注解。

注意：@Inherited annotation类型是被标注过的class的子类所继承。类并不从它所实现的接口继承annotation，方法并不从它所重载的方法继承annotation。

 当@Inherited annotation类型标注的annotation的Retention是RetentionPolicy.RUNTIME，则反射API增强了这种继承性。如果我们使用java.lang.reflect去查询一个@Inherited annotation类型的annotation时，反射代码检查将展开工作：检查class和其父类，直到发现指定的annotation类型被发现，或者到达类继承结构的顶层。

### 自定义注解

```java
定义注解格式：
　　public @interface 注解名 {定义体}
```

关于Annotation类型里面的参数该怎么设定:
第一,只能用public或默认(default)这两个访问权修饰.例如,String value();这里把方法设为defaul默认类型；　 　
第二,参数成员只能用基本类型byte,short,char,int,long,float,double,boolean八种基本数据类型和 String,Enum,Class,annotations等数据类型,以及这一些类型的数组.例如,String value();这里的参数成员就为String。

### 注解的使用

刚接触注解时，我想很多人都会有一个疑问，这个东西有什么用呢？官方文档给了我们答案：

> 注解是一系列元数据，它提供数据用来解释程序代码，但是注解并非是所解释的代码本身的一部分。注解对于代码的运行效果没有直接影响。
>
> 注解有许多用处，主要如下：
>
> - 提供信息给编译器： 编译器可以利用注解来探测错误和警告信息
> - 编译阶段时的处理： 软件工具可以用来利用注解信息来生成代码、Html文档或者做其它相应处理。
> - 运行时的处理： 某些注解可以在程序运行的时候接受代码的提取
> 值得注意的是，注解不是代码本身的一部分。

在Spring中大量使用了注解，比如常用的@Controller、@Service等，这些注解大大简化了方法的配置工作。

在此我用上述作用的第一个：提供信息给编译器，来做一个示范。

假设我在一个类里面定义了很多方法，我需要检查每一个方法是否有异常，并将其一一打印，那么我就可以在需要检查的方法上加一个注解，然后用反射的方法来调用方法并获取其注解，判断并打印之。

首先是注解类：

```java
/**
 * Created by makersy on 2019
 */

@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface CheckException {
    public String description() default "no description";
}
```

然后是方法类：

```java
/**
 * Created by makersy on 2019
 */

public class SomeMethods {

    @CheckException(description = "减法")
    public static void method1() {
        System.out.println("1 - 1 = " + (1 - 1));
    }

    @CheckException(description = "加法")
    public static void method3() {
        System.out.println("4 + 3 = " + (4 + 3));
    }

    @CheckException(description = "乘法")
    public static void method2() {
        System.out.println("2 * 3 = " + (2 * 3));
    }

    @CheckException(description = "除法")
    public static void method4() {
        System.out.println("5 / 0 = " + (5 / 0));
    }

//    @CheckException
//    public static void method5() {
//        System.out.println("1 - 1 = " + (1 - 1));
//    }

    //没有注解的类，在主方法中不会被调用到
    public static void method6() {
        System.out.println("no annotation");
    }
    
}

```

最后是测试类：

```java

/**
 * Created by makersy on 2019
 */

public class TestTool {

    public static void main(String[] args) {
        SomeMethods someMethods = new SomeMethods();
        int cnt = 0;  //异常计数
        for (Method method : SomeMethods.class.getDeclaredMethods()) {
            if (method.isAnnotationPresent(CheckException.class)) {  //判断注解是否为我们定义的那个
                CheckException anno = method.getAnnotation(CheckException.class);  //获取CheckException注解
                System.out.println(anno.description() + ":");  //打印方法注解的描述
                try {
                    method.invoke(someMethods, null);  //调用方法
                } catch (IllegalAccessException | InvocationTargetException e) {
                    System.out.println(method.getName() + " has error. Caused By: " + e.getCause().getClass().getSimpleName());
                    System.out.println(e.getCause().getMessage());
                    cnt++;  //异常计数+1
                }
            }
        }
        System.out.println(someMethods.getClass().getSimpleName() + " has " + cnt + " error!");
    }
}

```

下面是结果展示：

![mark](http://qn.haoliny.top/blog/20190706/IqirUJlo9EMX.jpg?imageslim)