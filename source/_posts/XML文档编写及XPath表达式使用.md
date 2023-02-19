---
title: XML文档编写及XPath表达式使用
date: 2018-12-06 22:51:10
tags:  
- 前端
- Java
categories:  
- 前端
---

#### XML简介
**XML**是可扩展标记语言(Extensible Markup Language，XML)缩写，用于标记电子文件使其具有结构性的标记语言，可以用来标记数据、定义数据类型，是一种允许用户对自己的标记语言进行定义的源语言。可以用于Java程序配置描述文件、保存产生的数据、网络间数据传输等。

<!-- more -->

#### XML语法&结构
XML文档结构
1. 第一行需是XML文档声明
2. 有且只有一个根节点
3. 书写规则与HTML相同

标签名使用**小写英文**, 单词间用-分隔
多级标签之间不要存在重名

对特殊符号使用实体引用或CDATA标签
5种实体引用
```xml
&lt; <
&gt; >
&amp; &
&apos; '
&quot; "
```
CDATA标签:
`<![CDATA[不希望由XML解析的文本数据]]>`

**XML语义约束**
语义约束的两种定义方式:**DTD**与**XML Schema**
**DTD**
利用DTD中的<！ELEMENT>标签定义XML文档中允许出现的节点及数量
例: `<!ELEMENT hr (employee)>`
`<!ELMENT name(#PCDATA)>`   定义name标签体只能是文本
使用描述符表达子节点数量
`+` 至少出现1个子节点
`*` 可出现0...n个子节点
`?`最多出现1个子节点
在XML中使用<!DOCTYPE>标签来引用DTD文件。
书写格式:
`<!DOCTYPE 根节点 SYSTEM "dtd文件路径">`

**Schema**
比DTD更复杂
XML Schema提供了数据类型、格式限定、数据范围等特性
`<schema xmlns="http://www.w3.org/2001/XMLSchema">`
声明文本是Schema
`<element>`代表标签节点
`<complexType>`复杂节点, 标签包含子节点时使用
`<sequence>`子标签按顺序排列
`<attribute>`设置属性
标签属性:
name= 属性名称
type= 属性值类型
use="required" 属性必须存在
minOccurs="n" 最小出现次数
maxOccurs="n" 最大出现次数
`<simpleType>`简单类型。 代替属性:type使用
`<restriction>`限定数据类型
base="xx" 基本类型
`<minInclusive value="">`最小数据范围
`<maxInclusive value="">`最大数据范围
在XML文本的根节点添加
```
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="Schema文件路径" 
```
属性来关联schema文本

#### Dom4j
**Dom4j**是java用来读取和操作xml文档的一种方式。
DOM(Document Object Model) 文档对象模型把xml文档看做一个树结构
Dom4j的含义和作用
1. 将xml文件视为Document对象
2. 将xml文件中的标签视为Element对象
  使用时需下载dom4j的jar包并导入。

#### XPath
**基本表达式**
nodename: 选取此节点的所有子节点
`/` 从根节点选取
`//` 从匹配选择的当前节点选择文档中的节点
`.` 当前节点
`..` 当前节点的父节点
`@` 选取属性
**谓语表达式**
`[1]` 第一个匹配的元素
`[last()]` 最后一个匹配的元素
`[last()-1]` 倒数第二个匹配的元素
`[position()<3]` 最前面两个匹配的元素
`[@lang]` 选取所有拥有lang属性的元素
`[@lang='value']` 选取所有包含lang属性且属性值为value的元素
`[price>35.00]` 选取price元素值大于35.00的元素

#### 总结
下面是我写的一个例子：
XML文件
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!-- <!DOCTYPE hr SYSTEM "NewFile.dtd"> --><!-- 人力资源管理系统 -->
<hr xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:noNamespaceSchemaLocation="hr.xsd">
	//xml schema文件名为hr.xsd
	<employee no="3309">
		<name>张三</name>
		<age>31</age>
		<salary>4000</salary>
		<department>
			<dname>会计部</dname>
			<address>b103</address>
		</department>
	</employee>
	<employee no="3310">
		<name>李四</name>
		<age>22</age>
		<salary>4000</salary>
		<department>
			<dname>会计部</dname>
			<address>b103</address>
		</department>
	</employee>

	<employee no="3311">
		<name>张无忌</name>
		<age>30</age>
		<salary>3600</salary>
		<department>
			<department />
			<dname>人事部</dname>
			<address>XX大厦-B105</address>
		</department>
	</employee>
</hr>
```
xml语义约束--xml schema文件(.xsd)
```xml
<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://www.w3.org/2001/XMLSchema" targetNamespace="http://www.example.org/hr" xmlns:tns="http://www.example.org/hr" elementFormDefault="qualified">
	<element name="hr">
		<complexType>
			<sequence>
				<element name="employee" minOccurs="1" maxOccurs="9999">
					<complexType>
						<sequence>
							<element name="name" type="string"></element>
							<element name="age">
								<simpleType>
									<restriction base="integer">
										<minInclusive value="18"></minInclusive>
										<maxInclusive value="60"></maxInclusive>
									</restriction>
								</simpleType>
							</element>
							<element name="salary" type="integer"></element>
							<element name="department">
								<complexType>
									<sequence>
										<element name="dname" type="string"></element>
										<element name="address" type="string"></element>
									</sequence>
								</complexType>
							</element>
						</sequence>
						<attribute name="no" type="string" use="required"></attribute>
					</complexType>
				</element>
			</sequence>
		</complexType>
	</element>
</schema>
```
读xml
```java
package hr;

import java.util.List;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

public class Hrreader {
	void readXml() {
		String file = "d:/Eclipse/workplace/calculator/src/NewFile.xml";
		SAXReader reader = new SAXReader();
		try {
			Document document = reader.read(file);
			//获取文档根节点，即hr标签
			Element root = document.getRootElement();
			List<Element> employees = root.elements("employee");
			for( Element employee : employees ) {
				Element name = employee.element("name");
				String empName = name.getText();
				System.out.println(empName);
				System.out.println(employee.elementText("age"));
				System.out.println(employee.elementText("salary"));
			}
		} catch (DocumentException e) {
			// TODO 自动生成的 catch 块
			e.printStackTrace();
		}
	}
	public static void main(String[] args) {
		Hrreader reader = new Hrreader();
		reader.readXml();
	}
}
```
写xml
```java
package hr;

import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.io.Writer;

import org.dom4j.Document;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

public class HrWriter {
	public void WriteXml(){
		String file = "d:/Eclipse/workplace/calculator/src/NewFile.xml";
		SAXReader reader = new SAXReader();
		try {
			Document document = reader.read(file);
			Element root = document.getRootElement();
			Element employee = root.addElement("employee");
			employee.addAttribute("no", "3311");
//			Element name = employee.addElement("name");
//			name.setText("李想");
			employee.addElement("name").setText("张无忌");
			employee.addElement("age").setText("30");
			employee.addElement("salary").setText("3600");
			Element department = employee.addElement("department");
			department.addElement("department");
			department.addElement("dname").setText("人事部");
			department.addElement("address").setText("XX大厦-B105");
			Writer writer = new OutputStreamWriter(new FileOutputStream(file), "UTF-8");
			document.write(writer);
			writer.close();
			
		} catch (Exception e) {
			// TODO: handl exception
			e.printStackTrace();
		}
		
	}
	public static void main(String[] args) {
		HrWriter hrWriter = new HrWriter();
		hrWriter.WriteXml();
	}
}
```
利用xpath进行xml文件的各种查找，类似数据库的查找语句
```java
package hr;

import java.util.List;

import org.dom4j.Document;
import org.dom4j.Element;
import org.dom4j.Node;
import org.dom4j.io.SAXReader;

public class XPathTestor {
	public void xpath(String xpathExp) {
		String file = "d:/Eclipse/workplace/calculator/src/NewFile.xml";
		SAXReader reader = new SAXReader();
		try {
			Document document = reader.read(file);
			List<Node> nodes = document.selectNodes(xpathExp);
			for( Node node : nodes ) {
				Element emp = (Element)node;
				System.out.println(emp.attributeValue("no"));
				System.out.println(emp.elementText("name"));
				System.out.println(emp.elementText("age"));
				System.out.println(emp.elementText("salary"));
				System.out.println("===========================");
			}
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
	}
	public static void main(String[] args) {
		XPathTestor testor = new XPathTestor();
		// 查询   斜杠/代表根节点
//		testor.xpath("/hr/employee");
//		testor.xpath("//employee[@no=3311]");
//		testor.xpath("//employee[1]");
//		testor.xpath("//employee[last()]");
		testor.xpath("//employee[position()<3]");
//		testor.xpath("//employee[1] | //employee[2]");
	}
}
```