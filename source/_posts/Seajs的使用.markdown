title: "Seajs的使用"
date: 2015-01-16 15:17:22
categories: 前端工具
tags: [前端工具]
---
本文主要描述一下使用sea.js的好处，如何去使用sea.js进行模块化开发，以及grunt和sea.js的搭配使用。
<!--more-->
## 为什么要使用sea.js?
当我们一个项目越做越大的时候，维护起来肯定没那么方便，且多人协作的去进行开发，当中肯定会遇到很多的问题，例如：
* 方法的覆盖，很有可能你定义的一些函数会覆盖公共类中同名的函数，因为你可能根本就不知道公共类中有哪些函数，也不知道是如何命名的。
* 公共方法的维护，在项目中有很多的公共方法，例如模态框、弹窗等等，也许每个页面都会引入这些公共的组件，但是你又不知道这些组件又会依赖哪些模块，同时在维护这些公共方法的时候，会新增一些依赖或者删除一些依赖，那么每个引入这些公共方法的地方都需要去对应的新增或者删除。
等等，还会存在很多的问题。那么sea.js就是为了解决这些问题的。

## 使用sea.js的好处
* sea.js遵循CMD模块定义规范，和node.js模块规范非常相似，一个文件就是一个模块，每个模块通过exports向外提供接口，使用方引入需要的模块，调用相应模块的外部方法。这样不需要全局变量，方法之间不会有命名冲突。
* 依赖内置，引入依赖的时候，只需要关注自己需要的模块，维护成本降低。

## 如何使用sea.js
### 1.下载sea.js文件
我们可以在github上进行下载，里面提供了各个版本的sea.js文件，同时[http://seajs.org](http://seajs.org)上有很全面的使用文档，以供我们去进行学习。

### 2.在页面中引入sea.js文件
```javascript
<script type="text/javascript" src="./sea.js"></script>
```

### 3.如何去定义一个符合CMD规范的sea模块
这里我们去新建一个module1.js这个文件,代码如下:
```javascript
//变成sea的模块
define(function(require,exports,module){ //参数不能修改

	function show(){
		alert(1);
	}
	//exports对外提供接口的对象
	exports.show = show;
})
```
我们只需要将方法通过define进行包裹，这样就可以定义成一个sea模块，其中有三个参数，require用来获取或者说引用指定模块的接口,exports用来模块内部对外提供接口，module存储了模块的元数据的一些信息。
我们定义方法写在define里面，然后通过exports提供对外的接口，方便其他模块去进行调用。

### 4.引入其他模块
首先我们新建一个module3.js这个文件，里面提供一个变量。
```javascript
define(function(require,exports,module){
	var a = 100;
	exports.a=a;
})
```
这样我们把a这个变量通过exports提供出去，接着新建一个module2.js模块
```javascript
//变成sea的模块
define(function(require,exports,module){ //参数不能修改
	//require:模块之间依赖的接口
	var a = require("./module3.js").a;  //如果引入的是一个模块,则exports为返回的结果
	function show(){
		alert(a);
	}
	//exports对外提供接口的对象
	exports.show = show;
})
```
这里通过require去引入module3模块，返回的是该模块的exports对象，然后去调用a这个变量，就会得到它的结果,然后把这个结果也通过show方法，对外提供出去。

### 5.如何使用sea模块
这里我们新建一个sea.html页面：
```html
<html>
	<head>
		<script type="text/javascript" src="./sea.js"></script>
		<script type="text/javascript">
			//sea的默认以sea.js为目录路径
			seajs.use('./module1.js',function(ex){
				//回调函数的参数为exports
				ex.show();
			});

			seajs.use('./module2.js',function(ex){
				//回调函数的参数为exports
				ex.show();
			});
		</script>
	</head>
	<body>
	</body>
</html>
```
通过seajs.use()这个方法，传一个指定的路径去使用sea模块，这时候会有一个回调函数，回调函数的参数就是exports，通过exports就可以去调用相应的方法。这里我们去引用了两个模块，分别调用show方法，它们回去执行各自相应的show()方法，不会出现因为重名而造成方法的覆盖。这里就算再去页面里面去定义一个全局的show()方法，也不会有任何的影响。同时，我们也只需要去关注本模块的依赖，至于module2里面又去引入了module3，这个就不需要去关注了。这就是模块化给我们带来的好处。
当然上面的方法也可以简化的去写：
```javascript
<html>
	<head>
		<script type="text/javascript" src="./sea.js"></script>
		<script type="text/javascript">
			//sea的默认以sea.js为目录路径
			seajs.use(['./module1.js','./module2.js'],function(ex1,ex2){
				//回调函数的参数为exports
				ex1.show();
				ex2.show();
			});
		</script>
	</head>
	<body>
	</body>
</html>
```
这里也需要注意，seajs.use()里面传递的路径，是以sea.js这个文件所在的路径去寻找的。

### 6.sea.js中使用grunt构建
上一节我们介绍了如何使用grunt进行js的合并及压缩，那么在使用sea.js的项目中，我们对js进行合并压缩将会存在一些问题，因为当这些模块压缩在一起之后，通过require去进行调用的时候找不到相应的模块文件，这个时候我们需要使用这样一个插件：grunt-cmd-transport  , 同时的合并的插件也应该修改为符合CMD规范的，需要使用：grunt-cmd-concat
package.json及Gruntfile.js如下所示：
```json
{
  "name": "webQQ3",
  "version": "0.1.0",
  "devDependencies": {
    "grunt": "~0.4.5",
    "grunt-cmd-transport": "~0.3.0",
    "grunt-cmd-concat": "~0.2.7",
    "grunt-contrib-uglify": "~0.3.2",
    "grunt-contrib-clean" : "~0.6.0"
  }
}
```

```javascript
module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),

    transport : {
      webQQ3 : {
        files : {
          '.build' : ['main.js','drag.js','scale.js']
        }
      }
    },

    concat : {
      webQQ3 : {
        files : {
          'dist/main.js' : ['.build/main.js','.build/drag.js','.build/scale.js']
        }
      }
    },

    uglify:{
      webQQ3 : {
        files : {
           'dist/main.min.js' : ['dist/main.js']
        }
      }
    },

    clean: [".build"]

  });
  // 加载包含 "concat" 任务的插件。
  grunt.loadNpmTasks('grunt-cmd-concat');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-cmd-transport');
  grunt.loadNpmTasks('grunt-contrib-clean');

  // 默认被执行的任务列表。
  grunt.registerTask('default', ['transport','concat','uglify','clean']);
};
```
grunt-cmd-transport这个任务会递归目标js文件寻找所有以相对路径方式引用所依赖的模块，包括模块中嵌套引用的模块，接着对每一个模块进行id的生成和dependence的提取，最后把每一个模块生成到临时文件夹中（默认是当前目录的.build目录）。有依赖模块将会这样被提取，例如：
```javascript
define("main", [ "./drag", "./scale" ], function(require, exports, module) {
    var oInput = document.getElementById("input1");
    var oDiv1 = document.getElementById("div1");
    var oDiv2 = document.getElementById("div2");
    var oDiv3 = document.getElementById("div3");
    require("./drag").drag(oDiv3);
    oInput.onclick = function() {
        oDiv1.style.display = "block";
        require("./scale").scale(oDiv1, oDiv2);
    };
});
```
main是本模块，后面跟着一个数组，数组里面是依赖的模块文件。这样对sea.js模块进行grunt自动构建就没有问题了。不过在使用sea.js 2.3.0的时候，会有一些问题，页面无效果，但是修改成较为稳定的1.3.1的时候，就没有问题了。

