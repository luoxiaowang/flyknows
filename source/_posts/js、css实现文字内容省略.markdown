title: js、css实现文字内容省略
categories:
  - CSS
tags:
  - CSS
date: 2014-10-14 23:14:00
---
本文主要介绍如何分别通过CSS和js的方式实现，当文字超过一定宽度的时候，出现省略号的效果。
<!--more-->

## 1.通过text-overflow实现
### (1)单行缩略
```html
	#text_overflow_1 {
		width:200px;
		height: 50px;
		border: 1px solid;
		overflow:hidden; /*超出宽度部分的隐藏*/
		white-space:nowrap; /*文字不换行*/
		text-overflow:ellipsis; /*超出则...代替*/
		-o-text-overflow:ellipsis;  /*opera*/
	}

	<div id="text_overflow_1">
		这是一段测试文字，文章超出宽度时是否会隐藏多余的文字
	</div>
```
首先，我们将它的宽度限制在200px，white-space属性首先让文字不换行，然后overflow属性使其超出div宽度的内容隐藏不显示。text-overflow:ellipsis这个属性则可以实现我们所要的效果，在文字的后面加上... , 这种方式兼容主流浏览器，低版本的火狐可能不支持，需要用其他的方式去处理，这里就不说了。

### (2)多行缩略
```html
	#text_overflow_2 {
		display: -webkit-box;
		-webkit-box-orient: vertical;
		-Webkit-line-clamp: 3;
		text-overflow: ellipsis;
		overflow: hidden;
		word-break: break-all;
        line-height: 1.5;
	}
	
	<div id="text_overflow_2">
		这是一段测试文字，文章超出宽度时是否会隐藏多余的文字，这是一段测试文字，文章超出宽度时是否会隐藏多余的文字，这是一段测试文字，文章超出宽度时是否会隐藏多余的文字
	</div>
```

## 2.通过jQuery限制字符字数的方法实现
```javascript
function wordLimit(num){
	var maxwidth=num;
	if($(this).text().length>maxwidth){
		$(this).text($(this).text().substring(0,maxwidth));
		$(this).html($(this).html()+'...');
	}
}
```
这种方式是通过传最大长度限制显示的长度，截取字符串之后再最后加上省略号。个人感觉这种方式是最简单的。

## 3.使用cloneNode复制节点
```html
#text_overflow_3 {
		width:200px;
		height: 50px;
		border: 1px solid;
}

<div id="text_overflow_3">
		这是一段测试文字，文章超出宽度时是否会隐藏多余的文字
</div>
```
```javascript
(function($){
	$.fn.wordLimit = function(num){
		this.each(function(){	
			if(!num){
				var copyThis = $(this.cloneNode(true)).hide().css({
					'position': 'absolute',
					'width': 'auto',
					'overflow': 'visible'
				});	
				$(this).after(copyThis);
				if(copyThis.width()>$(this).width()){
					$(this).text($(this).text().substring(0,$(this).text().length-4));
					$(this).html($(this).html()+'...');
					copyThis.remove();
					$(this).wordLimit();
				}else{
					copyThis.remove(); //清除复制
					return;
				}	
			}else{
				var maxwidth=num;
				if($(this).text().length>maxwidth){
					$(this).text($(this).text().substring(0,maxwidth));
					$(this).html($(this).html()+'...');
				}
			}					 
		});
	}
})(jQuery);
```
将第二种实现方式和第三种实现方式结合在一起写个jquery插件，其实就是使用cloneNode去复制一个节点，然后将复制的节点的宽度与当前节点在css中定义的宽度进行比较，循环遍历，每次长度-4，因为还有3个省略号。当长度相等的时候则停止遍历。这个方法是在别人的blog上看到的。
其实还有很多的方法可以去实现，暂时就写这么多吧！