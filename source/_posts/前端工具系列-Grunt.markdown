title: "前端工具系列-Grunt"
date: 2016-01-03 16:49:10
categories: 前端工具
tags: [前端工具]
---
本文主要介绍前端开发过程中如何使用Grunt及Grunt的一些插件的使用。
<!--more-->
### 为什么使用Grunt
在我们一个前端的项目开发过程中，可能会遇到很多重复需要做的事情，例如：css、js的压缩，脚本文件的合并及混淆，less、sass文件的编译等等。这一系列的操作，每次上线或者转测试都需要去做一遍，那么可能我们每天要花20%左右的时间都在干这些重复的事情，并且很有可能漏掉或者忘记处理某些步骤。那么，我们是否想让这些重复的任务自动化的去进行操作呢？这就是为什么我们要使用Grunt。简单说，Grunt是一个自动任务运行器，会按照预先设定的顺序自动运行一系列的任务。这可以简化工作流程，减轻重复性工作带来的负担。

### Grunt的安装
首先，Grunt也依赖于node.js，所以我们先要安装node环境。之后我们就可以用NPM来进行Grunt的安装：
```shell
npm install grunt-cli -g
```
这样我们就可以在任何的目录下去执行`grunt`命令。注意，安装`grunt-cli`并不等于安装了 Grunt！`Grunt CLI`的任务很简单：调用与`Gruntfile`在同一目录中 Grunt。这样带来的好处是，允许你在同一个系统上同时安装多个版本的 Grunt。Grunt CLI的作用其实就是，在每次运行grunt的时候，会去利用node提供的require()方法去查找本地安装的grunt，如果找到一份本地安装的 Grunt，CLI就将其加载，并传递Gruntfile中的配置信息，然后执行你所指定的任务。
安装了grunt-cli之后，你可以手动建一个package.json文件，或者执行以下命令来创建一个package.json文件。
```shell
npm init
```
之后我们就可以在package.json下配置我们需要的插件等。或者直接通过命令来安装插件：
```shell
npm install grunt --save-dev
```
这样，我们的Grunt就真正的被安装到了项目中，之后我们就可以来配置自动化处理的插件了。

### 命令脚本文件Gruntfile.js
在项目的根目录下，我们新建一个`Gruntfile.js`文件，它是grunt的配置文件，我们的任务操作就写在这里。其实就是一般的node.js模块的写法：
```javascript
module.exports = function(grunt) {

  // 配置Grunt各种模块的参数
  grunt.initConfig({
    jshint: { /* jshint的参数 */ },
    concat: { /* concat的参数 */ },
    uglify: { /* uglify的参数 */ },
    watch:  { /* watch的参数 */ }
  });

  // 从node_modules目录加载模块文件
  grunt.loadNpmTasks('grunt-contrib-jshint');
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-watch');

  // 每行registerTask定义一个任务
  grunt.registerTask('default', ['jshint', 'concat', 'uglify']);
  grunt.registerTask('check', ['jshint']);
  grunt.registerTask('build', ['concat', 'uglify']);
};
```
* initConfig 是对每个模块进行配置，它接受一个对象作为参数。
* loadNpmTasks 方法载入模块文件，用到多少个就要写多少个，这里出现的模块必须要出现在package.json文件中，注意，如果在npm中删除了某个模块，那么该模块必须手动从Gruntfile.js文件中清除。
* registerTask接收2个参数，第一个是任务的名称，第二个是一个数组，代表要执行的任务，任务会按照顺序依次执行。
* 如果只执行`grunt`命令，则默认加载`default`下的配置，也可以直接`grunt concat`执行某个模块，或者`grunt check`执行某个任务。

### 常用模块设置
#### 1.grunt-contrib-connect
```javascript
		//静态服务器 自动刷新
        connect: {
            options: {
                port: 9999,
                hostname: '*',
                livereload: true
            },
            dev: {
                options: {}
            }
        }
```

#### 2.grunt-contrib-less
```javascript
		//less文件处理
        less: {
            compile: {
                options: {
                    // 是否压缩css
                    compress: false,
                    // 是否启用 source map
                    sourceMap: true,
                    sourceMapRootpath: "../"
                },
                files: [{
                    // 不一一指定目标文件
                    expand: true,
                    // 源目录
                    cwd: 'less/',
                    // 源文件后缀
                    src: '*.less',
                    // 目标路径
                    dest: 'css/',
                    // 目标后缀
                    ext: '.css'
                }]
            }
        }
```

#### 3.grunt-contrib-watch
```javascript
		// 监控文件变化
        watch: {
            livereload: {
                // 指定要监控的文件
                files: ['less/*', 'less/component/*', 'js/*', '*.html'],
                // less变动，立即编译
                tasks: ["less"],
                options: {
                    // 自动刷新浏览器
                    livereload: true
                }
            }
        }
```

#### 4.grunt-csscomb
```javascript
		//css属性排序
        csscomb: {
            mu: {
                expand: true,
                cwd: 'css/',
                src: ['*.css'],
                dest: 'css/',
                ext: '.css'
            }
        }
```

#### 5.grunt-contrib-clean
```javascript
		//清理文件
        clean: {
            build: {
                src: 'build/'
            }
        }
```

#### 6.grunt-contrib-copy
```javascript
		//复制文件
        copy: {
            main: {
                files: [{
                    expand: true,
                    src: ['js/*.js'],
                    dest: 'build/'
                }, {
                    expand: true,
                    src: ['css/*.css'],
                    dest: 'build/'
                }, {
                    expand: true,
                    src: ['images/*.*'],
                    dest: 'build/'
                }, {
                    expand: true,
                    src: ['pic/*.*'],
                    dest: 'build/'
                }, {
                    expand: true,
                    src: ['*.html'],
                    dest: 'build/'
                }]
            }
        }
```
