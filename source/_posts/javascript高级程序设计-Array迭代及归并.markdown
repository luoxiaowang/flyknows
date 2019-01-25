title: javascript高级程序设计-Array迭代及归并
date: 2014-09-10 22:56:10
categories: Javascript
tags: [Javascript]
---
本文主要介绍js中Array的5个迭代方法，以及2个归并方法，同时介绍几个遍历的方法。
<!--more-->
## 迭代方法
### every()
如果该函数对**每一项**都返回true，则返回true，否则返回false。
```javascript
var numbers = [1,2,3,4,3,2,1];
var everyResult = numbers.every(function(item,index,array){
	return (item > 2);
});
alert(everyResult);   //result为false
```

### some()
如果该函数对**任意一项**返回true，则返回true。
```javascript
var numbers = [1,2,3,4,3,2,1];
var everyResult = numbers.some(function(item,index,array){
	return (item > 2);
});
alert(everyResult);   //result为true
```

### filter()
该函数返回的是所有为ture的项组成的数组。 
```javascript
var numbers = [1,2,3,4,3,2,1];
var everyResult = numbers.filter(function(item,index,array){
	return (item > 2);
});
alert(everyResult);   //result为3,4,3
```

### map()
该函数返回函数调用结果组成的数组。
```javascript
var numbers = [1,2,3,4,3,2,1];
var everyResult = numbers.map(function(item,index,array){
	return (item * 2);
});
alert(everyResult);   //result为2,4,6,8,6,4,2
```

### forEach()
该函数只是用于遍历，没有返回值。
```javascript
var numbers = [1,2,3,4,3,2,1];
var everyResult = numbers.forEach(function(item,index,array){
	//执行某些操作
});
```

## 归并方法
### reduce()
从数组的**第一项**开始，迭代数组的所有项，构建一个最终的返回值。
```javascript
var numbers = [1,2,3,4,5];
var sum = numbers.reduce(function(prev,cur,index,array){
	return prev + cur;  //该结果会作为下一次迭代的prev
})
alert(sum);  //rusult为15
```

### reduceRight()
从数组的**最后一项**开始，迭代数组的所有项，构建一个最终的返回值。
```javascript
var numbers = [1,2,3,4,5];
var sum = numbers.reduceRight(function(prev,cur,index,array){
	return prev + cur;  //该结果会作为下一次迭代的prev
})
alert(sum);  //rusult为15
```

## 其他遍历方式
### for...in()
for...in也可以很方便的遍历数组和对象，遍历数组的时候获得的是下标，而遍历对象的时候获得的确是对象的key值。
```javascript
let arr = ["a","b","c"];

for(let item in arr){
    console.log(arr[item]);  // a b c
}

let obj = {
    name : "luoxiao",
    age : 18
}

for(let item in obj){
    console.log(item); // name  age  
}
```

### for...of()
for...of可以非常方便的遍历数组，它是es6新增的特性，当然它也可以用来遍历对象。
```javascript
let arr = ["a","b","c"];

for(let item of arr){
    console.log(item);  //a b c
}

let obj = {
    name : "luoxiao",
    age : 18
}

console.log(Object.keys(obj));  //["name", "age"]

for(var key of Object.keys(obj)){
    console.log(key +":"+ obj[key]);  //name:luoxiao    age:18
}
```