title: "Javascript模块化编程-简介"
date: 2016-01-04 22:56:10
categories: 前端工具
tags: [前端工具]
---
本文主要介绍js模块化的几种方式以及AMD与CMD的规范等。
<!--more-->
### 为什么要使用模块化?
当我们一个项目越做越大的时候，维护起来肯定没那么方便，且多人协作的去进行开发，当中肯定会遇到很多的问题，例如：
* **方法的覆盖**，很有可能你定义的一些函数会覆盖公共类中同名的函数，因为你可能根本就不知道公共类中有哪些函数，也不知道是如何命名的。
* **这些公共的组件**，但是你又不知道这些组件又会依赖哪些模块，同时在维护这些公共方法的时候，会新增一些依赖或者删除一些依赖，那么每个引入这些公共方法的地方都需要去对应的新增或者删除。等等，还会存在很多的问题。

我们使用模块化就是为了让各个模块之间相对独立，可能每个文件就是一个功能块，能满足于某项特定的功能，这样我们在引用某项功能的时候就会很方便。

### CommonJS
说到模块化不得不先提一下CommonJS，CommonJS就是帮助JS实现模块的功能，现在很热门的Node.js就是CommonJS规范的一个实现。CommonJS是服务器模块的规范，Node采用了这个规范。
CommonJS在模块中定义方法要借助一个全局变量exports，它用来生成当前模块的API：
```javascript
/* math module */

exports.add = function(a, b) {
  return a + b;
};
```
要加载模块就要使用CommonJS的一个全局方法require()。加载之前实现的math模块像这样：
```javascript
var math = require('math');
```
加载后math变量就是这个模块对象的一个引用，要调用模块中的方法就像调用普通对象的方法一样了：
```javascript
var math = require('math');
math.add(1, 3);
```
总之，CommonJS就是一个模块加载器，可以方便地对JavaScript代码进行模块化管理。但它也有缺点，它在设计之初并没有完全为浏览器环境考虑，浏览器环境的特点是所有的资源，不考虑本地缓存的因素，都需要从服务器端加载，加载的速度取决于网络速度，而CommonJS的模块加载过程是同步阻塞的。也就是说如果math模块体积很大，网速又不好的时候，整个程序便会停止，等待模块加载完成。

随着浏览器端JS资源的体积越来越庞大，阻塞给体验带来的不良影响也越来越严重，终于从，在CommonJS社区中有了不同的声音，AMD规范诞生了。

### AMD
说道模块化的话，大多数的同学都应该了解`RequireJS`，而且RequireJS是基于AMD规范的	。AMD是"Asynchronous Module Definition"的缩写，意思就是"异步模块定义"。它采用`异步方式`加载模块，模块的加载不影响它后面语句的运行。所有依赖这个模块的语句，都定义在一个`回调函数`中，等到加载完成之后，这个回调函数才会运行。
AMD也采用require()语句加载模块，但是不同于CommonJS，它要求两个参数：
```javascript
// require([module], callback)
require(['math'], function(math) {
  math.add(1, 3);
});
```
在回调函数中，可以通过math变量引用模块。AMD规范也规定了模块的定义规则，使用define()函数。
用AMD规范实现一个简单的模块可以这样：
```javascript
define(['myLib'], function(myLib){
　　　　function foo(){
　　　　　　myLib.doSomething();
　　　　}
　　　　return {
　　　　　　foo : foo
　　　　};
　　});
```
**为什么要使用AMD规范呢？**
因为AMD是专门为浏览器中js环境设计的规范。它吸取了CommonJS的一些优点，但是没有全部都照搬过来。也是非常容易上手。

### CMD
CMD在很多地方和AMD有相似之处，在这里我只说两者的不同点。首先，CMD规范和CommonJS规范是兼容的，相比AMD，它简单很多。遵循CMD规范的模块，可以在Node.js中运行。SeaJS是推荐是用CMD的写法，那么就使用SeaJS来编写一个简单的例子：
`greet.js：`
```javascript
define(function (require, exports) {
    function helloPython() {
        document.write("Hello,Python");
    }
    function helloJavaScript() {
        document.write("Hello,JavaScript");
    }
    exports.helloPython = helloPython;
    exports.helloJavaScript = helloJavaScript;
});
```
`index.html：`
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Document</title>
</head>
<body>
    <script src="http://apps.bdimg.com/libs/seajs/2.3.0/sea.js"></script>
    <script>
        seajs.use(['./greet'], function (Greet) {
            Greet.helloJavaScript()
        });
    </script>
</body>
</html>
```

### AMD与CMD的区别
* 对于依赖的模块，AMD是`提前执行`，CMD是`延迟执行`。不过 RequireJS从2.0开始，也改成可以延迟执行（根据写法不同，处理方式不同）。CMD 推崇as lazy as possible。
* CMD推崇`依赖就近`，AMD推崇`依赖前置`。
* AMD的API默认是一个当多个用，CMD的API 严格区分，推崇职责单一。比如AMD里，require分全局require 和局部require，都叫require。CMD里，没有全局 require，而是根据模块系统的完备性，提供seajs.use来实现模块系统的加载启动。CMD里，每个API都简单纯粹。

AMD的依赖需要前置书写
```javascript
define(['foo', 'bar'], function(foo, bar) {
  foo.add(1, 2);
  bar.subtract(3, 4);
});
```
CMD的依赖就近书写即可，不需要提前声明：
同步式：
```javascript
define(function(require, exports, module) {
  var foo = require('foo');
  foo.add(1, 2);
  ...
  var bar = require('bar');
  bar.subtract(3, 4);
});
```
异步式：
```javascript
define(function(require, exports, module) {
  ...
  require.async('math', function(math) {
    math.add(1, 2);
  });
  ...
});
```
CMD规范我们可以发现其API职责专一，例如同步加载和异步加载的API都分为require和require.async，而AMD的API比较多功能。

### ES6 Module
上面解决js模块化的方法都是使用第三方的库来解决的。但是欣慰的是，ES6帮我们解决了原生js能够不依赖第三方的库来使用模块解决方案。
> 历史上，JavaScript一直没有模块（module）体系，无法将一个大程序拆分成互相依赖的小文件，再用简单的方法拼装起来。其他语言都有这项功能，比如Ruby的require、Python的import，甚至就连CSS都有@import，但是JavaScript任何这方面的支持都没有，这对开发大型的、复杂的项目形成了巨大障碍。《ECMAScript 6 入门》 - 阮一峰

写一个小例子了解一下，又是新建两个文件a.js和b.js：
```javascript
// a.js

var num1 = 1;
var num2 = 2;

export {num1, num2};

// b.js
import {num1, num2} from './a.js';

function add(num1, num2) {
    return num1 + num2;
}

console.log(add(num1, num2));
```
因为使用到了ES6的语法，所以需要转码器来把代码转换成ES5的代码。只需要使用npm安装traceur就行了。
```javascript
npm install traceur -g
```
安装好之后，我们就通过traceur命令来运行b.js。就和Node运行js文件一样。
```javascript
traceur b.js
3 // 输出
```
**为什么要使用ES6 Module规范呢？**
不用依赖第三方的库来结局模块化的问题，语法简单简洁。上手简单。可能是未来模块化解决方案的首选。

### Browserify
Browserify本身不是模块管理器，只是让服务器端的CommonJS格式的模块可以运行在浏览器端。这意味着通过它，我们可以使用Node.js的npm模块管理器。所以，实际上，它等于间接为浏览器提供了npm的功能。它用了这样一个名字，让你觉得它好像只是一个Node的浏览器端转化工具。为此，它还完成了Node中大部分核心库的浏览器端实现。
首先安装Browserify：
```javascript
npm install Browserify -g
```
新建2个文件：
```javascript
//exports.js
module.exports = "luoxiao";

//import.js
var name = require("./exports");
console.log("hello " + name);
```
运行Browserify：
```javascript
browserify import.js -o bundle.js
```
最后再html中引入bundle.js文件即可：
```javascript
<script type="text/javascript" src="bundle.js"></script>
```
Browserify参照了Node中的模块系统，约定用require()来引入其他模块，用module.exports来引出模块。在我看来，Browserify不同于RequireJS和Sea.js的地方在于，它没有着力去提供一个“运行时”的模块加载器，而是强调进行`预编译`。预编译会带来一个额外的过程，但对应的，你也不再需要遵循一定规则去加一层包裹。因此，相比较而言，Browserify提供的组织方式更简洁，也更符合CommonJS规范。
写`Node`那样去组织你的JavaScript，Browserify会让它们在`浏览器`里正常运行的。
