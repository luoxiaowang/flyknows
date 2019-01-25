title: "前端工具系列-Gulp"
date: 2016-01-03 16:57:10
categories: 前端工具
tags: [前端工具]
---
本文主要介绍前端开发过程中如何使用Gulp及Gulp的一些插件的使用。
<!--more-->
### Gulp和Grunt的区别
* Gulp采用一种管道的写法，在写法上比Grunt要容易并且更加的直观，写起来更像是在写代码，而Grunt更像是在写各种配置文件。
* Gulp的插件比Grunt的要少，且多为第三方插件，而Grunt官方插件会比较多，文档齐全。
* Gulp的每个插件只完成一个功能，这也是Unix的设计原则之一，各个功能通过流进行整合并完成复杂的任务。
* Gulp相比Grunt更有设计感，核心设计基于Unix流的概念，通过管道连接，不需要写中间文件

### Gulp的安装
和Grunt一样，首先我们需要node.js的环境，这里如何安装就不多说了，node安装好了之后，我们就可以开始安装gulp了：
```
npm install gulp -g
npm install gulp --save-dev
```
gulp需要先在全局进行安装，然后我们再到自己的项目根目录去安装gulp模块，通过`--save-dev`的方式同时写入到`package.json`文件中去。安装其他任务模块也很简单：
```
$ npm install --save-dev gulp-uglify
```

### gulpfile.js
和Grunt一样，Gulp也需要有这样的一个文件，我们就在这个文件中去配置各种自动化任务。首先我们来看一个简单的任务创建：
```javascript
var gulp = require('gulp');
var uglify = require('gulp-uglify');

var watcher = gulp.watch(['js/**/*.js', '!js/**/*.min.js'], ['minify']);

watcher.on('change', function (event) {
   console.log('Event type: ' + event.type);
   console.log('Event path: ' + event.path);
});

gulp.task('init', ['style', 'templates']);

gulp.task('minify',['init'], function () {
  gulp.src(['js/**/*.js', '!js/**/*.min.js'])
    .pipe(uglify())
    .pipe(gulp.dest('./build/templates'))
});
```
`require`的方式加载了`gulp`及`gulp-uglify`两个模块，然后我们开始定制我们的任务。
`gulp.task()`方法创建一个任务，第一个参数为任务名称，第二个参数为一个函数，我们就在函数里面进行操作。如果一个任务依赖于前一个任务，那么可以再加个一个参数，这个参数是一个数组，数组里面就是任务名。这里会等到`init`任务执行完成后再执行后面的回调。或者像init任务那样，定义多个操作，但是它们是并行的。如果一个任务名称为`default`，则直接可以执行`gulp`去运行，否则需要加上任务名`gulp minify`执行任务。
`gulp.src()`指定我们所有要处理的文件，这里的参数可以是某个文件，也可以是个数组。
`pipe()`方法用来将上一个任务处理的输出转换为当前的输入，进行链式的操作。
`task`中调用了两次`pipe()`,代表了我们执行了两个任务操作，第一个是用`uglify()`压缩源码，第二个是用gulp自带的    `dest()`方法将上一步的输出写入本地文件夹`./build/templates`中，如果目录不存在则会新建。
`watch()`方法用来执行监听，是gulp自带的方法，grunt需要处理监听需要安装另外的插件。第一个参数为数组或者字符串，是需要监听的文件。第二个参数是执行任务的数组。当监听的文件发生改变后，会触发change事件，执行相应的函数。

**watch方法还可能触发以下事件：**
* end：回调函数运行完毕时触发。
* error：发生错误时触发。
* ready：当开始监听文件时触发。
* nomatch：没有匹配的监听文件时触发。

**watcher对象还包含其他一些方法：**
* watcher.end()：停止watcher对象，不会再调用任务或回调函数。
* watcher.files()：返回watcher对象监视的文件。
* watcher.add(glob)：增加所要监视的文件，它还可以附件第二个参数，表示回调函数。
* watcher.remove(filepath)：从watcher对象中移走一个监视的文件。

### 常用模块设置
#### 1.gulp-load-plugins
使用gulp-load-plugins模块，可以加载package.json文件中所有的gulp模块，不用单独去require每个模块。
```javascript
var gulp = require('gulp'),
    gulpLoadPlugins = require('gulp-load-plugins'),
    plugins = gulpLoadPlugins();

gulp.task('js', function () {
   return gulp.src('js/*.js')
      .pipe(plugins.jshint())
      .pipe(plugins.jshint.reporter('default'))
      .pipe(plugins.uglify())
      .pipe(plugins.concat('app.js'))
      .pipe(gulp.dest('build'));
});
```

#### 2.gulp-server-livereload
```javascript
var gulp = require('gulp');
var server = require('gulp-server-livereload');

/**
 * 启动本地服务器 , 自动刷新
 */
gulp.task('webserver', ['init'], function () {
    gulp.src('./')
        .pipe(server({
            port: 3000,
            livereload: {
                enable: true,
                filter: function (fileName, cb) {
                    var reg = /\.idea|\.git|DS_Store/ig;
                    cb(!(reg.test(fileName)));
                }
            },
            directoryListing: true
        }));
});
```

#### 3.gulp-less
```javascript
var gulp = require('gulp');
var less = require('gulp-less');
var sourcemaps = require('gulp-sourcemaps');
/**
 * 编译less
 */
gulp.task('style', function () {
    return gulp.src('./less/*.less')
        .pipe(sourcemaps.init())
        .pipe(less())
        .pipe(sourcemaps.write('./maps'))
        .pipe(gulp.dest('./css'));
});
```

#### 4.gulp-nunjucks-html
```javascript
/**
 * 编译nunjucks模板
 */
var nunjucks = require('gulp-nunjucks-html');
 
gulp.task('templates', function () {
    var nunjucksOpts = {
        searchPaths: ['./pages/']
    };
    gulp.src('./pages/*.html')
        .pipe(nunjucks(nunjucksOpts))
        .pipe(gulp.dest('./'));
    gulp.src('./pages/tabspage/*.html')
        .pipe(nunjucks(nunjucksOpts))
        .pipe(gulp.dest('./tabspage'));
});
```

#### 5.gulp-minify-css
```javascript
var minifyCSS = require('gulp-minify-css');

gulp.task('build', function () {
    gulp.src('./css/*.css').pipe(minifyCSS()).pipe(gulp.dest('./build/css/'));
});
```

#### 6.gulp-clean
```javascript
/**
    * 清除编译的文件
    */
    gulp.task('clean', function () {
        gulp.src(['./css', './*.html','./tabspage', './build'], {read: false})
        .pipe(clean());
});
```
