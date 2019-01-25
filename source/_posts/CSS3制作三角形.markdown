title: "CSS3制作三角形"
date: 2015-01-13 11:11:22
categories: CSS
tags: [CSS]
---
本文将会讲解一下，如何通过CSS3来实现绘制一个三角形。
<!--more-->
### 1.首先我们来设置一个简单的div
```css
.triangle{
			    width:30px;
			    height:30px;
			    border-width:20px;
			    border-style:solid;
			    border-color:#e66161 #f3bb5b #94e24f #85bfda;
			}
```
这个div的宽度和高度分别是30px，同时border-width设置的20px，这个时候我们来看下它的样子:
![](/image/2015-1/1.jpg "Optional title")

### 2.设置div的宽度和高度都为0
```css
.triangle1{
			    width:0px;
			    height:0px;
			    border-width:20px;
			    border-style:solid;
			    border-color:#e66161 #f3bb5b #94e24f #85bfda;
			}
```
那么我们可以看到，当设置宽度和高度都为0px的时候，整个div就只剩下了border
![](/image/2015-1/2.jpg "Optional title")

### 3.我们将另外3个边框进行隐藏，这样就只剩下了一个边框，也就是我们需要的三角形
```css
.triangle2{
			    width:0px;
			    height:0px;
			    border-width:20px;
			    border-style:solid;
			    border-color:#e66161 transparent transparent transparent;
			}
```
![](/image/2015-1/3.jpg "Optional title")

### 4.三角同时可以用于给对话框添加样式
如图：
![](/image/2015-1/4.jpg "Optional title")
其实只是需要绝对定位一下就ok了