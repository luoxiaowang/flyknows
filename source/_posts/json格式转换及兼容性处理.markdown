title: "json格式转换及兼容性处理"
date: 2015-03-16 14:13:22
categories: Javascript
tags: [Javascript]
---
这里我们讨论下json与字符串的相互转换，以及json在低版本浏览器下的兼容性问题如何处理，同时也简单的说明了一下如何实现对象的深拷贝和浅拷贝。
<!--more-->
### 一、json字符串转换为json对象
``` javascript
var str = '{"name":"luoxiao"}'; //严格模式才能转换
                var json = JSON.parse(str); //字符串转换成json对象
                document.write(json.name);    //luoxiao
                document.write("<br/>");
```
注意：这里的json字符串必须为严格模式，使用JSON.parse来进行转换。

### 二、json对象转换成json字符串
```javascript
var json = {
                    name: "hello"
                };
                var str = JSON.stringify(json); //json对象转换为字符串
                document.write(str);  //{"name":"hello"}
                document.write("<br/>");  
```

### 三、对象浅拷贝
首先说一下什么是深拷贝，什么是浅拷贝，深拷贝就是如果其中的某个属性是对象的话，会一直遍历深入到对象内部去进行拷贝。而浅拷贝就会直接覆盖这个对象，不会去遍历对象的内部属性。那么这里我们看下对象的浅拷贝如何去实现：
```javascript
//浅拷贝
                var a = {
                    name: 'hello'
                }
                var b = {};
                for (var attr in a) {
                    b[attr] = a[attr];
                }
                b.name = "world";
                document.write(a.name);
                document.write("<br/>");  
```
从代码可以看出来，如果这里a对象里面还有其他的对象的话，那么那个对象不会继续被遍历，而是直接赋值给了b。

### 四、对象的深拷贝
```javascript
//深拷贝
        var a = {
                    name: 'hello'
                }
                var str = JSON.stringify(a);
                var b = JSON.parse(str);
                b.name = "what";
                document.write(a.name);
                document.write("<br/>");
                //引入json2.js  所有浏览器都兼容  
```
其实对象的深拷贝可以有很多种办法，一般会去判断一下属性的类型，然后进行遍历再做递归。这里我们使用的是另外一种方式，使用json转换这样的方法去进行拷贝，先转换成json字符串，然后将字符串转换为json对象，这样既不会直接把a赋值给b，又可以实现对象的深拷贝。

### 五、json转换兼容性问题处理
很明显，在低版本的浏览器中json转换是不被支持的，因此我们必须想想其他的方法去实现。我们可以引用json2.js这个库来使我们的低版本浏览器也支持上面的写法。但是如果我就是不想引入，又该如何解决呢？网上看到一篇文章，它说阿里就曾经有过这样的面试题：低版本浏览器如何兼容json对象？
我们可以参照一下下面这个地址，看下别人的解决办法：
[低版本浏览器如何兼容json对象？](http://www.cnblogs.com/bigbrother1984/p/4338669.html)
第一种方式：
```javascript
var str = '{"name": "cnblogs"}';
(new Function('return ' + str))();   //{name: "cnblogs"}
```
采用这样一种方式是可以实现json字符串转换为对象的。

第二种方式：
采用的是eval()这个函数去执行，但是写的方式却有些问题：
```javascript
var str = '{"name": "cnblogs"}';
eval(str);   //SyntaxError: Unexpected token :
```
说明一下错误的原因：
{}在js中存在几种用法：
* 对象：用于创建对象 var obj = {...}
* 代码块(code block): if(){...}

做个测试：
```javascript
{name:'luoxiao'}  //luoxiao
```
在console下打出来，显示的是字符串"luoxiao"，为什么？因为{}用于开头的时候，会被当做code block去处理，前面的name被当做了js的标记（label statement），而后面的就被当做了字符串，因此输出的就是一个字符串。所以之前上面的例子，name被加上了双引号，因此不会被当做是js的标记，字符串中又包括"："，因此会提示不合法。
再看个例子：
```javascript
var obj = {name:'luoxiao'};
obj   //Object {name:'luoxiao'}
```
这样输出的是个对象，因为"="运算符左右必须都是表达式，因此解析之后会被当做对象。
这里我们就可以使用这样一种方式去做，以解决这个问题：
```javascript
var str = '{"name": "cnblogs"}';
eval("("+str+")");  //{name:'cnblogs'}
```
转换为这样一个表达式以后就可以成功了。
这样的一些小点在ECMAScript里面都有说明，有时间多去看看，下面是ECMAScript5的汉化文档：
[ECMAScript](http://www.w3.org/html/ig/zh/wiki/ES5)