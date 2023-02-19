---
title: Java8新特性-Stream
date: 2019-07-17 17:14:01
tags:
- Java
- Stream

categories:
- 编程语言
- Java
---

### 前言

<!-- more -->
Stream API 旨在让编码更高效率、干净、简洁。

### 从迭代器到Stream操作

当使用 `Stream` 时，我们一般会通过三个阶段建立一个流水线：

1. 创建一个 `Stream`；
2. 进行一个或多个中间操作;
3. 使用终止操作产生一个结果,`Stream` 就不会再被使用了。

**案例1：统计 List 中的单词长度大于6的个数**

```java
/**
* 案例1：统计 List 中的单词长度大于6的个数
*/
ArrayList<String> wordsList = new ArrayList<String>();
wordsList.add("Charles");
wordsList.add("Vincent");
wordsList.add("William");
wordsList.add("Joseph");
wordsList.add("Henry");
wordsList.add("Bill");
wordsList.add("Joan");
wordsList.add("Linda");
int count = 0;
```

Java8之前我们通常用迭代方法来完成上面的需求：

```java
//迭代（Java8之前的常用方法）
//迭代不好的地方：1. 代码多；2 很难被并行运算。
for (String word : wordsList) {
    if (word.length() > 6) {
        count++;
    }
}
System.out.println(count);//3
```

Java8之后我们使用 `Stream` 一行代码就能解决了，而且可以瞬间转换为并行执行的效果：

```java
//Stream
//将stream()改为parallelStream()就可以瞬间将代码编程并行执行的效果
long count2=wordsList.stream()
    .filter(w->w.length()>6)
    .count();
long count3=wordsList.parallelStream()
    .filter(w->w.length()>6)
    .count();
System.out.println(count2);
System.out.println(count3);
```

**案例2：给定一个`int`数组求和，返回一个 long**

一般我们是这么写的，
```java
public long sum(Integer... numbers){

    long res = 0L;

    if (numbers == null || numbers.length == 0) {
        return 0L;
    }
    for (int temp : numbers) {
        res += temp;
    }
    return res;

}
```

在Java 8 之后可以这么写：


```java
public long sum(Integer... numbers){

    if( numbers==null || numbers.length==0 ) return 0L;
    else {
        return Arrays.stream(numbers)
            .filter(Objects::nonNull)
            .map(Integer::longValue)
            .reduce(0L, (a, b) -> (a + b));
    }

}
```

### `distinct()`

去除 List 中重复的 String

```java
List<String> list = list.stream()
    .distinct()
    .collect(Collectors.toList());
```

### `map`

map 方法用于映射每个元素到对应的结果，以下代码片段使用 map 输出了元素对应的平方数：

```java
List<Integer> numbers = Arrays.asList(3, 2, 2, 3, 7, 3, 5);
// 获取 List 中每个元素对应的平方数并去重
List<Integer> squaresList = numbers.stream().map( i -> i*i).distinct().collect(Collectors.toList());
System.out.println(squaresList.toString());//[9, 4, 49, 25]
```

### `filter`

filter 对原始 Stream 进行某项测试，通过测试的元素被留下来生成一个新 Stream。

筛选偶数：

```java
Integer[] sixNums = {1, 2, 3, 4, 5, 6};
Integer[] evens =
Stream.of(sixNums).filter(n -> n%2 == 0).toArray(Integer[]::new);
```

### `reduce`

这个方法的主要作用是把 Stream 元素组合起来。它提供一个起始值（种子），然后依照运算规则（BinaryOperator），和前面 Stream 的第一个、第二个、第 n 个元素组合。从这个意义上说，字符串拼接、数值的 sum、min、max、average 都是特殊的 reduce。例如 Stream 的 sum 就相当于

`Integer sum = integers.reduce(0, (a, b) -> a+b); `或

`Integer sum = integers.reduce(0, Integer::sum);`

也有没有起始值的情况，这时会把 Stream 的前面两个元素组合起来，返回的是 Optional。

### `limit/skip`

limit 返回 Stream 的前面 n 个元素；skip 则是扔掉前 n 个元素（它是由一个叫 `subStream` 的方法改名而来）。

### `sorted`

对 Stream 的排序通过 sorted 进行，它比数组的排序更强之处在于你可以首先对 Stream 进行各类 map、filter、limit、skip 甚至 distinct 来减少元素数量后，再排序，这能帮助程序明显缩短执行时间。

### 总结

Stream东西很多，大多数时候还是用到了再去查阅API，边写边学。