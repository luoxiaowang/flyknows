title: "cavas绘制标注框"
date: 2016-04-10 20:06:10
categories: 前端技术
tags: [前端技术]
---
项目中如何对图片来进行标注，使用cavas绘制标注框。
<!--more-->
1.首先用cavas来对图片进行展示：
```javascript
var canvas = document.getElementById('myCanvas');
        var context = canvas.getContext('2d');
        var img = new Image();
        img.onload = function() {
            //canvas.width = this.width;
            //canvas.height = this.height
            context.drawImage(this, 0, 0);
        };
        img.src = "http://pic.newssc.org/upload/news/20160403/1459681575327.jpg";
```
使用drawImage将图片绘制到cavas，可以设置cavas的宽度高度为图片的宽高。

2.根据坐标来对图片进行绘制：
```javascript
var paint = false;
        var mouseX = 0;
        var mouseY = 0;
        
        //鼠标按下
        $('#myCanvas').mousedown(function(e) {
            mouseX = e.pageX - this.offsetLeft;
            mouseY = e.pageY - this.offsetTop;

            paint = true;
        });

        //鼠标移动
        $('#myCanvas').mousemove(function(e) {
            if (paint) { //是不是按下了鼠标
              context.clearRect(0,0,canvas.width,canvas.height);
              context.drawImage(img, 0, 0);
              context.strokeStyle="red";  //边框颜色
            context.linewidth=10;
                context.strokeRect(mouseX,mouseY,e.pageX - this.offsetLeft - mouseX,e.pageY - this.offsetTop - mouseY);
            }
        });

        //鼠标松开
        $('#myCanvas').mouseup(function(e) {
            paint = false;
        });

        //鼠标移开事件
        $('#myCanvas').mouseleave(function(e) {
            paint = false;
        });
```
鼠标按下时纪录下点击的坐标值，移动时判断鼠标是否已经按下，判断是否为拖拽，每次拖拽，清空画布对当前位置进行绘制标注。
Demo:[CSS模态框](/example/2016-4/cavas绘制标注框.html)
