title: github上使用hexo创建个人blog
date: 2014-09-03 12:40:30
categories: 乱七八糟
tags: [乱七八糟]
---
本文主要介绍如何在github上面使用hexo搭建个人blog，以及一些基本操作和需要注意的地方。同时介绍了如何给自己的个人主页绑定顶级域名等。
<!--more-->
## 如何在本地搭建hexo环境
  首先搭建环境我们需要的是gitbash以及nodejs环境。这里就不介绍如何去安装这两个工具，同git操作不太熟悉的也可以看下这两个教程：
* [Git教程](http://www.liaoxuefeng.com/wiki/0013739516305929606dd18361248578c67b8067c8c017b000)
* [GitHub教程](http://www.worldhello.net/gotgithub/index.html)
这里默认大家安装好了这些环境，首先我们在任意地方右键打开gitbash，通过npm去安装hexo:
```bash
npm install -g hexo
```
之后我们在自己随便找个地方新建一个文件夹，文件夹名称任意(这里用“hexo”来命名)。然后进入文件夹右键打开gitbash，执行以下命令，hexo会在该文件夹下生成网站所需要的文件。
```bash
hexo init
```
安装完了之后可以发现我们的文件夹下面生成了很多的文件。然后安装依赖包:
```bash
npm install
```
到此我们本地的环境已经搭建完毕了，如何查看网站，我们可以通过以下命令生成静态页面然后在本地启动:
```bash
hexo g
hexo s
```
我们只需要在本地浏览器中输入地址：localhost:4000 就可以看到hexo的页面。

## 将hexo部署到github
首先在我们hexo文件夹根目录下有一个_config.yml文件,我们要对它进行修改，找到deploy这一项然后添加如下配置：
```bash
deploy:
  type: github
  repository: https://github.com/luoxiaowang/luoxiaowang.github.io.git
  branch: master
```
**注意：**一定要注意配置项":"与值之间是有空格的，如果格式出现错误会导致部署失败，切记!
以上是我的github配置，请自行修改名称。这些配置项完成之后，就可以执行命令将hexo部署到github上去了:
```bash
hexo clean
hexo g
hexo deploy
```
ok,访问地址就可以看到我们的网页了。
这里使用`hexo deploy`的时候可能会出现找不到git无法deploy的问题，这个时候可以通过以下的方法去解决：
1.`npm install hexo-deployer-git --save `
2.将deploy的type从github改为git

## hexo主题
如果不太喜欢默认的主题，我们也可以换个主题，首先我们可以到以下地址去选择一个主题：
[hexo主题](https://github.com/hexojs/hexo/wiki/Themes)
当我们选择了适合的主题之后怎么做呢？安装主题的方法就是一句git命令：
```bash
git clone https://github.com/heroicyang/hexo-theme-modernist.git themes/modernist
```
地址对应的是相应的主题的github地址。git会将主题clone到theme文件夹下,之后我们需要对_config.yml文件进行修改，找到theme配置将它修改成对应的主题名称：
```bash
theme: modernist
```
在对应的主题目录下也有一个_config.yml配置文件，可以对应的修改主题的一些信息,例如插件、导航链接等。之后执行命令：
```bash
cd themes/modernist
git pull
```

## 如何写文章
执行以下命令：
```bash
hexo new [layout] "postName" #新建文章
```
这里layout默认为post，有哪些layout呢？我们可以到hexo根目录下去找到scaffolds文件夹，你们就是layout的类型,也可以修改layout成为我们自己常用的模板。之后到source目录下去找到你新建的文章，通过markdown来进行书写了。

## 如何绑定域名
首先我们可以到Godaddy下去申请一个域名，然后在DNS配置处修改A记录(如果是顶级域名的话，否则修改CNAME即可),修改ip地址对应到github空间，github空间提供的地址为：
* 192.30.252.153
* 192.30.252.154
[github空间](https://help.github.com/articles/setting-up-a-custom-domain-with-github-pages)
然后到github的page页面根目录新建一个名为CNAME的文件，内容为申请的域名地址。之后等上30分钟左右再通过域名访问即可成功。