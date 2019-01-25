title: "关于move.js的一些吐槽"
date: 2015-03-09 16:24:22
categories: 前端技术
tags: [前端技术]
---
介绍一下使用move.js过程中的一些问题。
<!--more-->
### 前言
今天使用了一下move.js这个库，原本是想方便一点，不想写js的运动。但是在使用的过程中遇到了一些坑，并且都是官方文档里面都没有写出来的，用的非常的揪心。

### 关于引入move.js的问题
这里需要注意，move.js不能够在head里面去引入，否则会报错找不到move函数，如下：
![](/image/2015-3/1.jpg "Optional title")
就算是在window.onload事件里面去使用move函数，也还是会报错，最好是在使用move函数的那块上面再去引入就不会有问题了。

### 关于move.js中的set方法
move.js官方文档里面是这么使用set方法的：
```javascript
move('#example-1 .box')
  .set('margin-left', 200)
  .end();
```
按照同样的方法去使用，却怎么都没效果，然后将set换成了add之后，就可以运行，但是我要的并不是add的效果，因此去看了下move.js里面是怎么写的，下面是分别是set和add方法的实现：
```javascript
Move.prototype.set = function(prop, val){
  this.transition(prop);
  this._props[prop] = val;
  return this;
};
```

```javascript
Move.prototype.add = function(prop, val){
  if (!style) return;
  var self = this;
  return this.on('start', function(){
    var curr = parseInt(self.current(prop), 10);
    self.set(prop, curr + val + 'px');
  });
};
```
看了下，add的时候会curr + val + 'px'，而set方法是直接将值赋值了过去，估计有可能是这个导致的问题，然后将代码改成了这个：
```javascript
move('#example-1 .box')
  .set('margin-left', '200px')
  .end();
```
果然就没有问题了。但是，不知道官网那玩意是怎么运行的，下载下来的源码中的doc文档里面，这个set的例子也无法运行，必须要加上单位。

### 结尾
其他的方法也没怎么用到，也不知道还会不会存在什么问题，用到的时候再持续更新！