---
title: JSP FileUpload实现文件上传
date: 2018-12-23 22:59:50
tags:
- Java
- Web

categories:
- Java
- Web
---

#### 文件上传的条件
* 表单必须是post提交方式
* 表单中必须有文件上传项，文件上传项必须有name属性和值
* 表单的enctype属性必须设置为multipart/form-data

<!--more -->
#### 文件上传基本操作
数据接收：通过使用fileupload jar包的Common-FileUpload组件完成文件上传
基本步骤：
1. 创建一个 **磁盘文件项工厂** 的对象
  `DiskFileItemFactory diskFileItemFactory = new DiskFileItemFactory();`
2. 创建一个核心解析类
  `ServletFileUpload servletFileUpload = new ServletFileUpload(diskFileItemFactory );`
3. 解析request请求 —— *parseRequest*，返回一个List集合，List集合中存放的是*FileItem*对象（每一个表单项都是一个*FileItem*对象）
  `List<FileItem> list = servletFileUpload.parseRequest(request);`
4. 遍历集合，获得每个FileItem，判断是表单项还是文件上传项
  *fileItem.isFormField()*: 返回是普通的文件表单项还是文件上传项
  *fileItem.getFieldName()*: 获得表单项的**name**属性值
  *fileItem.getString("UTF-8")*: 获取表单的文本值，可设置UTF-8解决中文乱码
5. 获得文件名：
  `String filename = fileItem.getName();`
6. 通过自定义工具类获得**唯一**文件名：
  `String uuidfilename = UploadUtils.getUUIDFileName(filename);`注：*UploadUtils*类是自定义工具类，具体实现是：
```java
public class UploadUtils {
	/*
	 * 生成唯一文件名
	 * */
	public static String getUUIDFileName(String fileName) {
		int idx = fileName.lastIndexOf(".");
		String extention = fileName.substring(idx);//扩展名
		String uuidFileName = UUID.randomUUID().toString().replace("-", "")+extention;
		
		return uuidFileName;
	} 
	public static void main(String[] args) {
		System.out.println(getUUIDFileName("1.jpg"));
	}
}
```
7. 输入流获得文件上传的数据：
  `InputStream is = fileItem.getInputStream();`
8. 得到文件要上传的路径
  `url = this.getServletContext().getRealPath("/upload")+"//"+uuidfilename;`
9. 输入流对接输出流
```java
OutputStream os = new FileOutStream(url);//输出流目标为url
int len = 0;
byte[] b = new byte[1024];
while((len=is.read(b)) != -1){//读取输入流到b中
os.write(b,0,len);//将b写入输出流中
}
is.close();//关闭输入流
os.close();//关闭输出流
}
```