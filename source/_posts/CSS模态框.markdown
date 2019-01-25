title: "CSS模态框"
date: 2015-01-27 09:34:22
categories: CSS
tags: [CSS]
---
本文将会描述一下如何用css制作模态弹窗。
<!--more-->
首先我们需要制作一个模态层，这个模态层需要遮挡住所有的内容,但是是透明的，模态层下面的内容不能操作。
```css
/**
     * 模态层
     */
    .floats {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: #000;
        opacity: 0.5;
        filter: alpha(opacity=50);
        display: none;
    }
```
这里我们用绝对布局，top和left都设置为0，同时宽度和高度设置为100%，使得整个页面被遮挡住，如何才能透明，这里关键就是要使用css的滤镜，在标准浏览器下使用：opacity: 0.5;  使得透明度变成50%，但是在IE下必须使用 filter: alpha(opacity=50);

之后去设置对话框，需要对话框的边框达到透明的效果，我们需要在对话框上在套一个父级的div，让它成为一个透明元素，实现方式和前面类似：
```css
.fatherAlert{
    	width: 420px;
        height: 220px;
        background: #8080C0;
        position: absolute;
        opacity: 0.5;
        filter: alpha(opacity=50);
        top: 50%;
        left: 50%;
        margin-top: -112px;
        margin-left: -212px;
        display: none;
        border-radius: 5px;
    }
```
之后再设置对话框：
```css
.alert {
        width: 400px;
        height: 200px;
        background: #fff;
        position: absolute;
        top: 50%;
        left: 50%;
        margin-top: -102px;
        margin-left: -202px;
        display: none;
    }
```
父级是透明元素，且宽度会多20px,则需要设置marin有10px的差距。如图所示：
![](/image/2015-1/5.jpg "Optional title")
这样一个基本的样式就完成了，这里所有的模态元素的display都为none，之后靠js事件去控制模态的展示就可以了。
[CSS模态框](/example/2015-1/CSS模态框/main.html)