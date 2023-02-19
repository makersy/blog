---
title: 【Java】集合-LinkedList详解
date: 2019-07-14 21:48:59
tags:
- Java
- 集合
- LinkedList

categories:
- Java
- 集合
---

### 前言

本篇主要记录Java集合类中LinkedList的用法、结构以及部分实现。

<!-- more -->

### LinkedList简介

`LinkedList`是一个实现了**List接口**和**Deque接口**的**双端链表**。 它实现了的其他接口还有`Cloneable`, `java.io.Serializable`，另外他也继承了`AbstractSequentialList`抽象类。

LinkedList底层的链表结构使它**支持高效的插入和删除操作**，实现了Deque接口，使得LinkedList类也具有队列的特性；

LinkedList**不是线程安全的**，如果想使LinkedList变成线程安全的，可以调用静态类`Collections`类中的`synchronizedList`方法：

```java
List list=Collections.synchronizedList(new LinkedList(...));
```

### 内部结构分析

**LinkedList的内部结构如下图所示：**

![mark](http://qn.haoliny.top/blog/20190714/27K04GGJqstt.png?imageslim)

Node就是链表中的节点。那么LinkedList类中的一个<font color="red">**内部静态私有类Node**</font>就很好理解了：

```java
private static class Node<E> {
    E item;//节点值
    Node<E> next;//后继节点
    Node<E> prev;//前驱节点

    Node(Node<E> prev, E element, Node<E> next) {
        this.item = element;
        this.next = next;
        this.prev = prev;
    }
}
```

这个类就代表双端链表的节点Node。这个类有三个属性，分别是前驱节点，本节点的值，后继结点。

### LinkedList源码分析

下面介绍一些LinkedList类的一些API的实现。

#### 构造方法

**空构造方法：**

```java
public LinkedList() {
}
```

**用已有的集合创建链表的构造方法：**

```java
public LinkedList(Collection<? extends E> c) {
    this();
    addAll(c);
}
```

#### add方法

**add(E e)** 方法：将元素添加到链表尾部

```java
public boolean add(E e) {
    linkLast(e);//这里就只调用了这一个方法
    return true;
}
```

```java
/**
 * 链接。使得 e 作为最后一个元素。
 */
void linkLast(E e) {
    final Node<E> l = last;
    final Node<E> newNode = new Node<>(l, e, null);
    last = newNode;//新建节点
    if (l == null)
        first = newNode;
    else
        l.next = newNode;//指向后继元素也就是指向下一个元素
    size++;
    modCount++;
}
```

**add(int index,E e)**：在指定位置添加元素

```java
public void add(int index, E element) {
    checkPositionIndex(index); //检查索引是否处于[0-size]之间

    if (index == size)//添加在链表尾部
        linkLast(element);
    else//添加在链表中间
        linkBefore(element, node(index));
}
```

<font color="red">linkBefore方法</font>需要给定两个参数，一个<font color="red">插入节点的值</font>，一个<font color="red">指定的node</font>，所以我们又调用了<font color="red">Node(index)去找到index对应的node</font>

**addAll(Collection  c )：将集合插入到链表尾部**

```java
public boolean addAll(Collection<? extends E> c) {
    return addAll(size, c);
}
```

**addAll(int index, Collection c)：** 将集合从指定位置开始插入

```java
public boolean addAll(int index, Collection<? extends E> c) {
    //1:检查index范围是否在size之内
    checkPositionIndex(index);

    //2:toArray()方法把集合的数据存到对象数组中
    Object[] a = c.toArray();
    int numNew = a.length;
    if (numNew == 0)
        return false;

    //3：得到插入位置的前驱节点和后继节点
    Node<E> pred, succ;
    //如果插入位置为尾部，前驱节点为last，后继节点为null
    if (index == size) {
        succ = null;
        pred = last;
    }
    //否则，调用node()方法得到后继节点，再得到前驱节点
    else {
        succ = node(index);
        pred = succ.prev;
    }

    // 4：遍历数据将数据插入
    for (Object o : a) {
        @SuppressWarnings("unchecked") E e = (E) o;
        //创建新节点
        Node<E> newNode = new Node<>(pred, e, null);
        //如果插入位置在链表头部
        if (pred == null)
            first = newNode;
        else
            pred.next = newNode;
        pred = newNode;
    }

    //如果插入位置在尾部，重置last节点
    if (succ == null) {
        last = pred;
    }
    //否则，将插入的链表与先前链表连接起来
    else {
        pred.next = succ;
        succ.prev = pred;
    }

    size += numNew;
    modCount++;
    return true;
}    
```

上面可以看出addAll方法通常包括下面四个步骤：

1. 检查index范围是否在size之内
2. toArray()方法把集合的数据存到对象数组中
3. 得到插入位置的前驱和后继节点
4. 遍历数据，将数据插入到指定位置

**addFirst(E e)：** 将元素添加到链表头部

```java
 public void addFirst(E e) {
     linkFirst(e);
 }
```

```java
private void linkFirst(E e) {
    final Node<E> f = first;
    final Node<E> newNode = new Node<>(null, e, f);//新建节点，以头节点为后继节点
    first = newNode;
    //如果链表为空，last节点也指向该节点
    if (f == null)
        last = newNode;
    //否则，将头节点的前驱指针指向新节点，也就是指向前一个元素
    else
        f.prev = newNode;
    size++;
    modCount++;
}
```

**addLast(E e)：** 将元素添加到链表尾部，与 **add(E e)** 方法一样

```java
public void addLast(E e) {
    linkLast(e);
}
```

#### 根据位置取数据的方法

**get(int index)：** 根据指定索引返回数据

```java
public E get(int index) {
    //检查index范围是否在size之内
    checkElementIndex(index);
    //调用Node(index)去找到index对应的node然后返回它的值
    return node(index).item;
}
```

```java
Node<E> node(int index) {
    // 获取某位置的Node节点
	// 判断索引值是在链表前半部分还是后半部分，前半部分从头遍历
    // 后半部分从尾遍历
    if (index < (size >> 1)) {
        Node<E> x = first;
        for (int i = 0; i < index; i++)
            x = x.next;
        return x;
    } else {
        Node<E> x = last;
        for (int i = size - 1; i > index; i--)
            x = x.prev;
        return x;
    }
}
```

**获取头节点（index=0）数据方法:**

```java
public E getFirst() {
    final Node<E> f = first;
    if (f == null)
        throw new NoSuchElementException();
    return f.item;
}
public E element() {
    return getFirst();
}
public E peek() {
    final Node<E> f = first;
    return (f == null) ? null : f.item;
}

public E peekFirst() {
    final Node<E> f = first;
    return (f == null) ? null : f.item;
}
```

**区别：**
getFirst()，element()，peek()，peekFirst()
这四个获取头结点方法的区别在于**对链表为空时的处理**，是**抛出异常**还是**返回null**，其中**getFirst()** 和**element()** 方法将会在链表为空时，抛出异常。

element()方法的内部就是使用getFirst()实现的。它们会在链表为空时，抛出`NoSuchElementException`异常。

**获取尾节点（index=-1）数据方法:**

```java
 public E getLast() {
     final Node<E> l = last;
     if (l == null)
         throw new NoSuchElementException();
     return l.item;
 }
public E peekLast() {
    final Node<E> l = last;
    return (l == null) ? null : l.item;
}
```

**两者区别：**
**getLast()** 方法在链表为空时，会抛出**NoSuchElementException**，而**peekLast()** 则不会，只是会返回 **null**。

#### 根据对象得到索引的方法

**int indexOf(Object o)：** 从头遍历找

```java
public int indexOf(Object o) {
    int index = 0;
    if (o == null) {
        //从头遍历
        for (Node<E> x = first; x != null; x = x.next) {
            if (x.item == null)
                return index;
            index++;
        }
    } else {
        //从头遍历
        for (Node<E> x = first; x != null; x = x.next) {
            if (o.equals(x.item))
                return index;
            index++;
        }
    }
    return -1;
}
```

**int lastIndexOf(Object o)：** 从尾遍历找

```java
public int lastIndexOf(Object o) {
    int index = size;
    if (o == null) {
        //从尾遍历
        for (Node<E> x = last; x != null; x = x.prev) {
            index--;
            if (x.item == null)
                return index;
        }
    } else {
        //从尾遍历
        for (Node<E> x = last; x != null; x = x.prev) {
            index--;
            if (o.equals(x.item))
                return index;
        }
    }
    return -1;
}
```

#### 检查链表是否包含某对象的方法

**contains(Object o)：** 检查对象o是否存在于链表中

```java
 public boolean contains(Object o) {
     return indexOf(o) != -1;
 }
```

#### 删除方法

**remove()** ,**removeFirst(),pop():** 删除头节点

```Java
public E pop() {
    return removeFirst();
}
public E remove() {
    return removeFirst();
}
public E removeFirst() {
    final Node<E> f = first;
    if (f == null)
        throw new NoSuchElementException();
    return unlinkFirst(f);
}
```

**removeLast()，pollLast():** 删除尾节点

```java
public E removeLast() {
    final Node<E> l = last;
    if (l == null)
        throw new NoSuchElementException();
    return unlinkLast(l);
}
public E pollLast() {
    final Node<E> l = last;
    return (l == null) ? null : unlinkLast(l);
}
```

**区别：** removeLast()在链表为空时将抛出NoSuchElementException，而pollLast()方法返回null。

**remove(Object o):** 删除指定元素

```java
public boolean remove(Object o) {
    //如果删除对象为null
    if (o == null) {
        //从头开始遍历
        for (Node<E> x = first; x != null; x = x.next) {
            //找到元素
            if (x.item == null) {
                //从链表中移除找到的元素
                unlink(x);
                return true;
            }
        }
    } else {
        //从头开始遍历
        for (Node<E> x = first; x != null; x = x.next) {
            //找到元素
            if (o.equals(x.item)) {
                //从链表中移除找到的元素
                unlink(x);
                return true;
            }
        }
    }
    return false;
}
```

当删除指定对象时，只需调用remove(Object o)即可，不过该方法一次只会删除一个匹配的对象，如果删除了匹配对象，返回true，否则false。

`unlink(Node<E> x) `方法：

```java
E unlink(Node<E> x) {
    // assert x != null;
    final E element = x.item;
    final Node<E> next = x.next;//得到后继节点
    final Node<E> prev = x.prev;//得到前驱节点

    //删除前驱指针
    if (prev == null) {
        first = next;//如果删除的节点是头节点,令头节点指向该节点的后继节点
    } else {
        prev.next = next;//将前驱节点的后继节点指向后继节点
        x.prev = null;
    }

    //删除后继指针
    if (next == null) {
        last = prev;//如果删除的节点是尾节点,令尾节点指向该节点的前驱节点
    } else {
        next.prev = prev;
        x.next = null;
    }

    x.item = null;
    size--;
    modCount++;
    return element;
}
```

**remove(int index)**：删除指定位置的元素

```java
public E remove(int index) {
    //检查index范围
    checkElementIndex(index);
    //将节点删除
    return unlink(node(index));
}
```

### 一些API

| 返回值            |                      方法参数及作用描述                      |
| ----------------- | :----------------------------------------------------------: |
| `boolean`         |         `add(E e)`  将指定的元素追加到此列表的末尾。         |
| `void`            | `add(int index, E element)`  在此列表中的指定位置插入指定的元素。 |
| `boolean`         | `addAll(Collection<? extends E> c)`  按照指定集合的迭代器返回的顺序将指定集合中的所有元素追加到此列表的末尾。 |
| `boolean`         | `addAll(int index,  Collection<? extends E> c)`  将指定集合中的所有元素插入到此列表中，从指定的位置开始。 |
| `void`            |        `addFirst(E e)`  在该列表开头插入指定的元素。         |
| `void`            |       `addLast(E e)`  将指定的元素追加到此列表的末尾。       |
| `void`            |              `clear()`  从列表中删除所有元素。               |
| `Object`          |           `clone()`  返回此 `LinkedList`的浅版本。           |
| `boolean`         | `contains(Object o)`  如果此列表包含指定的元素，则返回 `true` 。 |
| `Iterator<E>`     | `descendingIterator()`   以相反的顺序返回此deque中的元素的迭代器。 |
| `E`               |     `element()`  检索但不删除此列表的头（第一个元素）。      |
| `E`               |       `get(int index)`   返回此列表中指定位置的元素。        |
| `E`               |           `getFirst()`  返回此列表中的第一个元素。           |
| `E`               |          `getLast()`  返回此列表中的最后一个元素。           |
| `int`             | `indexOf(Object o)`  返回此列表中指定元素的第一次出现的索引，如果此列表不包含元素，则返回-1。 |
| `int`             | `lastIndexOf(Object o)`  返回此列表中指定元素的最后一次出现的索引，如果此列表不包含元素，则返回-1。 |
| `ListIterator<E>` | `listIterator(int index)`   从列表中的指定位置开始，返回此列表中元素的列表迭代器（按适当的顺序）。 |
| `boolean`         | `offer(E e)`  将指定的元素添加为此列表的尾部（最后一个元素）。 |
| `boolean`         |      `offerFirst(E e)`  在此列表的前面插入指定的元素。       |
| `boolean`         |       `offerLast(E e)`  在该列表的末尾插入指定的元素。       |
| `E`               |       `peek()`  检索但不删除此列表的头（第一个元素）。       |
| `E`               | `peekFirst()`   检索但不删除此列表的第一个元素，如果此列表为空，则返回 `null` 。 |
| `E`               | `peekLast()`  检索但不删除此列表的最后一个元素，如果此列表为空，则返回 `null` 。 |
| `E`               |        `poll()`  检索并删除此列表的头（第一个元素）。        |
| `E`               | `pollFirst()`   检索并删除此列表的第一个元素，如果此列表为空，则返回 `null` 。 |
| `E`               | `pollLast()`  检索并删除此列表的最后一个元素，如果此列表为空，则返回 `null` 。 |
| `E`               |         `pop()`  从此列表表示的堆栈中弹出一个元素。          |
| `void`            |       `push(E e)`  将元素推送到由此列表表示的堆栈上。        |
| `E`               |       `remove()`  检索并删除此列表的头（第一个元素）。       |
| `E`               |      `remove(int index)`   删除该列表中指定位置的元素。      |
| `boolean`         | `remove(Object o)`  从列表中删除指定元素的第一个出现（如果存在）。 |
| `E`               |      `removeFirst()`   从此列表中删除并返回第一个元素。      |
| `boolean`         | `removeFirstOccurrence(Object o)`  删除此列表中指定元素的第一个出现（从头到尾遍历列表时）。 |
| `E`               |     `removeLast()`   从此列表中删除并返回最后一个元素。      |
| `boolean`         | `removeLastOccurrence(Object o)`  删除此列表中指定元素的最后一次出现（从头到尾遍历列表时）。 |
| `E`               | `set(int index, E element)`  用指定的元素替换此列表中指定位置的元素。 |
| `int`             |               `size()`  返回此列表中的元素数。               |
| `Spliterator<E>`  | `spliterator()`   在此列表中的元素上创建*late-binding*和*故障快速* [`Spliterator`](../../java/util/Spliterator.html) 。 |
| `Object[]`        | `toArray()`  以正确的顺序（从第一个到最后一个元素）返回一个包含此列表中所有元素的数组。 |
| `<T> T[]`         | `toArray(T[] a)`   以正确的顺序返回一个包含此列表中所有元素的数组（从第一个到最后一个元素）;  返回的数组的运行时类型是指定数组的运行时类型。 |

### 最后

本文阐述了Java集合类LinkedList的内部结构以及部分源码实现，并总结了该集合的一些常用方法。