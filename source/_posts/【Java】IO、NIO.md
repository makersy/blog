---
title: 【Java】浅谈IO与NIO
date: 2019-07-13 21:28:16
tags:
- Java
- IO

categories:
- Java
- IO
---

### 前言

Java IO，即Java中的输入输出，可以用来数据的写入和读出。在整个Java.io包中最重要的就是5个类和一个接口。5个类指的是File、OutputStream、InputStream、Writer、Reader；一个接口指的是Serializable。本文主要总结IO流、NIO相关知识。

<!-- more -->

### IO流的分类

1. 按照**流的流向**分，可以分为输入流和输出流
   - 输入流： 只能从中读取数据，而不能向其写入数据。
   - 输出流：只能向其写入数据，而不能向其读取数据。


2. 按照**操作单元**划分，可以划分为字节流和字符流

   字节流和字符流的用法几乎完成全一样，区别在于字节流和字符流所操作的数据单元不同，字节流操作的单元是数据单元是8位的字节，字符流操作的是数据单元为16位的字符。

   字节流主要是由InputStream和outPutStream作为基类，而字符流则主要有Reader和Writer作为基类。


3. 按照**流的角色**，划分为节点流和处理流。

   可以从/向一个特定的IO设备（如磁盘，网络）读/写数据的流，称为节点流。节点流也被称为低级流。图15.3显示了节点流的示意图。 

**按操作单元及方式分类**如下图：

![mark](https://imgconvert.csdnimg.cn/aHR0cDovL3FuLm1ha2Vyc3kudG9wL2Jsb2cvMjAxOTA3MTMvRUZNVVc5WVlKVnNELnBuZw)

java Io流共涉及40多个类，这些类看上去很杂乱，但实际上很有规则，而且彼此之间存在非常紧密的联系， Java Io流的40多个类都是从如下4个抽象类基类中派生出来的。

- **InputStream/Reader**: 所有的输入流的基类，前者是字节输入流，后者是字符输入流。
- **OutputStream/Writer**: 所有输出流的基类，前者是字节输出流，后者是字符输出流。

关于IO详细的原理及api，详见[java IO体系的学习总结](https://blog.csdn.net/nightcurtis/article/details/51324105)。

### NIO 

#### NIO简介

Java NIO 是 java 1.4, 之后新出的一套IO接口NIO中的N可以理解为Non-blocking，不单纯是New。

传统的IO操作**面向数据流**，意味着每次从流中读一个或多个字节，直至完成，数据没有被缓存在任何地方。

NIO操作**面向缓冲区**，数据从**Channel**读取到**Buffer**缓冲区，随后在Buffer中处理数据。

<font color="red">BIO中的accept是没有客户端连接时阻塞，NIO的accept是没有客户端连接时立即返回。</font>

1. **NIO的特性/NIO与IO区别:**
   - IO是面向流的，NIO是面向缓冲区的；
   - IO流是阻塞的，NIO流是不阻塞的;
   - NIO有选择器，而IO没有。
   
2. **读数据和写数据方式:**
   - 从通道进行数据读取 ：创建一个缓冲区，然后请求通道读取数据。
   - 从通道进行数据写入 ：创建一个缓冲区，填充数据，并要求通道写入数据。
   
3. **NIO核心组件简单介绍**
  
   NIO的三个重要组件：Buffer、Channel、Selector。
   
   Buffer是用于容纳数据的缓冲区，Channel是与IO设备之间的连接，类似于流。
   
   数据可以从Channel读到Buffer中，也可以从Buffer 写到Channel中。
   
   Selector是Channel的多路复用器。

#### Buffer(缓冲区)

1. Java NIO Buffers用于和NIO Channel交互。 我们从Channel中读取数据到buffers里，从Buffer把数据写入到Channels；
   - Buffer本质上就是一块内存区；
   - 一个Buffer有三个属性是必须掌握的，分别是：capacity容量、position位置、limit限制。
     - capacity：代表buffer的总容量；
     - position：写模式下，代表当前第一个可插入数据的位置；读模式下，代表第一个可以读取的数据；
     - limit：写模式下，代表最多能往buffer中写数据的数量，即为capacity；读模式下，代表最多可从buffer中读取多少数据，此时limit将变为写模式下的position值；
     - mark：代表一个特定的position位置，调用reset方法后可以继续从此位置处理数据。
   
3. **Buffer的常见方法**

   - Buffer clear()：将所有属性重置
   - Buffer flip()：从写模式切换到读模式
   - Buffer rewind()
   - Buffer position(int newPosition)
   - mark()：记录当前position位置
   - get()：获取下一个字节

4. **Buffer的使用方式/方法介绍:**

   - 分配缓冲区（Allocating a Buffer）:

	   ```java
	   ByteBuffer buf = ByteBuffer.allocate(28);//以ByteBuffer为例子
	   ```

   - 写入数据到缓冲区（Writing Data to a Buffer）

    **写数据到Buffer有两种方法：**

     1.从Channel中写数据到Buffer

   ```java
     int bytesRead = inChannel.read(buf); //read into buffer.
   ```

     2.通过put写数据：

   ```java
     buf.put(127);
   ```

5. **核心缓冲区介绍**

   覆盖了Java IO发送的基本的数据类型：
   
   - ByteBuffer
   - CharBuffer
   - ShortBuffer
   - IntBuffer
   - FloatBuffer
   - DoubleBuffer
   - LongBuffer

#### Channel(通道)

1. **Channel（通道）介绍**
  
   通常来说NIO中的所有IO都是从 Channel（通道） 开始的，它与IO设备的连接，与stream是平级的概念。
   - **从通道进行数据读取** ：创建一个缓冲区，然后请求通道读取数据。
   - **从通道进行数据写入** ：创建一个缓冲区，填充数据，并要求通道写入数据。
   
   **流与通道的区别**
   
   1、流是单向的，通道是双向的，可读可写。
   
   2、流读写是阻塞的，通道可以异步读写。
   
   3、流中的数据可以选择性的先读到缓存中，通道的数据总是要先读到一个缓存中，或从缓存中写入
   
2. **Channel接口的主要实现类**

   - FileChannel：用于读取、写入、映射和操作文件的通道

   - DatagramChannel：通过UDP读写网络中的数据通道

   - SocketChannel：通过TCP读写网络中的数据

   - ServerSocketChannel：监听新进来的TCP连接，对每一个新进来的连接都会创建一个SocketChannel

	注意，FileChannel不能设置为非阻塞模式。

3. **获取通道的方式**

   一种方式是对支持通道的对象调用getChannel()方法。支持通道的类如下：

   - FileInputStream
   - FileOutputStream
   - RandomAccessFile
   - DatagramSocket
   - Socket
   - ServerSocket

   获取通道的其他方式是使用Files类的静态方法newByteChannel()获取字节通道。或者通过通道的静态方法open()打开并返回指定通道。

7. **Scatter / Gather**

   - Scatter: 从一个Channel读取的信息分散到N个缓冲区中(Buufer)。
   - Gather: 将N个Buffer里面内容按照顺序发送到一个Channel。

8. **通道之间的数据传输**
   - 在Java NIO中如果一个channel是FileChannel类型的，那么他可以直接把数据传输到另一个channel。
   - transferFrom() :transferFrom方法把数据从通道源传输到FileChannel
   - transferTo() :transferTo方法把FileChannel数据传输到另一个channel
   
6. **FileChannel与文件锁**

   在通道中我们可以对文件或者部分文件进行上锁。上锁和我们了解的线程锁差不多，都是为了保证数据的一致性。在文件通道FileChannel中可以对文件进行上锁，通过FileLock可以对文件进行锁的释放。

   文件加锁是建立在文件通道（FileChannel）之上的，套接字通道（SockeChannel）不考虑文件加锁，因为它是不共享的。它对文件加锁有两种方式：

   1. lock

   2. tryLock

   两种加锁方式默认都是对整个文件加锁，如果自己配置的话就可以控制加锁的文件范围：position是加锁的开始位置，size是加锁长度，shared是用于控制该锁是共享的还是独占的。 

   lock是阻塞式的，当有进程对锁进行读取时会等待锁的释放，在此期间它会一直等待；tryLock是非阻塞式的，它尝试获得锁，如果这个锁不能获得，那么它会立即返回。 

   release可以释放锁。

   在一个进程中在锁没有释放之前是无法再次获得锁的。

   在java的NIO中，通道包下面有一个FileLock类，它主要是对文件锁工具的一个描述。在上一小节中对文件的锁获取其实是FileChannel获取的（lock与trylock是FileChannel的方法），它们返回一个FileLock对象。这个类的核心方法有如下这些： 
    ```java
       boolean isShared() :判断锁是否为共享类型 

       abstract boolean isValid() ：判断锁是否有效 

       boolean overlaps()：判断此锁定是否与给定的锁定区域重叠 

       long position()：返回文件内锁定区域中第一个字节的位置。 

       abstract void release() ：释放锁 

       long size() ：返回锁定区域的大小，以字节为单位
    ```
   在文件锁中有3种方式可以释放文件锁：1、锁类释放锁，调用FileLock的release方法； 2、通道类关闭通道，调用FileChannel的close方法；3、jvm虚拟机会在特定情况释放锁。

   **锁类型（独占式和共享式）**

   我们先区分一下在文件锁中两种锁的区别：①独占式的锁就想我们上面测试的那样，只要有一个进程获取了独占锁，那么别的进程只能等待。②共享锁在一个进程获取的情况下，别的进程还是可以读取被锁定的文件，但是别的进程不能写只能读。

#### Selector(选择器)

1. **Selector（选择器）介绍**

   - Selector 一般称 为选择器 ，当然你也可以翻译为 多路复用器 。它是Java NIO核心组件中的一个，用于检查一个或多个NIO Channel（通道）的状态是否处于可读、可写。如此可以实现单线程管理多个channels,也就是可以管理多个网络链接。它是非阻塞IO的核心。
   - 使用Selector的好处在于： 使用更少的线程来就可以来处理通道了， 相比使用多个线程，避免了线程上下文切换带来的开销。

   ![mark](https://imgconvert.csdnimg.cn/aHR0cDovL3FuLm1ha2Vyc3kudG9wL2Jsb2cvMjAxOTA3MTMvQmtqa2xYQzgzT0VNLmpwZw)

2. **Selector（选择器）的使用方法介绍**

   Selector可以去监听的请求有以下几类：

   1、connect：客户端连接服务端事件，对应值为SelectionKey.OP_CONNECT
   
   2、accept：服务端接收客户端连接事件，对应值为SelectionKey.OP_ACCEPT

   3、read：读事件，对应值为SelectionKey.OP_READ
   
   4、write：写事件，对应值为SelectionKey.OP_WRITE
   
   每次请求到达服务器，都是从connect开始，connect成功后，服务端开始准备accept，准备就绪，开始读数据，并处理，最后写回数据返回。
   
   `SelectionKey`是一个复合事件，一个SelectionKey键表示了一个特定的通道对象和一个特定的选择器对象之间的注册关系。绑定到某个selector对应的某个channel上，可能是多个事件的复合或单一事件。
   
    **Selector的创建**
    ```java
    Selector selector = Selector.open();
    ```

    **注册Channel到Selector并传入监听事件(Channel必须是非阻塞的)**
    ```java
    channel.configureBlocking(false);
    SelectionKey key = channel.register(selector, Selectionkey.OP_READ);
    ```


### 最后

NIO的东西是很多的，因为需要熟悉Java中为其设计的很多api以及操作系统的概念。