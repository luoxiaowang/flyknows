title: "js浅拷贝与深拷贝"
date: 2015-12-07 20:08:10
categories: Javascript
tags: [Javascript]
---
本文主要说明一下如何使用浅拷贝和深拷贝来实现继承。
<!--more-->
### 1.浅拷贝
首先我们看一下简单的浅拷贝应该怎么做：
```javascript
　function extendCopy(p) {
　　　　var c = {};
　　　　for (var i in p) { 
　　　　　　c[i] = p[i];
　　　　}
　　　　return c;
　　}
```
使用的时候我们可以这么去写：
```javascript
var Chinese = {
　　nation:'中国'
};
var Doctor = extendCopy(Chinese);
Doctor.career = '医生';
alert(Doctor.nation); // 中国
```
这样看着好像我们确实拷贝出了一个对象，但是这样的拷贝会有一些问题存在，如果对象的属性中存在数组或者另一个对象的时候，那么我们拷贝的将只会是内存的地址而已，并不是真正的去拷贝，这个时候不管去修改父对象还是子对象，都会造成两个会被同时修改，因为我们拿到的只是一个地址的引用。
例如：
```javascript
Chinese.birthPlaces = ['北京','上海','香港'];
var Doctor = extendCopy(Chinese);
Doctor.birthPlaces.push('厦门');

alert(Doctor.birthPlaces); //北京, 上海, 香港, 厦门
alert(Chinese.birthPlaces); //北京, 上海, 香港, 厦门
```
从这里可以看出,浅拷贝只适用于基本类型的数据,如果存在引用类型的值的时候，还是应该采用深拷贝。

### 2.深拷贝
其实深拷贝和浅拷贝的原理都是一样的，不过只是需要对数组和对象这种类型的值进行递归调用即可。
```javascript
function deepCopy(p, c) {
　　　　var c = c || {};
　　　　for (var i in p) {
　　　　　　if (typeof p[i] === 'object') {
　　　　　　　　c[i] = (p[i].constructor === Array) ? [] : {};
　　　　　　　　deepCopy(p[i], c[i]);
　　　　　　} else {
　　　　　　　　　c[i] = p[i];
　　　　　　}
　　　　}
　　　　return c;
　　}
```
这样我们再去试一下：
```javascript
var Doctor = deepCopy(Chinese);
Chinese.birthPlaces = ['北京','上海','香港'];
Doctor.birthPlaces.push('厦门');

alert(Doctor.birthPlaces); //北京, 上海, 香港, 厦门
alert(Chinese.birthPlaces); //北京, 上海, 香港
```

