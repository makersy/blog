---
title: HTML小记
date: 2018-11-18 18:55:59
tags:  
- HTML
- 前端
categories:  
- 前端
- HTML
---
由于要学习Java Web开发，先学习一下HTML。下面是一些基础知识。
<!-- more  -->
### 标题标签
标题标签共有六级：<h1,2,3,4,5,6></......>  
如：
```HTML
<h1>一级标题</h1>
```
对应大小：h1,2,3,4,5,6--32px,24px,18px,16px,14px,12px  
1em=16px  
### 段落  
```HTML
<p>段落内容</p>
```
1. 默认浏览器样式，空标签也会占位置（本来是空的，但由于浏览器可能默认设置为固定大小，因此需要自定义）；  
2. 标签的默认浏览器可能造成部分问题，建议自定义；  

设置段落标签的属性:在head内的style中设置
```HTML
<style>
p{
	margin: 0;
	padding: 0;
}
</style>
```
如此，内外边距为0。
### 字体  
基本不用，一般在css中设置。
```html
<font>字体内容</font>
```
size: 字体大小
face：字体集
color：颜色，三种表示法——名称，16进制，rgb坐标
### 链接  
```html
<a>HTML链接</a>
<a href="http://www.makersy.top" target="_blank">博客</a> (新建一个窗口)
<a href="http://www.makersy.top" target="_self">博客</a> （在当前页面打开）
```
**页面锚点**  
```html
<a href="#xxx">页面内锚点</a>（跳转到id为xxx的地方）

<h3 id="xxx"> 你好</h3>
```
**禁止跳转**
```html
<a href="javascript:; / javascript:void(0);">死链接</a>   ---这是一个死链接
```

**去掉下划线、去掉指向链接时光标的手形**
```html
a{
text-decoration: none;
cursor: none;
}
```
### 列表  

- 无序列表
```html
<ul><li>内容</li></ul>
```
- 有序列表
```html
<ol><li></li></ol> 
```
- 定义列表
```html
<dl>
	<dt>定义概念的名字</dt>
	<dd>概念的解释 主体</dd>
</dl> 
```
**贴士：**
1. type属性项目符号样式`<ul type=""></ul>`
（*disc*（实心圆）,*circle*（空心圆）,*square*(实心方形)，none表示不去设置它的项目符号样式，但会保留项目符号所在的位置）不建议使用！
有序标签ol无法设置项目符号，独具特色的顺序就是他的项目符号
定义列表也无法设置其项目符号
2. 只用`<ul></ul>`无序列表就好了
以后看到样式，都不要通过html（或者元素本身属性）去设置，通过css。

### 图像
1. 标签 <img />
2. **作用** 插入图像
3. **属性** src（src这个属性是图片的地址，有这个属性才能实现图像效果。）
4. **支持格式**：  
- PNG、JPEG、GIF、PDF（引入的PDF必须是单页的）
- 非标签方式：background
5. alt：在图片无法显示比如地址写错时，提示用户这里本来放的是什么
6. class:标识，用来指定标签的类名
例：
```html
<img alt="logo" src="https://img1.mukewang.com/5b8cef4200019d9a02000200-140-140.jpg">
<!-- 非标签方式 -->
<style>
.logo{
background: url(https://img1.mukewang.com/5b8cef4200019d9a02000200-140-140.jpg);
width: 140px;
height: 150px;
}
</style>
<p class="logo"></p>
```
#### 插入本地图像  
**路径**：绝对路径-- *C:\html\logo.jpg*，相对路径-- 与文件同级目录下-- *./img/logo.png* 或者 *../logo.png*

### div  
`<div></div>` 万能标签 无语义标签
作用：布局
贴士：非常常用且重要 现代布局常用  
### 块级元素与行内元素  
块级元素垂直分段排列。行内元素水平一行内一个挨着一个。
`<span>包裹一行内容</span>`
块级元素大小取决于开发者的设置，行内元素大小取决于内容  
### 注释  
**单行注释**：`<!--注释文本-->`
**多行注释**：`<!--注释开始-->...<!--注释结束-->`，这里，多行注释不会隐藏注释间的内容，只是开发时的提示。
**条件注释**：`<!--[if IE 6]>注释内容<![endif]-->`，这里，条件注释主要用于浏览器兼容性。条件注释只在IE10以下版本的浏览器中生效。提示浏览器较旧。
### 一些不常用的标签  
以下标签一般都不用！！！
文本格式化标签（为避免浏览器差异，一般不用，多用css设置）

```html
<b>加粗</b>
<strong>加粗2</strong>
<big>大号字体</big>
<em>强调字体(斜体)</em>
<i>斜体/图标</i>
<small>小号字体</small>
<sub>下标</sub>
<sup>上标</sup>
```
预格式文本标签：`<pre>一般这里是预览的代码</pre>`
引用标签：`<blockquote>引用来的</blockquote>`
删除线标签：`<del>删除的内容</del>`
下划线标签:`<ins>下划线的内容</ins>`

### 表格  
```html
<!-- 无序列表 -->
野生动物
<ul type="circle">
    <li>苹果</li>
    <li>栗子</li>
</ul>
<!-- 有序列表 -->
<ol>
	<li>煎饼果子</li>
	<li>台湾饭团</li>
</ol>
<!-- 定义列表 -->
<dl>
    <dt>正数</dt> 
    <dd>大于0的自然数</dd>
</dl>
```
### 表单   
标签`<form> </form>`
作用：手机用户输入的内容（文本、文件）
属性：
（1）action：提交到的服务端地址
（2）method：指定提交时用哪种HTTP方法：POST/GET
（3）name:标识
（4）autocomplete:浏览器是否可以填充
（5）enctype:指定表单内容编码
input:文本、密码、单选、多选、按钮、数字、日期、颜色、范围、邮件、URL、文件
select:下拉列表
textarea:文本域
button:按钮
inout(单尖括号标签)
文本：`<input type="text"maxlength=""(最大输入框长度)value=""/>`
密码：`<input type="password"value=""/>`
单选：`<input type="radio" name=""vaule=""/>`做单选操作，name要相同
多选:`<input type="checkbox"name=""value="checked"/>(checked)`默认选中
按钮：`<input type="button"value=""/>`
数字:`<input type="number"/>`
日期：`<input type="date"/>`
颜色：`<input type="color"/>`(由于兼容性问题不是很常用)
范围:`<input type="range"min="" max=""/>`
邮件:`<input type="email"/>`
提交按钮:`<input type="submit"value="提交"/>`
URL:`<input type="url"/>`(和邮件一样自带格式校验)
文件：`<input type="file"mulitple="multiple"(多个文件)>`  
**select**：下拉列表
如果`<select>`标签中设置了multiple或size属性的话,那么select就是列表了，不是下拉菜单；不设置是下拉菜单，所以代码实现了一个列表。  
multiple多选，size显示可见选项数目。
```html
<select name="" id="">
<option value="" selected(设置默认值)> </option>
<option value="" > </option>
<option value="" > </option>
</select>
textarea：文本域
<style>
textarea{
resize:none;(使其没有可拖拽能力）
}
<textarea rows=""(决定有几行高) cols=""(决定有多宽）> 。。。。。（默认值） </textarea>
button：按钮
<button type=""(可以指明三个值 1、button 普通按钮 2、submit 带提交行为 3、reset 重置） form="(此处应该是表单的name) ">提交（设置名字）</button>
```
### 总结  
![HTML总结](https://img.mukewang.com/climg/5aabfbff000174ce12800720.jpg)