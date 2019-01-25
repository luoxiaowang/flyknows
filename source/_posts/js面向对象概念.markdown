title: "js面向对象概念"
date: 2015-09-09 15:07:22
categories: Javascript
tags: [Javascript]
---
本文简单的总结了一下作者在理解js面向对象过程中的一些重要的概念，便于日后回顾起来更加容易一些。
<!--more-->
### 对象的创建方式有两种：
* 创建一个Object实例的方式    
* 采用对象自变量语法，也是就用json的数据格式
```javascript
window.onload=function(){

	//创建一个Object实例的方式
	var obj = new Object();
	obj.name='luoxiao';
	obj.sayName = function(){
		document.write(this.name);
		document.write("<br/>");
	}
	obj.sayName();

	//采用对象自变量语法，也是就用json的数据格式
	obj = {
		name : 'wang',
		sayName : function(){
			document.write(this.name);
			document.write("<br/>");
		}
	}
	obj.sayName();
                    obj['name'];
}
```

### 访问数据属性的2种方式
* 使用“ . ”来访问对象属性，objectName.propertyName
* 使用“ [ ] ”来访问对象属性，objectName[propertyName]


### 两种属性：
* 数据属性
    * Configurable  能否通过delete删除属性从而重新定义属性，默认都为true
    * Enumerable  能否通过for-in循环返回属性
    * Writable  表示能否修改属性的值  一旦定义了false之后，就不能在修改为true，并且不能修改属性
    * Value   包含属性的数据值
```javascript
//Writable
	var person = {
		name : 'luoxiao'
	};
	Object.defineProperty(person , "name" , {
		writable : false,
		value :　'wang'
	});
	person.name = 'luoxiaowang';
	document.write(person.name);  //wang
	document.write("<br/>");
```
* 访问器属性
    * Configurable  能否通过delete删除属性从而重新定义属性。默认为true
    * Enumerable  能否通过for-in循环返回属性
    * Get   在读取属性的时候调用的函数
    * Set   在写入属性的时候调用的函数
```javascript
//Get    Set   用下划线的意思是，只能通过对象方法访问的属性，默认都为true。但是当调用defineProperty方法时候，默认就为false，例如下面，属性没有写在defineProperty里面，则默认就为true，调用set方法的时候可以修改其值
	var people = {
		_year : 2004,
		edition : 1
	}

	Object.defineProperty(people,"year",{
		get : function(){
			return this._year;
		},
		set : function(newYear){
			if(newYear > 2015){
				this._year = newYear;
				this.edition = newYear - 2015;
			}
		}
	})
	 document.write(people.year);
	 document.write("<br/>");
	 people.year = 2018;
	 document.write(people.edition);
	 document.write("<br/>");
```

### 定义多个属性
```javascript
//定义多个属性 , 默认都为true。但是当调用defineProperty方法时候，默认就为false,因此当属性定义在defineProperty里面的时候，一定要指定为true，否则set方法无法修改值
	 var book = {};
	 Object.defineProperties(book , {
	 	_year : {
	 		value : 2004,
	 		writable: true,
	        enumerable: true,
	        configurable: true
	 	},
	 	edition : {
	 		value : 1,
	 		writable: true,
	        enumerable: true,
	        configurable: true
	 	},
	 	year : {
	 		get : function(){
	 			return this._year;
	 		},
	 		set : function(newYear){
				if(newYear > 2015){
					this._year = newYear;
					this.edition = newYear - 2015;
				}
			}
	 	}
	 });
	 document.write(book.year);
	 document.write("<br/>");
	 book.year = 2018;
	 document.write(book.year);
	 document.write("<br/>");
	 document.write(book.edition);
	 document.write("<br/>");
```

### 工厂模式
```javascript
//工厂模式
	 function createPerson(name , age , job){
         // 原料
	 	var o = new Object();
        //加工
	 	o.name = name;
	 	o.age = age;
	 	o.job = job;
	 	o.sayName = function(){
	 		document.write(this.name);
	 		document.write("<br/>");
	 	};
        //出厂
	 	return o;
	 }

	 var person1 = createPerson("luoxiao",24,"ued");
	 var person2 = createPerson("wang",24,"bi");
	 person1.sayName();
	 person2.sayName();
```

### 构造函数模式
步骤：
1.创建一个新对象
2.将构造函数的作用域赋值给新的对象（this就指向这个新对象了）
3.执行构造函数中的代码（为这个新对象添加属性）
4.返回新对象
```javascript
//构造函数模式
 function Person(){
 	this.name=name;
 	this.age=age;
 	this.sayName = function(){
 		document.write(this.name);
 		document.write("<br/>");
 	}
 }
 var person1 = new Person("luoxiao",24);
 var person2 = new Person("wang",24);
```

### 原型模式（prototype）
* 使用原型模式是因为，如果使用构造函数每个方法都要都要在每个实例上重新创建一遍，消耗资源，而使用原型模式只需要在原型中指定函数，其他的实例通过指针去访问方法
* prototype是调用构造函数而创建的那个对象实例的原型对象，它可以让所有的对象和属性都共享它的属性和方法
* 一旦定义了原型属性或原型方法，则所有通过该构造函数实例化出来的所有对象，都继承了这些原型属性和原型方法，这是通过内部的_proto_链来实现的。
* 只要创建一个函数，就会为函数创建一个prototype属性，指向函数的原型对象
* 对象.prototype.constructor指向对象
* 当我们访问一个对象的属性的时候，先去对象实例本身去寻找，找不到再去原型对象中去寻找，因此会执行两次搜索
* 实例的属性和实例原型属性名称一致的时候，实例属性会覆盖原型的属性
* delete可以删除实例属性，让我们访问原型的属性
* 原型对象所做的任何修改都能立即从实例上反映出来，即使是先创建了实例后修改原型也如此。因为实例与原型之间的连接只是一个指针。
* 实例中的指针只指向原型，而不指向构造函数，如果先创建实例，之后一旦重写了prototype切断了联系，引用也不会改变，还是引用的最初的原型
* 原型对象的缺点是，在包含引用类型值（如数组）的属性来说，修改一个，其他的实例也会修改，因为共享的同一个属性，这个时候可以组合使用构造函数模式和原型模式
![](/image/2015-9/1.jpg "Optional title")

```javascript
// 原型模式
	 function Person(){

	 }
	 Person.prototype.name = "prototypeName";
	 Person.prototype.age = 26;
	 Person.prototype.sayName = function(){
	 	document.write(this.name);
	 	document.write("<br/>");
	 }
	 var person1 = new Person();
	 var person2 = new Person();	
	 person1.sayName();
	 person2.sayName();
```

```javascript
person1.constructor == Person.prototype.constructor
//true
```

```javascript
//判断是否指向原型对象isPrototypeOf
	 document.write(Person.prototype.isPrototypeOf(person1));  //true
	 document.write("<br/>");
```

```javascript
 //返回一个对象的对象原型getPrototypeOf
	 document.write(Object.getPrototypeOf(person1) == Person.prototype);  //true
	 document.write("<br/>");
	 document.write(Object.getPrototypeOf(person1).name);  //prototypeName
	 document.write("<br/>");
```

```javascript
//实例属性会覆盖原型的属性
	 person1.name = "objectName";
	 person1.sayName();
	 person2.sayName();
	 //delete可以删除实例属性，让我们访问原型的属性
	 delete person1.name;
	 person1.sayName();
```

```javascript
//判断一个属性是否存在于实例中hasOwnProperty
	 document.write(person1.hasOwnProperty("name"));  //false  存在于原型对象中
	 document.write("<br/>");
	 person1.name = "objectName";
	 document.write(person1.hasOwnProperty("name"));  //true   存在于实例中
	 document.write("<br/>");
```

```javacript
 //原型与in操作符   in操作符当对象能够访问给定属性的时候返回true，无论是实例中的还是原型中的
	 document.write("name" in person1);  //true   实例中的
	 document.write("<br/>");
	 document.write("age" in person1);  //true  原型中的
	 document.write("<br/>");
	 
	 //通过in和hasOwnProperty判断是否存在于原型中
	 function hasPrototypeProperty(obj,name){
	 	return !obj.hasOwnProperty(name) && (name in obj);
	 }
	 person1.name = "objectName";
	 document.write(hasPrototypeProperty(person1,"name")); //false
	 document.write("<br/>");
	 document.write(hasPrototypeProperty(person1,"age")); //true
	 document.write("<br/>");
```

```javascript
//返回一个包含可枚举属性的字符串数组  keys
	 document.write(Object.keys(Person.prototype));  //name,age,sayName
	 document.write("<br/>");
	 //返回所有实例的属性，无论是否可枚举 getOwnPropertyNames
	 document.write(Object.getOwnPropertyNames(Person.prototype));  //constructor,name,age,sayName
	 document.write("<br/>");
```

```javascript
//字面量方式的原型语法
	 function Person(){

	 }
	 Person.prototype = {
	 	name : "prototypeName",
	 	age : 26,
	 	satName : function(){
	 		document.write(this.name); 
	 		document.write("<br/>");
	 	}
	 }
```
使用这种方式可能导致一个问题：
每创建一个函数都会创建一个它的prototype对象，这个对象会自动获得constructor属性，但是字面量这种方式，完全重写了prototype对象，因此constructor属性就会指向Object构造函数，而不是指向Person函数，照成通过constructor无法确定对象的类型。
可以在字面量里面用：constructor:Person  来重新指定，但是又会导致Enumerable被设置成true，因为原生的Enumerable是为false的，因此可以通过defineProperty()重新设置：
```javascript
Object.defineProperty(Person.prototype,"constructor",{
    enumerable : false,
    value : Person
});
```
还有一个问题就是，属性全部写在prototype里面，那么所有的实例都会共享，对于引用类型的值会存在问题，所以推荐用下面的组合使用构造函数和原型模式。

### 组合使用构造函数和原型模式
```javascript
//组合使用构造函数和原型模式    构造函数用于定义实例属性，而原型模式用于定义方法和共享的属性
	 function Person(name,age){
	 	this.name=name;
	 	this.age=age;
	 	this.friends = ["luoxiao","wang"];
	 }
	 Person.prototype = {
	 	constructor : Person,
	 	sayName : function(){
	 		document.write(this.name); 
	 		document.write("<br/>");
	 	}
	 }
	 var person1 = new Person("luoxiao",24);
	 var person2 = new Person("wang",24);
	 person1.friends.push("luoxiao_wang");
	 document.write(person1.friends);  //luoxiao,wang,luoxiao_wang
	 document.write("<br/>");
	 document.write(person2.friends);  //luoxiao,wang
	 document.write("<br/>");
```

### 动态原型模式 
原理就是在构造方法里面初始化原型，判断任何一个需要使用原型的方法或者属性，在第一次构造函数初始化的时候执行初始化原型，它会共享给所有的实例，这样在之后所有实例构造的时候都不需要再次执行了。
```javascript
//动态原型模式    在构造函数中初始化原型
	  function People(name,age){
	 	this.name=name;
	 	this.age=age;
	 	if(typeof this.sayName != "function"){
	 		People.prototype.sayName = function(){
	 			document.write(this.name); 
	 			document.write("<br/>");
	 		}
	 	}
	 }
	  var people = new People("luoxiao",24);
	  people.sayName();
```

### 寄生构造函数模式
* 创建一个新的对象
* 增强该对象
* 返回对象

```javascript
//寄生构造函数模式
	  function SpecialArray(){
	  	//创建新对象
	  	var values = new Array();
	  	values.push.apply(values,arguments);
	  	//增强对象
	  	values.toPipedString = function(){
	  		return this.join("|");
	  	};
	  	//返回对象
	  	return values;
	  }

	  var colors = new SpecialArray("red","yellow","blue");
	  document.write(colors.toPipedString());
	  document.write("<br/>");  //red|yellow|blue
```