title: javascript高级程序设计-正则表达式应用
date: 2014-10-10 21:10:49
categories: Javascript
tags: [Javascript]
---
本文主要介绍js中正则表达式的基本应用。
<!--more-->

## 正则表达式的两种定义方式

1.使用字面量形式定义正则表达式
例如：
```javascript
var pattern1 = /.at/gi;
```
如果需要使用元字符则必须转义,例如：
```javascrpt
var pattern2 = /\[bc\]at/gi;
pattern2.test("[bc]At");  //返回true
pattern2.test("[bc]At");  //返回false
pattern2.test("[bc]At");  //返回true
```

2.使用构造函数的方式定义正则表达式
例如：
```javascript
var pattern3 = new RegExp("[bc]at","gi");
```
使用元字符则必须转义，例如：
```javascrpt
var pattern2 = new RegExp("\\[bc\\]at","gi");
```

## 构造函数方式转换为字面量形式toString()

```javascript
var pattern2 = new RegExp("\\[bc\\]at","gi");
pattern2.toString();  //返回"/\[bc\]at/gi"
```

## exec()用法

返回的结果为匹配正则表达式的数组，返回第一个匹配信息的数组,没有匹配则返回null,在设置了全局匹配的模式下，每次调用都会查找新的匹配项。
```javascript
var pattern3 = new RegExp("[bc]at","gi");
var result = pattern3.exec("cat,bat");
alert(result);  //返回"cat"
var result = pattern3.exec("cat,bat");
alert(result);  //返回"bat"
var result = pattern3.exec("cat,bat");
alert(result);  //返回"null"
var result = pattern3.exec("cat,bat");
alert(result);  //返回"cat"
```

## test()用法

模式与参数匹配的情况下返回true，否则返回false。
```javascript
var pattern1 = /.at/gi;
var result = pattern1.test("cat,bat");
alert(result); //返回true
var result = pattern1.test("cat,bat");
alert(result); //返回true
var result = pattern1.test("cat,bat");
alert(result); //返回false
var result = pattern1.test("cat,bat");
alert(result); //true
```