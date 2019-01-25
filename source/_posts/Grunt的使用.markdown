title: "Grunt的使用"
date: 2015-01-15 14:32:22
categories: 前端工具
tags: [前端工具]
---
本文将会讲解一下grunt的基本使用方法。
<!--more-->
### Grunt安装
首先，我们需要先安装node的环境，因为Grunt是通过npm安装并管理的。node安装完之后，需要先安装Grunt命令行CLI，执行以下命令：
```cmd
npm install -g grunt-cli
```
执行完命令后，就可以在任何目录下使用grunt命令。之后要安装最新的Grunt
```cmd
npm install grunt --save-dev
```

### package.json
```json
{
  "name": "webqq",
  "version": "0.1.0",
  "devDependencies": {
    "grunt": "~0.4.5",
    "grunt-contrib-concat": "~0.3.0",
    "grunt-contrib-uglify": "~0.3.2"
  }
}
```
其中name是项目的名称，devDependencies是需要依赖的插件，这里除了grunt之外，添加了另外两个插件，一个是合并文件的插件，一个是压缩代码的插件，后面跟的是版本号。定义好了package.json之后，需要将插件引用到我们的项目中去，这时我们需要执行如下命令：
```cmd
npm install
```
这样就会安装项目依赖的库。

### Gruntfile
Gruntfile.js文件中将会去写我们需要执行哪些任务：

```javascript
module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    
    concat : {  //合并代码
      webQQ2 : { //项目名
        files : {
          'dist/main.js' : ['main.js','drag.js','scale.js']
        }
      }
    },

    uglify : {  //压缩代码
      webQQ2 : { //项目名
        files : {
           'dist/main.min.js' : ['main.js','drag.js','scale.js']
        }
      }
    }

  });
  // 加载包含 "concat、uglify" 任务的插件。
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-contrib-uglify');

  // 默认被执行的任务列表。
  grunt.registerTask('default', ['concat','uglify']);
};
```
之后再执行grunt命令，则会输出目标目录输出压缩和合并的文件