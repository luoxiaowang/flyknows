title: "前端工具系列-Bower"
date: 2016-01-03 17:00:10
categories: 前端工具
tags: [前端工具]
---
本文主要介绍前端开发过程中如何对包进行管理，以及Bower在前端开发中的运用。
<!--more-->
### 为什么使用Bower
Bower是一个客户端技术的软件包管理器，通过它我们可以节省很多的时间在包的管理上。例如，项目要用上jquery，这个时候也许你就会去下载一个jquery的库，或者去网上去搜索各种jquery的CDN链接，如果还需要一个bootstrap呢？这个时候Bower的优势就体现出来了。

### Bower能做些什么
* 我们可以很方便的通过`bower install xxx`去安装我们想依赖的库文件，bower会自动帮我们去下载
* 只要我们下载过某个包，当我们处于离线模式下的时候，依旧可以install这些包，因为bower会在用户的主目录下去新建一个.bower的文件夹，这个文件夹下会存储下载好的资源，接触过Maven的应该很能够理解，下次在使用这些已经下载好的包的时候，会直接去该目录下去下载，当然你也可以对这些包进行升级。
* 很容易的展现客户端的依赖关系，通过`bower init`我们可以创建一个名为bower.json的文件，这个文件里面可以很清晰的看到我们依赖了哪些库文件，并且在任何一个地方，我们都可以通过这个json文件去安装好客户端所有的依赖。这和node的package.json很像。

### 如何安装bower
* 首先我们应该安装`node.js`，node.js中会自带`npm`也就是node程序包管理器
* 安装git，你需要从git仓库获取一些代码包
* 在命令行中`npm install bower -g`将bower安装到我们的全局环境中
**完成以上这些步骤之后，我们的bower就算是安装好了**

### 使用bower
在一个项目中我们如何去使用bower？首先，我们需要在项目下去创建一个bower.json的文件，方便我们进行管理和查看。
```shell
bower init
```
输入以上命令，然后程序会需要你填入一些信息，不想输入则可以一路回车，最后会在你的项目路径下新建一个bower.json的文件。现在我们来安装一下jquery
```shell
bower install jquery --save
```
这样我们就可以看到我们的目录下回多出一个bower_components的文件夹，里面就是jquery的包文件，同时bower.json文件里面也会被写入jquery依赖的版本。这样下次直接执行`bower install`这样可以自动安装所有的依赖文件。

### 常用操作
查看所有包列表：
```shell
bower list
```

在线搜索包：
```shell
bower search jquery
```

查看包的详细信息(可以查看版本及包的依赖)：
```shell
bower info jquery
bower info jquery#2.1.4
```

包的卸载：
```shell
bower uninstall jquery
```

包的更新:
```shell
bower update jquery
```
