title: "阿里云上搭建node环境"
date: 2017-02-12 17:40:10
categories: nodejs
tags: [nodejs]
---
本文介绍一下如何在阿里云环境或者其他虚拟主机上如何搭建一个nodejs环境，并且启动服务以供访问。
<!--more-->
最近在学习nodejs+koa，本地环境实在不过瘾，就在阿里云上买了个ECS云服务器，但是感觉稍微还是有点贵的，所以下个月打算还是换到搬瓦工的VPS上去。之前也买过虚拟主机，用来鼓捣了一下php等，环境都是一键搭建好的，所以也没怎么接触一些linux命令、shell等等。好了，废话不多说，我们来试试。
### ssh连接主机
首先我们需要知道主机的公网ip及端口，还有用户名密码等信息，iTerm下输入：
```shell
ssh -t root@112.74.175.29 -p 22
//ssh -t 用户名@112.74.175.29 -p 端口
```
输入密码即可登录了。
但是每次如此登录，实在是麻烦，并且IP还得记下来，其实我们可以去给这个ssh建立一个别名，通过别名直接访问会简单很多。首先进入`~/.ssh/config`文件，没有则新建一个`touch config`，文件配置为：
```shell
# 服务器1
Host aliyun
    HostName 112.74.175.29
    Port 22
    User root
```
我们也可以通过`cat ~/.ssh/config`进行查看。配置完成之后就可以通过别名直接访问了`ssh aliyun`

### 安装nodejs
通过ssh登录以后我们可以通过linux的命令`yum install node`来对nodejs进行安装，如果yum的源比较老的话，可能需要对yum进行升级，或者直接对node进行升级。同时我们可以利用npm安装`n`，或者`nvm`来管理node的版本。

### 启动服务
我们先本地新建一个js文件，内容很简单，仅仅启动一个web服务器。
```javascript
var http = require("http");

http.createServer(function(request, response) {
	console.log("Request received.");
	response.writeHead(200, {
		"Content-Type": "text/plain"
	});
	response.write("Hello World");
	response.end();
}).listen(80);

console.log("Server has started");
```

如何上传到服务器呢？我们可以使用FTP工具，这里推荐Cyberduck，很方便，还可以远程编辑。当然我们也可以使用命令的方式进行上传：
```javascript
scp ./index.js root@112.74.175.29:~/luoxiao
//scp local_file remote_username@remote_ip:remote_folder  上传文件
//scp -r local_folder remote_username@remote_ip:remote_folder  上传文件夹
//从 远程 复制到 本地，只要将 从 本地 复制到 远程 的命令 的 后2个参数 调换顺序 即可；
```
文件上传后我们在目录下`npm run index`即可启动服务器，电脑通过公网IP或者绑定的域名即可访问。
但是当我们退出命令行之后，node服务就被中断无法访问了，这里我们可以使用`forever`或者`pm2`来守护进程，并且同时可以启动多个node服务，先安装一下`npm install forever -g`
```shell
forever start app.js          #启动
forever stop app.js           #关闭
forever list                  #列出启动的进程
forever start -l forever.log -o out.log -e err.log app.js   #输出日志和错误
```
这样就算我们退出也不会杀掉node进程了。