title: "学习如何发布包到npm"
date: 2017-02-10 00:45:10
categories: nodejs
tags: [nodejs]
---
本文主要介绍一下我们平时写的一些公共或者常用的包，如何发布的npm上，以供别人下载使用。
<!--more-->
在平时的开发过程中，用惯了第三方的npm包，有没有萌生一个自己发布一个的想法，今天就来介绍一下如何将自己封装的包文件上传到npm。
### 目录结构
首先，我们需要建立自己的包目录，一般会包含哪些文件和路径呢？
![](/image/2017-2/1.png "Optional title")
当然我们也可以使用较为简洁的方法，通过`npm init`来对目录进行初始化，在console下填写一堆信息后，会自动生成类似的目录结构。lib目录下一般放我们所用到的函数或各个模块，这里并不是重点，就不具体介绍了。根目录下一般会与一个`index.js`的文件,这是我们包的主入口文件，一般用来给外部暴露我们包所提供的接口方法。当然，你也可以不叫这个名字，这样需要我们到`package.json`中去指定了。
### package.json
`package.json`可以说是我们包的配置文件，根据你自己的情况进行配置，这里给出一个简单的写法：
```json
{
  "name": "node-echo-luoxiao",
  "main": "./index.js",
  "version": "1.0.3",
  "dependencies": {
    "argv": "0.0.2"
  }
}
```
* name是我们npm包的包名，这里上传的包名是不能重复的哦，所以赶紧抢先注册吧！
* version使我们的版本号，默认1.0.0，每次更新代码都需要更新一次版本号，这里要遵循一个规则，小的bug修复只用更新最后一位数字，大的改动才需要改第一个数字，没有更新版本号是没有办法发布上去的。
* dependencies为包的依赖，你提供的包里面也会用到第三方的包，这里需要列出来，以便于别人安装你的包的时候，也会一起安装你所依赖的包。
* main为我们指定了入口文件

### 发布npm包
第一步，注册用户名:
```javascript
npm adduser
```
这里按照指导填入用户名、密码、email。
第二步，登陆:
```shell
npm login
```
当然你有可能npm的资源为淘宝的镜像，也就是cnpm，如果这样的话我们需要指定源
```shell
npm login --registry http://registry.npmjs.org
```
我们可以通过命令来查看登陆的用户名称：
```shell
npm who am i
```
第三步，发布:
```shell
npm publish --registry http://registry.npmjs.org
```
这个步骤必须在你包目录下进行，发布成功之后就可以到https://npm.taobao.org下搜索到了。cnpm也会在几分钟之后同步过去。之后我们就可以在我们自己的项目中去根据包名进行install到我们的`node_modules`里。
```shell
npm install node-echo-luoxiao
```
项目中就可以直接使用了：
```javascript
var print = require("node-echo-luoxiao");
print.echo();
```
怎么样，是不是很简单，so easy，赶快尝试一下吧！
