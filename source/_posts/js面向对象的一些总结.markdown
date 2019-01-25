title: "js面向对象的一些总结"
date: 2015-03-16 17:26:22
categories: Javascript
tags: [Javascript]
---
本文将会简单的介绍一下对象的几种创建方式，以及工厂方法，工厂方法的优缺点，以及对象继承等等知识点，这里我们只是大概的介绍一下，之后会有针对每个知识点细节的讲解。
<!--more-->
### 一、创建对象
对象的创建方式有两种：
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

访问数据属性的2种方式
* 使用“ . ”来访问对象属性，objectName.propertyName
* 使用“ [ ] ”来访问对象属性，objectName[propertyName]

### 二、工厂方式-创建对象
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
但是工厂方式有一个很大的缺陷，就是每创建一个对象，都会重新创建这个类里面的所有的属性和方法，这样是非常消耗内存的，因此我们需要对工厂方式进行改造：
```javascript
function Person(name, sex)
{
	this.name=name;
	this.sex=sex;
}

Person.prototype.showName=function ()
{
	alert(this.name);
};

Person.prototype.showSex=function ()
{
	alert(this.sex);
};

var p=new Person('blue', '男');

p.showName();
p.showSex();
```

通过这种方式，属性还是写在构造函数内部，我们把方法提取出来放到原型中去，这样所有的对象都共享这一个方法，不会浪费多余的内存空间，相当于我们的每个实例都保留了一个指向这个原型的指针，因此访问的都是一个方法，当然我们也可以把属性也放到原型中去。

### 三、如何将一个面向过程的控件效果改成一个面向对象的？
* 1.先把函数提出来
* 2.把用到的变量变成全局的
* 3.干掉window.onload让它变成构造函数，需要的参数进行传参
* 4.全局变量变成属性(this.name=)，函数变成方法  (对象.prototype.fun=function )
* 5.各个地方加this ， 事件上面应该用闭包(event = function(){})，保存this(_this=this)，因为作用域会改变
* 6.使用的时候到onload里面去new一个对象

现在我们将之前写的一个拖拽div的效果改成面向对象的：
**改造之前**:
```javascript
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
        "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title></title>
    <style>
        #div1 {
            width:100px;
            height: 100px;
            position: absolute;
            background: red;
        }
    </style>
    <script>
        window.onload = function(){
            var oDiv = document.getElementById("div1");
            //鼠标点击开始拖拽的位置 到 拖动元素左上角的 距离
            var disX = 0;
            var disY = 0;
            oDiv.onmousedown = function(ev){
                var oEvent = ev || event;
                //鼠标点击开始拖拽的位置 - 距离左边的距离 = 鼠标距离拖动元素左上角的距离
                disX = oEvent.clientX - oDiv.offsetLeft;
                disY = oEvent.clientY - oDiv.offsetTop;
                //用document绑定事件就是为了防止拖动太块导致鼠标拖出div了去了
                document.onmousemove = function(ev){
                    var oEvent = ev || event;
                    //鼠标当前的位置 - 距离 = div应该的位置
                    var l = oEvent.clientX - disX;
                    var t = oEvent.clientY - disY;
                    //页面高度
                    var dHeight = document.documentElement.clientHeight || document.body.clientHeight;
                    //页面宽度
                    var dWidth = document.documentElement.clientWidth || document.body.clientWidth;
                   //左边和右边不能超过页面边框
                    if(l<0){
                        l = 0;
                    }else if(l > dWidth - oDiv.offsetWidth){
                        //页面宽度 - div的宽度 = 右边不能超过的位置(否则会拖出去)
                        l = dWidth - oDiv.offsetWidth;
                    }
                    if(t < 0){
                        t = 0;
                    }else if(t > dHeight - oDiv.offsetHeight){
                        t = dHeight - oDiv.offsetHeight;
                    }
                    oDiv.style.left = l + "px";
                    oDiv.style.top = t + "px";
                }
                document.onmouseup = function(){
                    document.onmousemove = null;
                    document.onmouseup = null;
                }
                //阻止浏览器默认事件
                return false;
            }
        }
    </script>
</head>
<body>
<div id="div1"></div>
</body>
</html>
```
**改造之后：**
```javascript
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<style>
#div1 {width:100px; height:100px; background:red; position:absolute;}
#div2 {width:100px; height:100px; background:yellow; position:absolute;}
</style>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>无标题文档</title>
<script>
window.onload=function ()
{
	new Drag('div1');
	new Drag('div2');
};

function Drag(id)
{
	var _this=this;
	
	this.disX=0;
	this.disY=0;
	this.oDiv=document.getElementById(id);
	
	this.oDiv.onmousedown=function ()
	{
		_this.fnDown();
	};
}

Drag.prototype.fnDown=function (ev)
{
	var _this=this;
	var oEvent=ev||event;
	this.disX=oEvent.clientX-this.oDiv.offsetLeft;
	this.disY=oEvent.clientY-this.oDiv.offsetTop;
	
	document.onmousemove=function ()
	{
		_this.fnMove();
	};
	
	document.onmouseup=function ()
	{
		_this.fnUp();
	};
};

Drag.prototype.fnMove=function (ev)
{
	var oEvent=ev||event;
	
	this.oDiv.style.left=oEvent.clientX-this.disX+'px';
	this.oDiv.style.top=oEvent.clientY-this.disY+'px';
};

Drag.prototype.fnUp=function ()
{
	document.onmousemove=null;
	document.onmouseup=null;
};
</script>
</head>
<body>
<div id="div1">
</div>
<div id="div2">
asdf
</div>
</body>
</html>
```

### 四、对象继承
这里我们有一个Person的类：
```javascript
function Person(name, sex)
{
	this.name=name;
	this.sex=sex;
}

Person.prototype.showName=function ()
{
	alert(this.name);
};

Person.prototype.showSex=function ()
{
	alert(this.sex);
};
```
现在我们如何去继承它？我们当然不会把父类已经定义的属性全部再重写一遍，这里我们用到了call这个东西，call这个函数怎么用呢，其实它的作用就是改变函数在执行时的作用域，也就是改变函数执行过程中的this。那么我们这么去实现：
```javascript
function Worker(name, sex, job)
{
	//this->new出来的Worker对象
	//构造函数伪装		调用父级的构造函数——为了继承属性
	Person.call(this, name, sex);
	this.job=job;
}
//原型链		通过原型来继承父级的方法
Worker.prototype=Person.prototype;
Worker.prototype.showJob=function ()
{
    alert(this.job);
};
var oP=new Person('blue', '男');
var oW=new Worker('blue', '男', '打杂的');
```
这里我们通过Person.call去执行Person的构造函数，将this传给Person，改变Person的构造函数内部的this的作用域，那么Person的构造函数里面的this就会是Worker的实例。这样Worker就拥有了Person的属性，这种使用call的方式也叫做构造函数伪装。那么属性有了，方法该如何去继承呢?这里我们是直接将Person的原型赋值给Worker的原型，这样的确可以实现拷贝的功能，但是我们之前说过，这样传递的只是一个地址的引用，如果通过这种方式赋值的话，当Worker对象新加了一个showJob的方法的时候，父类Person对象也会同时拥有该方法。因此这样是不可行的，子类是不应该能改变父类的方法的。因此下面我们就会将其改成一种拷贝继承的方式：
```javascript
function Worker(name, sex, job)
{
	//this->new出来的Worker对象
	//构造函数伪装		调用父级的构造函数——为了继承属性
	Person.call(this, name, sex);
	this.job=job;
}
//原型链		通过原型来继承父级的方法
//Worker.prototype=Person.prototype;
for(var i in Person.prototype)
{
	Worker.prototype[i]=Person.prototype[i];
}
Worker.prototype.showJob=function ()
{
    alert(this.job);
};
var oP=new Person('blue', '男');
var oW=new Worker('blue', '男', '打杂的');
```
这里我们直接将父类的原型里面的方法全部遍历出来，然后赋值给子类的原型。这样他们会各自保有自己的方法，就算改变了子类的原型也不会对父类照成影响。当然，这样的拷贝方式只是浅拷贝。

### 五、拷贝继承的实例
对于之前的拖动div这个实例，我们将其进行一下改动，给它加一个现在，使它拖拽的时候不能拖出去。但是我们不想去改变之前的已有的效果，那么我们将会采用拷贝继承的方式重新生成一个实例。
```javascript
function LimitDrag(id)
{
	Drag.call(this, id);
}

//LimitDrag.prototype=Drag.prototype;

for(var i in Drag.prototype)
{
	LimitDrag.prototype[i]=Drag.prototype[i];
}

LimitDrag.prototype.fnMove=function (ev)
{
	var oEvent=ev||event;
	var l=oEvent.clientX-this.disX;
	var t=oEvent.clientY-this.disY;
	if(l<0)
	{
		l=0;
	}
	else if(l>document.documentElement.clientWidth-this.oDiv.offsetWidth)
	{
		l=document.documentElement.clientWidth-this.oDiv.offsetWidth;
	}
	if(t<0)
	{
		t=0;
	}
	else if(t>document.documentElement.clientHeight-this.oDiv.offsetHeight)
	{
		t=document.documentElement.clientHeight-this.oDiv.offsetHeight;
	}
	this.oDiv.style.left=l+'px';
	this.oDiv.style.top=t+'px';
};
```
这里我们通过拷贝继承在不改变父类的前提下，给子类新增了一个方法。

### 六、命名空间
一般我们在写这种面向对象的控件的时候，会用到命名空间，因为这样可以避免类名的重复以及覆盖，特别是当一个项目做大起来了之后，就特别需要避免这种问题：
```javascript
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>无标题文档</title>
<script>
var miaov={};
miaov.common={
	getByClass: function ()
	{
	},
	myAddEvent: function ()
	{
	}
};

miaov.fx={
	startMove: function ()
	{
	},
	drag: function ()
	{
	}
};
miaov.common.getByClass()
</script>
</head>
<body>
</body>
</html>
```
这次就说这么多了，之后会再对每一个知识概念进行具体的梳理，js的面向对象的内容还是挺多的，慢慢领悟！

