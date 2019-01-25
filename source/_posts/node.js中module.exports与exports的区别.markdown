title: "node.js中module.exports与exports的区别"
date: 2017-02-07 14:27:10
categories: nodejs
tags: [nodejs]
---
本文主要介绍一下nodejs中module.exports与exports的区别以及如何去理解。
<!--more-->
在学习nodejs的时候对module.exports与exports有什么区别一直没弄清楚，今天看到一篇文章讲的很不错，然后自己动手实践了一下，终于算是能够理解二者的一些区别和用法。本文也以此作为基础,来对这两个概念进行讲解。<br/>
参考链接:[传送门](http://www.cnblogs.com/wbxjiayou/p/5767632.html)<br/>
### 二者关系
```javascript
exports = module.exports = {}
```
可以看出，exports其实就是module.exports的一个引用，你也可以理解成这样：
```javascript
var a = {};
var b = a;
a.name = 'hi';
console.log(b); // {name: 'hi'}
```

### module

首先module是一个对象，它是nodejs中Module类的一个实例，你可以理解成nodejs在我们的代码这中加了这么一段代码：
```javascript
var module = new Module();
var exports = module.exports;
```
这就是为什么你没有定义module和exprots但是却能使用的原因。Module类中有很多属性和方法，exports只是其中的一个属性，我们可以在控制台将其输出来看一下：
```javascirpt
Module {
  id: '.',
  exports: {},
  parent: null,
  filename: '/Users/luoxiao/学习/WEB前端开发/Node.js/Example/node入门/require引用模块/foo.js',
  loaded: false,
  children: [],
  paths: 
   [ '/Users/luoxiao/学习/WEB前端开发/Node.js/Example/node入门/require引用模块/node_modules',
     '/Users/luoxiao/学习/WEB前端开发/Node.js/Example/node入门/node_modules',
     '/Users/luoxiao/学习/WEB前端开发/Node.js/Example/node_modules',
     '/Users/luoxiao/学习/WEB前端开发/Node.js/node_modules',
     '/Users/luoxiao/学习/WEB前端开发/node_modules',
     '/Users/luoxiao/学习/node_modules',
     '/Users/luoxiao/node_modules',
     '/Users/node_modules',
     '/node_modules' ] }
```
可以看到初始化的时候module.exports是一个空对象。

### module.exports
之前说了module.exports是一个空对象，我们可以去给他添加方法或者属性：
```javascript
module.exports.a = "123";
module.exports.print = function(){console.log(12345)};
console.log(module);
console.log(exports);
```
你会看到Module中的exports属性已经有了print()方法和a属性,同时exports对象上也同样具有这个方法和属性。当然`module.exports可以到导出任何js对象`，例如：
```javascript
//rocker.js
module.exports = function(name, age) {
    this.name = name;
    this.age = age;
    this.about = function() {
        console.log(this.name +' is '+ this.age +' years old');
    };
};
//module.exports = 123 直接这样也是可以的
//demo.js
var Rocker = require('./rocker.js');
var r = new Rocker('Ozzy', 62);
r.about(); // Ozzy is 62 years old
```

### exports
因为exports是module.exports的引用，因此exports上的方法和属性也会在module.exports上。
```javascript
exports.name = '小白妹妹';
console.log(JSON.stringify(module.exports)); //{"name":"小白妹妹"}
```
看到这里想必对module.exports和exports的区别有些了解了，`当我们通过require去使用当前模块的时候，实际上得到的是module.exports对象`，当然返回的也可以是方法，这需要你去对module.exports进行赋值操作，但是这会导致exports的属性和方法全部失效。因此当两者混合使用的时候要尤其注意。

### 一些注意点
前面说过，尽量不要将两者去混合使用，否则可能会出现一些问题。在一起使用的时候我们需要去注意,正确的使用方法：
```javascript
exports.a = "123";
exports.say = function(){console.log(12345)};
module.exports.b = "234";
module.exports.print = function(){console.log(12345)};
```
错误的使用方法：
```javascript
module.exports = {
	name: "wang";
}
exports.a = "123"  //因为module.exports直接被赋值，所以a会丢失，require的是module.exports而不是exports
```
or
```javascript
exports = {age:10};
module.exports = {
	name: "wang";
}
//exports默认是module.exports的引用，然而已经被改变，所以导出的只有name
```

### 总结
* `不能在使用了exports.xxx之后，改变module.exports的指向`。因为exports.xxx添加的属性和方法并不存在于module.exports所指向的新对象中。
* 对于要导出的属性，`可以简单直接挂到exports对象上`
* 对于类，为了直接使导出的内容作为类的构造器`可以让调用者使用new操作符创建实例对象`，应该把构造函数挂到module.exports对象上，不要和导出属性值混在一起