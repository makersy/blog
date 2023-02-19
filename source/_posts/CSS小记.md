---
title: CSS小记
date: 2018-11-23 23:29:01
tags: 
- 前端
- CSS 
categories:
- 前端
- CSS
---
以下是CSS的一些知识及语法。
<!-- more -->
#### 什么是CSS
css指**层叠样式表**（Cascading Style Sheets)  
样式通常存储在样式表中  
css可以统一不同浏览器显示的内容样式  
#### CSS使用目的
定义如何显示html元素
解决内容（html元素）与表现（浏览器中的呈现）分离的问题  

#### CSS基础语法
1. CSS声明：
- 样式属性：background-color
- 操作符: :
- 样式值：#FFFFFF
- 分隔符： ；

2. 声明块：同时使用多个声明语句
```css
{ 
background-color:#FFFFFF;
color:#000000;
}
```
3. CSS规则：
1.选择器：定位页面中的元素
2.声明块：由多个CSS声明组成，最外层{}，可以使用多个声明内容  

#### 定义CSS的两种方式：
内联样式方式、外联样式方式
- 内联样式方式：`<p style="color:lightcoral;font-weight:bolder;" ></p>`
内联方式设置样式只对当前标签有效
- 外联样式方式：
在style内通过元素选择器 设置元素的声明块。
此时相当于将CSS嵌入到HTML文件中。
```html
<!DOCSTYLE html>
<html>
<head>
<meta lang="en"/>
<title>定义CSS的样式</title>
<style>
p{
color:lightcoral;
font-weight:bolder;
}
</style>
</head>
<body>
<p style="font-weight:bolder;color:red;"> 这是内联样式1.</p>
<p style="size:small;color:yellow;"> 这是内联样式2.</p>
<p>这是外联样式</p>
</body>
</html>
```
注：若进行了内联样式，则其优先级更高。即外联样式声明了元素样式后，若该元素同时进行了内联样式声明，则依照内联样式显示。
#### CSS选择器：
- ID选择器（ # +id值）
- 元素选择器（直接使用元素名称）
- 类（class）选择器（ . + class名称）
- 属性选择器（中括号里面写属性名称，如[title]）
- 后代元素选择器
A E :  指定需要修改的元素E与A为**祖先和后代**关系
A>E :  指定需要修改的元素E与A为**父元素和子元素**关系
B+E :  指定需要修改的元素E为B的下一个**兄弟**元素
#### 伪类：
主要用于` <a> `标签。
a:link -- 链接的样式
a:hover -- 鼠标悬停时的样式
a:active -- 点击时的样式
a:visited -- 访问过后的样式
#### 伪元素
**::before** -- 为当前元素创建一个排在第一位的子元素。例q::before{ content:"<";}，会把页面中的引用标签`<q>`创建伪元素，把默认加的双引号变为<;
**::after** -- 为当前元素创建一个排在最后一位的子元素。例q::after {content:">";}，会把页面中的引用标签`<q>`创建伪元素，把默认加的双引号变为>.
#### CSS选择器优先级别
1、内联>外联
2、内联：id>类选择器>元素/伪类
3、在属性后加上：空格+!important让该属性升级为最高级别(会打乱默认的次序，少用)  
#### 背景
##### 属性  
**background**:简写属性，作用是将背景属性设置在一个声明中
**background-color**：设置元素的背景颜色
**background-image**:把图像设置为背景（通过url定位文件中的图片路径，将图片设置为背景）
**background-position**：设置背景图像的起始位置
**background-repeat**:设置背景图像是否及如何重复
因为p元素作为一个块级元素出现，它默认占到页面的整个宽度，即使文本内容很少，但它依旧会占到页面的整个宽度，所以背景图片会重复显示以填充所有区域内容
**background-repeat**:设置背景图像是否及如何重复
**repeat**:表示水平和垂直方向都是重复显示的
**no-repeat**:表示水平和垂直方向都是不重复显示的  
##### Tips：  
1. 无文本信息仅插入图片时，无法正常显示图片。这是由于未显示文本，导致分配的大小为：0，无法正常显示。此时需要手动设置 高height和宽width；
2. 需要显示部分图片时，可以通过更改 高height和宽width来调节显示图片的大小。高和宽的数值正负代表图片的移动方向，即：需要显示图片中某一块时，高和宽都是负值。  
#### CSS文本样式
color：设置字体颜色
text-align：文本水平对齐
text-decoration：向文本添加修饰
text-indent：文本首行缩进
vertical-align：文本垂直对齐

关于文本水平、垂直居中：[](https://www.cnblogs.com/huchong/p/7875127.html)  
#### 字体
font-family 指定文本的字体系列
font-size 指定文本的字体大小
font-style 指定文本的字体样式
font-weight 指定字体的粗细  

#### 列表与表格  
##### 列表
list-style 用于把所有用于列表的属性设置于一个声明中
list-style-image 把图像设置为列表项标志
list-style -type 设置列表项标志的类型
##### 表格
border 设置表格边框
border-collapse 设置边框是否被折叠成单个或隔开
width 定义表格的宽度
text-align 表格中文本对齐
padding 设置表格的填充(内边距)
##### CSS盒子模型  
- 内边距padding
padding： 使用缩写属性设置在一个声明中的所有填充属性
padding-bottom: 设置元素的底部填充
padding-left： 设置元素的左部填充
padding-right： 设置元素的右部填充
padding-top: 设置元素的顶部填充
注：
padding：全部
padding:上下 左右
padding：上 左右 下
padding：上 右 下 左  
- 外边距margin类似。
- 边框 border:10px black solid;
三个属性意思是：边框宽度 颜色 实/虚线  
- Tips：
1.内外边距和边框的使用会使当前盒子变大
2.内边距享有当前盒子背景色  

#### CSS定位机制
##### 普通流(标准流):
默认状态,从左往右, 从上到下排列
块元素：
1. 独占一行
2. 可以设置宽、高
3. 如果不设置宽度，宽度默认为容器的100%
4. div、p、h1-h6、ul、ol、li、dl、dt、dd(定义列表)  

行内元素
1. 与其他元素同行显示
2. 不可以设置宽、高
3. 宽高就是文字或图片的宽高
4. span、a、b、i、u、em......

##### 浮动
1. 只能使元素向左或向右移动, 不能上下移动
2. 浮动元素碰到包含框 或另一个浮动框, 浮动停止
3. 浮动元素之后的元素将围绕它, 之前的不受影响
4. 浮动会脱离标准流
浮动的基础语法
float:left
float:right
float:none
float:inherit 继承父类的浮动效果

**浮动的理解**  
浮动可以实现块级元素在一行中横向排列。浮动的原理是：当前的块从当前的容器里面脱离出来，虽然浮动后脱离了文档流（容器）但是文本流还在，还是会占据文本空间（这里带来的问题是：原来下一个块的内容可能会被浮动的内容占满 使该块本身的内容溢出）  
清除浮动是把浮动元素回归文档流, 撑起重启高度。  

**清除浮动语法**  
clear:none | left | right |both;
none: 不清除浮动
left: 清除该元素左边的浮动
right: 清除该元素右边的浮动
both: 清除所有浮动
inherit: 继承父类清除浮动的值  

**清除浮动常用的方法**
- 方法一：在浮动元素后使用一个空元素。
例如：`<div class="clear"></div>`  

- 方法二：给浮动元素的容器添加overflow：hidden;
可同时添加 `*zoom:1 /*触发hasLayout 兼容IE6、7*/`

- 方法三：使用CSS3的:after伪元素
```css
.clearfix:after{
content: ".";
display: block;
height: 0;
visibility: hidden;
clear: both;
}
.clearfix{*zoom:1; /*触发hasLayout 兼容IE6、7*/}
```
- 方法四：通过父级元素清除浮动 (较少使用)
1. 父级元素定义height。只适用于高度固定的布局。
2. 父级元素也一起浮动。不推荐, 会产生新的浮动问题。  

#### CSS定位  
position:既是一个定位布局模块（提供与元素定位和层叠相关功能，是一个核心模块，又是一个属性
模块内包含：
1. 盒子模型的类型和尺寸
2. 布局模型
3. 元素之间的关系
4. 视口大小、图像大小等其他相关方面  

重要的定位模型：
static ：静态模型/自然模型
relative：相对定位模型
absolute：绝对定位模型
fixed：固定定位模型
sticky：磁铁定位模型  

static：
作用：使元素定位于 常规/自然流 中
特点：
1. 忽略 top/bottom/left/right 或者z-inherit声明
2. 两个相邻的元素如果都设置外边距，最终外边距=两者外边距中最大的那个
3. 具有固定width和height值的元素，若把左右外边距设置为auto，则左右外边距会自动扩大占满剩余宽度。造成水平居中效果。  

relative：
作用: 使元素成为可定位的祖先元素
特点：  
1. 可以使用top/right/bottom/left/z-index相对于该元素的原位置进行偏移
2. 相对定位的元素，原来在标准流中的位置依旧保留，后面元素接在元素原位置之后
3. 任何元素都可设置relative, 它绝对定位的后代都可以相对它进行绝对定位
4. 可以使的浮动元素发生偏移，并控制它们的堆叠顺序  

absolute：
作用：使元素脱离常规流
特点：
1. 脱离常规流
2. 设置尺寸要注意：百分比比的是最近定位祖先元素
3. 若没有最近定位祖先元素，会以`<body>`为祖先元素
4. left/right/top/bottom若设置为0，它将对齐到最近定位祖先元素的各边，居中效果。
5. 若left/right/top/bottom设置为auto，它将会回归到常规流  

fixed ：
作用:  同absolute相同，使元素脱离常规流 
特点： 
1. fixed相对于视口(用户当前可见界面)做绝对定位
2. 固定定位元素不会随着视口滚动而滚动 
3. 继承absolute特点 （left/right/top/bottom若设置为0，它将对齐到最近定位祖先元素的各边，居中效果。 若left/right/top/bottom设置为auto，它将会回归到常规流）

sticky
磁铁定位/粘性定位/吸附定位
作用：relavtive+fixed的完美结合，制造出吸附效果
特点：
1. 如果产生偏移原位置还是会在常规流中，一亩三分地留着。
2. 如果它的最近祖元素有滚动，那么它的偏移标尺就是最近祖先元素
3. 如果最近祖先元素没有滚动 那么它的偏移标尺是视口。
4. 上下左右的偏移规则  

#### 总结  
**盒子模型**: 通过改变元素的margin和padding来控制元素的移动。
**定位**: 通过元素的位置移动改变出现在网页的相对位置。
先通过定位调整元素的大体位置, 再用盒子模型调整元素最后的位置