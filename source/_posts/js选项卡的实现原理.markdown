title: "js选项卡的实现原理"
date: 2015-03-05 15:38:22
categories: 前端技术
tags: [前端技术]
---
本文将会介绍一下，如何使用javascript来实现一个简单的选项卡，界面比较简单，只要把原理弄清楚就好。
<!--more-->
### 实现步骤
* 页面结构首先是按钮，其次是每个按钮对应的内容，给当前的按钮设置一个class样式
* 给每个按钮设置一个监听事件
* 点击按钮的时候，首先清除所有按钮的样式，以及将所有的内容隐藏
* 获取当前这个按钮的索引，给当前点击的按钮设置样式，同时显示当前按钮的索引值所对应的内容

### 代码分析
根据步骤一，写出对应的html结构:
```html
<body>
<div id="div1">
    <input class="active" type="button" value="教育" />
    <input type="button" value="培训" />
    <input type="button" value="招生" />
    <input type="button" value="出国" />
    <div style="display:block;">1111</div>
    <div>2222</div>
    <div>333</div>
    <div>4444</div>
</div>
</body>
```

<br/>

步骤二，设置样式
```css
<style>
#div1 .active {background:yellow;}
#div1 div {width:200px; height:200px; background:#CCC; border:1px solid #999; display:none;}
</style>
```

<br/>

步骤三，设置监听事件，并根据索引值进行相应的事件处理
```javascript
window.onload=function ()
{
    var oDiv=document.getElementById('div1');
    var aBtn=oDiv.getElementsByTagName('input');
    var aDiv=oDiv.getElementsByTagName('div');
    
    for(var i=0;i<aBtn.length;i++)
    {
        aBtn[i].index=i;
        aBtn[i].onclick=function ()
        {
            for(var i=0;i<aBtn.length;i++)
            {
                aBtn[i].className='';
                aDiv[i].style.display='none';
            }
            this.className='active';
            //alert(this.index);
            aDiv[this.index].style.display='block';
        };
    }
};
```

<br/>

### 在线实例：[选项卡](/example/2015-3/选项卡.html)