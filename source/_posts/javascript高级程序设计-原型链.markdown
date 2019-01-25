title: " javascript高级程序设计-原型链"
date: 2016-01-06 12:34:10
categories: Javascript
tags: [Javascript]
---
由于之前对js原型链这块的知识点一直都很模糊，所以专门针对这块重新整理了一下相关的知识。
<!--more-->
### prototype与\__proto__
什么是prototype?我们很有可能把prototype与原型混淆起来，其实prototype是函数对象上一个预设属性。每个函数对象都会有这样一个属性，例如：Object.prototype可以这样去查看属性的值。prototype的值是一个对象，这个对象一般会有两个属性 ：分别是`constructor` 与`__proto__`。
其中constructor是指构造器，通过constructor.name可以获得当前函数对象的名称。`__proto__`指的是就是函数对象的原型了，一般函数对象的原型最后都会指向`Object.prototype`，所以我们总是可以在其他对象上使用Object对象上的toString（）和 hasPrototype（）方法等，不过最后他们的原型都会指向`null`。
通过new构造出来的对象的原型`__proto__`都是指向于对象`构造器`上的`prototype`属性。
如下图：
![](/image/2016-1/1.jpg "Optional title")

### 什么是原型链?
那么什么是原型链呢？ JS在创建对象（不论是普通对象还是函数对象）的时候，都有一个叫做`__proto__`的内置属性，用于指向创建它的函数对象的原型对象`prototype`，而被指向的这个对象也有`__proto__`属性，它指向创建它的函数对象（Object）的prototype，Object.prototype对象也有`__proto__`属性，但它比较特殊，为null。这样我们就通过原型将这些对象串成了一个链条，也就是我们所说的原型链。这样我们的对象就可以访问原型链上的任何属性方法。
例如：
```javascript
function Student(name,age){
  this.name = name;
  this.age = age;
}
```
那么这个时候Student.prototype 会得到一个对象，这个对象分别有constructor 和 `__proto__`这两个属性。
```javascript
Student.prototype.__proto__ === Object.prototype   //true
Object.prototype.__proto__ === null   //true
```
通过这个例子我们可以看到`Student->Object->null`这样的一个原型链。那么我们通过对象构建的实例又是如何表示的呢?
```javascript
var student = new Student();
student.constructor;   //Student(name, age)
student.constructor.prototype == Student.prototype;   //true
student.__proto__ == student.constructor.prototype;    //true
```
那么这个例子也印证了我们之前的结论：**通过new构造出来的对象的原型`__proto__`都是指向于对象`构造器`上的`prototype`属性。**


### 实现继承的方式
javascript中没有直接实现继承的方法，我们可以通过原型链的方式去实现这一特征：
```javascript
  function Person(name,age){
    this.name = name;
    this.age = age;
  }

  Person.prototype.hi = function(){
    console.log("hello myname is " + this.name);
  }

  Person.prototype.sleep = function(){
    console.log(this.name + " sleeping...");
  }

  Person.prototype.LEGS_NUM = 2;

  function Student(name,age,className){
    //通过call继承父元素属性的构造
    Person.call(this,name,age);
    this.className = className;
  }

  //Object.create的意思是创建一个空的对象，这个对象的原型指向传递的参数，也就是Person.prototype
  Student.prototype = Object.create(Person.prototype);
  //Student.prototype = Person.prototype;
  //Student.prototype = new Person();
  //改变prototype的时候constructor也被改变了，因此需要重新指回来
  Student.prototype.constructor = Student;

  Student.prototype.hi = function(){
    console.log("hello my name is " + this.name + " my className is " + this.className);
  }

  Student.prototype.study = function(){
    console.log(this.name + " studing....");
  }

  var luoxiao = new Student("lance.luo",24,"class1");

  luoxiao.hi();
  luoxiao.sleep();
  console.log("my legs_num is " + luoxiao.LEGS_NUM);
  luoxiao.study();
  /**
  hello my name is lance.luo my className is class1
  lance.luo sleeping...
  my legs_num is 2
  lance.luo studing....
  */
```
这里我们通过`Student.prototype = Object.create(Person.prototype);`这种方式去将Student的prototype的原型指向Person.prototype，这样形成一个原型链，那么Student就可以直接去访问Person在prototype上的方法，从而达到继承的概念。
如果我们通过`Student.prototype = Person.prototype;`的方式，而不是采用create的方式，输出的结果其实是一样的，但是这样会导致我们在Student的原型上添加的方法也会被添加到Person上去，但是事实上我们是不需要的，因此不要采用这样的方式去做。
当然我们也可以这么去做`Student.prototype = new Person();`但是似乎我们不知道该传什么参数给Person，看起来不那么优雅。这种方式也导致了超类构造函数会被调用两次，还有一次是在call的时候。
如下图：
![](/image/2016-1/2.jpg "Optional title")
不过Object.create（）方法是在ES5中才有的，所以不兼容一些低版本的浏览器，那么我们可以自己去简单的实现一个这个方法：
```javascript
if(!Object.create){
    Object.create = function(proto){
      function F(){}
      F.prototype = proto;
      return new F;
    };
  }
```

### 一些注意点
在上个例子中，我们做些修改：
```javascript
Student.prototype.x = 101;
luoxiao.x;  //101

Student.prototype = {y:2};
luoxiao.y;  //undefined
luoxiao.x;  //101

var wang = new Student("wangjinzhi",24,"class2");
wang.x;  //undefined
wang.y;  //2
```
这里我们定义了一个x属性，然后改变了Student的prototype的值，这个时候我们可以看到，直接修改prototype并不能影响已经创建了的对象原型指向的prototype，不过修改prototype中的某个属性的时候，是能够影响所有对象的。
如果这个时候重新创建一个实例，那么这个实例的原型指向的prototype值的改变就可以生效了。
