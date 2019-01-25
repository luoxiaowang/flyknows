title: "JS中数组slice,splice,split的区别"
date: 2016-07-17 12:34:10
categories: Javascript
tags: [Javascript]
---
本文主要说明一下js中slice,splice,split的区别。
<!--more-->
因为这几个函数长的实在太像，每次都会弄混淆它们的用法，这里简单的总结一下，也算是给自己提个醒。
### 1.slice
它的作用是基于当前数组中的一个或者多个，创建一个新的数组。当只有一个参数的时候，`返回指定位置到当前数组末尾位置的所有项`。如果两个参数，`返回起始位置和结束位置之间的项`，但是`不包括结束位置的项`。
```javascript
var arr = ["2","4","3","22","43"];
arr.slice(2);  //["3", "22", "43"]
arr.slice(1,4);  //["4", "3", "22"]
```

### 2.splice
该方法主要用途是像数组中部插入项，使用方法有三种：
* 删除
可以删除任意数量的项，只需要2个参数：要删除的第一项的位置和要删除的项数。
```javascript
var arr = ["2","4","3","22","43"];
var arr1 = arr.splice(2,1);  //["3"]
arr  //["2", "4", "22", "43"]
```
当只有一个参数时，IE下的表现形式为splice(index,0)，而标准浏览器下却表现为：如果删除数量不指定，则默认删除开始位置后面的所有元素。

* 插入
可以向指定位置插入任意数量的项，只需要提供3个参数：起始位置、0（要删除的项数）、要插入的项。
```javascript
var arr = ["2","4","3","22","43"];
arr.splice(1,0,"99","88");
arr //["2", "99", "88", "4", "3", "22", "43"]
```

* 替换
提供3个参数：起始位置，要删除的项数，要插入的项。
```javascript
var arr = ["2","4","3","22","43"];
arr.splice(1,2,"99","88");  //["4", "3"]
arr  //["2", "99", "88", "22", "43"]
```

### 3.split
根据特定的字符切割字符串并且返回生成的数组。
```javascript
var str = “s-aaa-sss-eee-www”;
targetArr = str.slite(“-”);    //[‘s’,’aaa’,’sss’,’eee’,’www’]
```

### 4.indexOf
该方法是用于查找位置的方法，两个参数分别是：要查找的项和查找起点位置的索引。
```javascript
var arr = ["2","4","3","22","43"];
arr.indexOf("3");  // 2
```

### 5.concat
基于当前所有项创建一个新数组。
```javascript
var arr = ["2","4","3","22","43"];
arr.concat("44",["34","54"]);  //["2", "4", "3", "22", "43", "44", "34", "54"]
```

### 6.sort
可对sort的排序方法进行重写：
```javascript
var value = [0,1,2,5,32,43];
value.sort(compare);
function compare(value1,value2){
    if(value1 < value2){
        return -1;
    }else if(value1 > value2){
        return 1
    }else{
        return 0;
    }
}
```

### 栈方法
push    pop:删除最后插入的一项，也就是末尾元素（返回删除的该项）

### 队列方法
push   shift:移除最先进去的一项，也就是第一项（返回删除的该项）
unshift:在数组的开始位置新增

### 检测数组
* arr instanceof Array

* Array.isArray(arr)

### 转换方法
* toString()／valueOf   转换成用逗号隔开的字符串

* join(",")  用分隔符切分数组为字符串