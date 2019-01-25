title: "Ajax传递数组的问题"
date: 2016-03-25 13:22:10
categories: 前端技术
tags: [前端技术]
---
本文主要介绍在ajax传递数组的时候遇到的一些问题和解决方案。
<!--more-->
项目中用ajax传递数组的时候，后台struts无法进行接收，当然，使用post的方式不会有这个问题，如果使用的是get方式，就会导致url拼接的时候参数有些变化，如下：
```javascript
$.ajax{
      url:"xxxx",
      data:{
            p: ["123", "456", "789"]
      }
}
```
请求的数组参数会变成这样子，因为jQuery需要调用jQuery.param序列化参数，默认的话，traditional为false，即jquery会深度序列化参数对象。
```javascript
p[]:123,
p[]:456,
p[]:789
```
遇到这种情况的解决方案其实也有很多：
1.可以采用将数组拼接成字符串的方式
2.ajax请求的时候加上`traditional : true` 这个参数，这样可以`阻止深度序列化`，结果如下：
```javascript
p:123,
p:456,
p:456,
```
也就是`p=123&p=456&p=456`。

扩展一下：jQuery.param
```javascript
var params = { width:1900, height:1200 };
var str = $.param(params);
$("#results").text(str);
//width=1900&height=1200
```



