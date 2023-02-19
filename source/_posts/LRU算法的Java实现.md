---
title: LRU算法的Java实现
date: 2019-08-14 21:04:55
tags:
- LRU
- 数据结构
- 算法

categories:
- 数据结构
---

### LRU原理

LRU（Least recently used，最近最少使用）算法根据数据的历史访问记录来进行淘汰数据，其核心思想是“如果数据最近被访问过，那么将来被访问的几率也更高”。

<!-- more -->

### 实现方式

要实现LRU算法，有 2 种实现方式。

第一种，是使用Java中现成的API —— LinkedHashMap。它在HashMap的基础增加了按照访问顺序排序的功能，非常适合LRU的实现。

代码如下：

```java
/**
 * @author yhl
 * @date 2019/8/14
 */

public class LRUCacheByAPI extends LinkedHashMap {

    private static final float DEFAULE_LOAD_FACTOR = 0.75f;

    private int capaciticy;

    public LRUCacheByAPI(int capaciticy) {
        super((int) Math.ceil(capaciticy / DEFAULE_LOAD_FACTOR), DEFAULE_LOAD_FACTOR, true);
        this.capaciticy = capaciticy;
    }

    @Override
    protected boolean removeEldestEntry(Map.Entry eldest) {
        return size() > capaciticy;
    }
}

```

第二种，是使用哈希 + 双向链表的方式，自己造轮子实现。用双向链表的原因是删除节点快，用哈希原因是查找快，使得put，get较快。

代码如下：

```java

/**
 * @author yhl
 * @date 2019/8/14
 * 
 * 使用双向链表 + 哈希实现 LRU 算法
 * LRU算法：即最近最少使用算法，当 map 的容量到达规定值之后，再添加元素时就要删掉一个距离现在
 * 最久未使用的一个元素。
 */

public class LRUCache<K, V> {

    /**
     * 链表节点定义
     */
    class Node {
        private K k;
        private V v;
        private Node pre, next;

        public Node() {
        }

        public Node(K k, V v) {
            this.k = k;
            this.v = v;
        }
    }

    /**
     * 双向链表定义
     */
    class DoubleLinkedList {

        //头尾节点，虚节点，不保存数据
        Node head, tail;

        //链表元素数
        private int size;

        public DoubleLinkedList() {
            head = new Node();
            tail = new Node();
            head.next = tail;
            tail.pre = head;
            size = 0;
        }

        public void addFirst(Node node) {
            node.next = head.next;
            node.pre = head;
            head.next.pre = node;
            head.next = node;
            size++;
        }

        public void remove(Node node) {
            node.pre.next = node.next;
            node.next.pre = node.pre;
            size--;
        }

        public Node removeLast() {
            if (size > 0) {
                Node last = tail.pre;
                remove(last);
                return last;
            } else {
                return null;
            }
        }

        public int size() {
            return size;
        }
    }

    private HashMap<K, Node> map;
    private DoubleLinkedList cache;

    /**
     * 最大容量
     */
    private int capaciticy;

    public LRUCache(int capaciticy) {
        this.capaciticy = capaciticy;
        map = new HashMap<>();
        cache = new DoubleLinkedList();
    }

    public V get(K key) {
        if (!map.containsKey(key)) {
            return null;
        }
        V value = map.get(key).v;
        put(key, value);
        return value;
    }

    public void put(K key, V value) {
        Node node = new Node(key, value);
        if (map.containsKey(key)) {
            //如果已经存在这个key
            cache.remove(map.get(key));
            cache.addFirst(node);
            map.put(key, node);
        } else {
            //node中要保存key和value的原因：删除多余node的时候，需要同时删除map中的映射，
            //因此node需要保存key值作为 map.remove() 的参数
            if (capaciticy == cache.size()) {
                Node last = cache.removeLast();
                map.remove(last.k);
            }
            map.put(key, node);
            cache.addFirst(node);
        }
    }
}

```

