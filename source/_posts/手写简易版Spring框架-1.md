---
title: 手写简易版Spring框架-1
date: 2019-07-09 21:20:46
tags:
- Spring
- Java

categories:
- Spring
---

### 前言

为了巩固学习Spring框架，我尝试通过手写spring，实现SpringMVC基本功能来学习Spring源码。

<!-- more -->

### 实现功能

这次先写了一个简易的框架，实现了最基本的IoC功能，以及springmvc中常用的注解，具体如下:
- `@Controller`
- `@RequestMapping` 
- `@RequestParam`
- `@Autowired`
- `@Bean`

### 代码

#### 内嵌服务器

采用了apache的`embed-core`包在项目中内置了一个tomcat服务器，直接调用一个自己写的start()方法即可启动。本包在gradle中依赖如下：

```json
// https://mvnrepository.com/artifact/org.apache.tomcat.embed/tomcat-embed-corecompile
group: 'org.apache.tomcat.embed', name: 'tomcat-embed-core', version: '8.5.23'
```

下面是TomcatServer类：

```java
/**
 * Created by makersy on 2019
 */

public class TomcatServer {

    private Tomcat tomcat;
    private String[] args;

    public TomcatServer(String[] args) {
        this.args = args;
    }

    //启动类
    public void startTomcat() throws LifecycleException {
        tomcat = new Tomcat();
        tomcat.setPort(6699);
        tomcat.start();
        Context context = new StandardContext();
        context.setPath("");
        context.addLifecycleListener(new Tomcat.FixContextListener());  //默认监听器
        DispatcherServlet servlet = new DispatcherServlet();  //前端控制器
        Tomcat.addServlet(context, "dispatcherServlet", servlet).setAsyncSupported(true);  //支持异步的servlet
        context.addServletMappingDecoded("/", "dispatcherServlet");  //为Servlet绑定映射，/表示可以处理所有uri
        tomcat.getHost().addChild(context);

        Thread awaitThread = new Thread("tomcat_await_thread"){
            @Override
            public void run() {
                TomcatServer.this.tomcat.getServer().await();  //声明该线程一直在等待
            }
        };
        //设置为非守护线程
        awaitThread.setDaemon(false);
        //使该线程等待
        awaitThread.start();
    }
}
```

#### DispatcherServlet（用来维护Servlet）

DispatcherServlet类进行servlet的维护，实现请求分发。

```java
/**
 * Created by makersy on 2019
 */

public class DispatcherServlet implements Servlet {

    @Override
    public void init(ServletConfig config) throws ServletException {

    }

    @Override
    public ServletConfig getServletConfig() {
        return null;
    }

    @Override
    public void service(ServletRequest req, ServletResponse res) throws ServletException, IOException {
        for (MappingHandler mappingHandler : HandlerManager.mappingHandlerList) {
            try {
                if (mappingHandler.handle(req, res)) {
                    return;
                }
            } catch (IllegalAccessException | InstantiationException | InvocationTargetException e) {
                e.printStackTrace();
            }
        }
    }

    @Override
    public String getServletInfo() {
        return null;
    }

    @Override
    public void destroy() {

    }
}

```

#### MappingHandler

MappingHandler用来处理经过dispatcherservlet的请求uri，每个MappingHandler处理其匹配的uri请求。

```java
/**
 * Created by makersy on 2019
 */

public class MappingHandler {

    private String uri;
    private Method method;
    private Class<?> controller;
    private String[] args;

    public boolean handle(ServletRequest request, ServletResponse response) throws IllegalAccessException, InstantiationException, InvocationTargetException, IOException {
        String requestUri = ((HttpServletRequest)request).getRequestURI();
        if (!uri.equals(requestUri)) {
            return false;
        }

        Object[] parameters = new Object[args.length];
        for (int i = 0; i < args.length; i++) {
            parameters[i] = request.getParameter(args[i]);
        }

        Object ctl = BeanFactory.getBean(controller);
        Object res = method.invoke(ctl, parameters);
        response.getWriter().println(res.toString());
        return true;
    }
    public MappingHandler(String uri, Method method, Class<?> controller, String[] args) {
        this.uri = uri;
        this.method = method;
        this.controller = controller;
        this.args = args;
    }
}

```

#### HandlerManager

HandlerManager负责处理controller注解，将其转换为handler。

```java
/**
 * Created by makersy on 2019
 */

public class HandlerManager {

    public static List<MappingHandler> mappingHandlerList = new ArrayList<>();

    /**
     * 将list中的controller转化为MappingHandler
     * @param classList 类列表
     */
    public static void resolveMappingHandler(List<Class<?>> classList) {
        for (Class<?> cls : classList) {
            if (cls.isAnnotationPresent(Controller.class)) {
                parseHandlerFromController(cls);
            }
        }
    }

    /**
     * 将controller转化为handler
     * @param cls
     */
    private static void parseHandlerFromController(Class<?> cls) {
        Method[] methods = cls.getDeclaredMethods();
        for (Method method : methods) {
            //判断方法是否有RequestMapping注解
            if (!method.isAnnotationPresent(RequestMapping.class)) {
                continue;
            }
            String uri = method.getDeclaredAnnotation(RequestMapping.class).value();
            List<String> paramNameList = new ArrayList<>();
            //获取method的带有RequestParam注解的参数，形成一个list
            for (Parameter parameter : method.getParameters()) {
                if (parameter.isAnnotationPresent(RequestParam.class)) {
                    paramNameList.add(parameter.getDeclaredAnnotation(RequestParam.class).value());
                }
            }
            String[] params = paramNameList.toArray(new String[paramNameList.size()]);
            MappingHandler mappingHandler = new MappingHandler(uri, method, cls, params);
            HandlerManager.mappingHandlerList.add(mappingHandler);
        }
    }
}

```

#### ClassScanner

负责扫描一个jar包下面的所有类。用于初始化时获取所有类的列表，从而进行依赖注入，以及controller扫描。

```java
/**
 * Created by makersy on 2019
 */

public class ClassScanner {

    /**
     * 扫描一个包下面的所有类
     * @param packageName 包名
     * @return
     * @throws IOException
     * @throws ClassNotFoundException
     */
    public static List<Class<?>> scanClass(String packageName) throws IOException, ClassNotFoundException {
        List<Class<?>> classList = new ArrayList<>();
        String path = packageName.replace(".", "/");  //将包名转化为路径名
        ClassLoader classLoader = Thread.currentThread().getContextClassLoader();  //获取类加载器
        Enumeration<URL> resources = classLoader.getResources(path);
        while (resources.hasMoreElements()) {
            URL resource = resources.nextElement();
            if (resource.getProtocol().contains("jar")) {  //如果资源类型是jar包
                JarURLConnection jarURLConnection = (JarURLConnection) resource.openConnection();
                String jarFilePath = jarURLConnection.getJarFile().getName();
                classList.addAll(getClassesFromJar(jarFilePath, path));
            } else {
                //todo
            }
        }
        return classList;
    }

    /**
     * 获取一个jar包下所有类
     * @param jarFilePath
     * @param path
     * @return 类的list
     * @throws IOException
     * @throws ClassNotFoundException
     */
    private static List<Class<?>> getClassesFromJar(String jarFilePath, String path) throws IOException, ClassNotFoundException {
        List<Class<?>> classes = new ArrayList<>();
        JarFile jarFile = new JarFile(jarFilePath);
        Enumeration<JarEntry> jarEntries = jarFile.entries();
        while (jarEntries.hasMoreElements()) {
            JarEntry jarEntry = jarEntries.nextElement();
            String entryName = jarEntry.getName();
            if (entryName.startsWith(path) && entryName.endsWith(".class")) {
                String classFullName = entryName.replace("/", ".").substring(0, entryName.length() - 6);  //类的全限定名
                classes.add(Class.forName(classFullName));
            }
        }
        return classes;
    }
}
```

#### Controller、RequestMapping和RequestParam注解

关于注解，可以参考我之前的文章：[Java的注解](https://blog.csdn.net/makersy/article/details/94898668)

**Controller**

```java
/**
 * Created by makersy on 2019
 */

@Documented
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.TYPE)
public @interface Controller {
}
```

**RequestMapping**

```java
/**
 * Created by makersy on 2019
 */

@Documented
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.METHOD)
public @interface RequestMapping {
    String value();
}
```

**RequestParam**

```java
/**
 * Created by makersy on 2019
 */

@Documented
@Retention(RetentionPolicy.RUNTIME)  //保存级别
@Trget(ElementType.PARAMETER)
public @interface RequestParam {
    String value();
}
```

#### BeanFactory

这个是IoC的重点部分，所有的依赖都是由BeanFactory处理并注入的。

```java
package top.makersy.beans;

import top.makersy.web.mvc.Controller;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Created by makersy on 2019
 */

public class BeanFactory {

    //用一个类和实例的映射来模拟Bean工厂
    private static Map<Class<?>, Object> classToBean = new ConcurrentHashMap<>();

    //从映射中获取Bean
    public static Object getBean(Class<?> cls){
        return classToBean.get(cls);
    }

    /**
     * Bean初始化，将表中所有类的依赖都加入 classToBean 这个映射中
     * @param classList 包中所有类的集合
     * @throws Exception
     */
    public static void initBean(List<Class<?>> classList) throws Exception {
        List<Class<?>> toCreate = new ArrayList<>(classList);  //新建1个list来存放，以免改变了传入List的值
        //一一初始化每一个类直到将类集合全部初始化完为止
        while (toCreate.size() != 0) {
            int remainSize = toCreate.size();
            for (int i = 0; i < toCreate.size(); i++) {
                if (finishCreate(toCreate.get(i))) {
                    toCreate.remove(i);
                }
            }
            // 当要创建的Bean列表长度始终不变时，说明出现了Bean之间相互依赖的问题。
            // 因为我们采取的策略是当前Bean创建失败就去创建下一个，这样后面的创建完了有来重新创建前
            // 面的依赖，如果这个阶段了list长度始终不变，那么说明Bean之间存在相互的依赖，A不创建B没
            // 法创建，B不创建A也没法创建。
            // 这里不进行处理，而是直接抛出异常
            if (toCreate.size() == remainSize) {
                throw new Exception("cycle dependency!");
            }
        }
    }

    private static boolean finishCreate(Class<?> cls) throws IllegalAccessException, InstantiationException {
        if (!cls.isAnnotationPresent(Bean.class) && !cls.isAnnotationPresent(Controller.class)) {
            return true;
        }

        Object bean = cls.newInstance();
        //获取所有字段，处理其中需要自动注入的
        for (Field field : cls.getDeclaredFields()) {
            //处理 autowired 注解，自动注入
            if (field.isAnnotationPresent(Autowired.class)) {
                Class<?> fieldType = field.getType();
                Object relianBean = BeanFactory.getBean(fieldType);  //从BeanFactory中获取依赖的Bean
                //注意这里在BeanFactory中没有找到依赖的Bean时就返回false，放弃创建当前Bean，转而创建后面的。
                if (relianBean == null) {
                    return false;
                }
                field.setAccessible(true);  //关闭安全检查
                field.set(bean, relianBean);  //将bean的field值更新为relianBean，field值即需要注入的依赖
            }
        }
        classToBean.put(cls, bean);
        return true;
    }
}
```

#### Autowired、Bean注解

**Autowired**

```java
/**
 * Created by makersy on 2019
 */

@Documented
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.FIELD)
public @interface Autowired {
}
```

**Bean**

```java
/**
 * Created by makersy on 2019
 */

@Documented
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.TYPE)
public @interface Bean {
}
```

### 最后

因为是刚开始，所以只实现了一些基础功能，ioc的循环依赖处理、aop都还没有实现，后面我会在此基础上进行完善。