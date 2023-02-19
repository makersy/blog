---
title: 【Java】基于Java NIO的多人聊天室
date: 2019-07-14 00:12:05
tags:
- Java
- NIO

categories:
- Java
- IO
---

### 前言

学习了NIO的基本原理及使用方法之后，开始尝试写一个NIO实现的聊天室，练习一下代码流程。

<!-- more -->

### 服务器端

服务器端主要负责接受各客户端的连接，接收客户端发来的信息，并且将其广播给所有已连接客户端。

```java
/**
 * Created by makersy on 2019
 */

/**
 * NIO服务器端
 */
public class NioServer {

    /**
     * 启动
     */
    public void start() throws IOException {

        // 1. 创建一个Selector
        Selector selector = Selector.open();

        // 2. 通过ServerSocketChannel创建channel通道
        ServerSocketChannel serverSocketChannel = ServerSocketChannel.open();

        // 3. 为channel通道绑定监听端口
        serverSocketChannel.bind(new InetSocketAddress(8000));

        // 4. 设置channel为非阻塞模式
        serverSocketChannel.configureBlocking(false);

        // 5. 将channel注册到selector上，监听连接事件
        serverSocketChannel.register(selector, SelectionKey.OP_ACCEPT);  //ACCEPT : 接收客户端连接
        System.out.println("服务器启动成功");

        // 6. 循环等待新接入的连接

        for (; ; ) {  // 也可while(true) c语言常用：for(;;) 
            //获取可用channel数量
            int readyChannels = selector.select();  //select() 是一个阻塞方法

            //防止空轮询
            if (readyChannels == 0) continue;

            //获取可用channel的集合
            Set<SelectionKey> selectionKeys = selector.selectedKeys();

            Iterator iterator = selectionKeys.iterator();

            while (iterator.hasNext()) {
                //selectionKey实例
                SelectionKey selectionKey = (SelectionKey) iterator.next();

                //移除Set中的当前selectionKey
                iterator.remove();

                // 7. 根据就绪状态，调用对应方法处理业务逻辑
                //如果是 接入事件
                if (selectionKey.isAcceptable()) {
                    acceptHandler(serverSocketChannel, selector);
                }

                //如果是 可读事件
                if (selectionKey.isReadable()) {
                    readHandler(selectionKey, selector);
                }

            }
        }

    }

    /**
     * 接入事件处理器
     */
    private void acceptHandler(ServerSocketChannel serverSocketChannel,
                               Selector selector) throws IOException {
        //如果是接入事件，创建socketChannel
        SocketChannel socketChannel = serverSocketChannel.accept();

        //将socketChannel设置为非阻塞工作模式
        socketChannel.configureBlocking(false);

        //将socketChannel注册到selector上，监听 可读事件
        socketChannel.register(selector, SelectionKey.OP_READ);

        //回复客户端提示信息
        socketChannel.write(Charset.forName("UTF-8")
                .encode("你与聊天室其他人都不是朋友关系，请注意隐私安全"));

    }

    /**
     * 可读事件处理器，读取客户端发送来的信息，并广播给其他客户端
     */
    private void readHandler(SelectionKey selectionKey, Selector selector) throws IOException {

        //要从 selectionKey 中获取到已经就绪的channel
        SocketChannel socketChannel = (SocketChannel) selectionKey.channel();

        //创建一个buffer
        ByteBuffer byteBuffer = ByteBuffer.allocate(1024);

        //使用buffer循环读取请求信息
        String request = "";
        while (socketChannel.read(byteBuffer) > 0) {
            //切换buffer为读模式
            byteBuffer.flip();

            //读取buffer中的内容
            request += Charset.forName("UTF-8").decode(byteBuffer);

        }
        //将 socketChannel 再次注册到selector上，监听 可读事件
        socketChannel.register(selector, SelectionKey.OP_READ);

        //将客户端发送的请求信息广播给其他客户端
        if (request.length() > 0) {
            //广播给其他客户端
            broadCast(selector, socketChannel, request);
        }
    }

    //广播给其他客户端
    private void broadCast(Selector selector, SocketChannel sourceChannel, String request) {
        //获取到所有已接入的客户端channel
        Set<SelectionKey> selectionKeys = selector.keys();

        //循环向所有channel广播信息
        selectionKeys.forEach(selectionKey -> {

            Channel targetChannel = selectionKey.channel();

            // 发送消息，剔除发消息的客户端
            if (targetChannel instanceof SocketChannel && targetChannel != sourceChannel) {
                try {
                    //将信息发送到targetChannel客户端
                    ((SocketChannel) targetChannel).write(Charset.forName("UTF-8").encode(request));
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }

        });

    }

    public static void main(String[] args) {
        try {
            new NioServer().start();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}

```

### 客户端启动类

向服务器端发送数据。同时新开线程接收服务器端发来的数据。

```java
/**
 * Created by makersy on 2019
 */

/*
 NIO客户端，封装启动代码
 */
public class NioClient {

    /**
     * 启动方法
     */
    public void start(String nickname) throws IOException {

        //连接服务器端
        SocketChannel socketChannel = SocketChannel.open(
                new InetSocketAddress("127.0.0.1", 8000));

        System.out.println("客户端 " + nickname + " 启动成功!");

        //接收服务器端响应
        Selector selector = Selector.open();
        socketChannel.configureBlocking(false);  //非阻塞
        socketChannel.register(selector, SelectionKey.OP_READ);  //注册为接收模式
        //需要新开一个线程，专门负责接收服务端的响应数据。因为当前线程需要负责发送给服务器端数据
        new Thread(new NioClientHandler(selector)).start();  //新开线程

        //向服务器端发送数据
        Scanner scanner = new Scanner(System.in);
        while (scanner.hasNextLine()) {
            String request = scanner.nextLine();
            if (request != null && request.length() > 0) {
                socketChannel.write(Charset.forName("UTF-8").encode(nickname + " : " + request));
            }
        }

    }
}

```

### 客户端接收服务器端数据类

负责接收服务端发来的数据。

```java
/**
 * Created by makersy on 2019
 */

/**
 * 客户端线程类，专门接收服务器端响应信息
 */

public class NioClientHandler implements Runnable {

    private Selector selector;

    public NioClientHandler(Selector selector) {
        this.selector = selector;
    }

    @Override
    public void run() {
        try {
            for (; ; ) {
                int readyChannels = selector.select();

                if (readyChannels == 0) continue;

                Set<SelectionKey> selectionKeys = selector.selectedKeys();

                Iterator iterator = selectionKeys.iterator();

                while (iterator.hasNext()) {
                    SelectionKey selectionKey = (SelectionKey) iterator.next();

                    iterator.remove();

                    if (selectionKey.isReadable()) {
                        readHandler(selectionKey, selector);
                    }

                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 可读事件处理器
     */
    private void readHandler(SelectionKey selectionKey, Selector selector) throws IOException {

        //要从 selectionKey 中获取到已经就绪的channel
        SocketChannel socketChannel = (SocketChannel) selectionKey.channel();

        //创建一个buffer
        ByteBuffer byteBuffer = ByteBuffer.allocate(1024);

        //使用buffer循环读取服务器端请求信息
        String response = "";
        while (socketChannel.read(byteBuffer) > 0) {

            //切换buffer为读模式
            byteBuffer.flip();

            //读取buffer中的内容
            response += Charset.forName("UTF-8").decode(byteBuffer);

        }
        //将 socketChannel 再次注册到selector上，监听 可读事件
        socketChannel.register(selector, SelectionKey.OP_READ);

        //将服务器端响应信息打印到本地
        if (response.length() > 0) {
            System.out.println(response);
        }
    }
}
```

### 实例：A客户端、B客户端

到这里服务器端和客户端响应启动代码就已经完成了，如果我们需要连接到服务器端进入群聊，只要新开一个线程，命名即可。

假设我新建一个AClient，代码如下：

```java
/**
 * Created by makersy on 2019
 */

public class AClient {
    public static void main(String[] args) throws IOException {
        new NioClient().start("AClient");
    }
}
```

再次创建新线程流程同上面一样。

### 效果演示

**A客户端**

![mark](http://qn.haoliny.top/blog/20190713/i9hooyfSlgnQ.jpg?imageslim)

**B客户端**

![mark](http://qn.haoliny.top/blog/20190713/yDfztgXDJMNf.jpg?imageslim)

### 最后

不得不说，NIO的程序还是挺难写的，而且还会出现许多的问题。像我写的这么简单的代码就肯定有很多bug存在，更别说复杂的业务代码了。这也应该就是大多数人不使用JDK原生NIO进行网络编程的原因了。