title: "Juicer前端模板引擎"
date: 2015-01-26 09:14:22
categories: 前端工具
tags: [前端工具]
---
本文将会介绍一款前端模板引擎，在实际开发工程中有效的使用前端模板引擎可以让我们代码看起来更加简洁，便于维护。
<!--more-->
### 前言
我们有这样的一个json数据：
```json
var json={
          name:"luoxiao",
          blog:"flyknows.info"
        };
```
我们希望将这样的json数据转换为下面这样的html:
```html
luoxiao (blog: flyknows.info)
```
如果是这样，我们会怎么做？可能就会写出这样的代码：
```html
var html;
html = json.name + "(blog:" + json.blog + ")";
```
很明显，这样的代码对于我们来说是非常不好维护,并且是不具有可读性的,我们可以这样去做:
```javascript
function sub(str,data) {
            var txt =  str
                .replace(/{(.*?)}/igm,function($,$1) {
                    return data[$1]?data[$1]:$;
                });
            return txt;
        }
```
定义这样的一个函数去模拟前端模板的解析:
```javascript
var tpl = "{name}(blog:{blog})";
var html = sub(tpl,json);
```
这样的话应该可以看到前端模板的好处了，不必写过多的逻辑去进行字符串的拼装，代码看起来具有较好的可读性且便于维护，正是为了简化我们这样的操作，前端模板引擎应运而生。

### Juicer前端模板引擎
Juicer 是一个高效、轻量的前端 (Javascript) 模板引擎，使用 Juicer 可以是你的代码实现数据和视图模型的分离(MVC)。 除此之外，它还可以在 Node.js 环境中运行。Juicer的网站是[http://juicer.name/](http://juicer.name/),上面的中文文档非常的详尽，使用起来也很简单。
只需要引入js文件就可以使用了：
```javascript
<script type="text/javascript" src="juicer-min.js"></script>
```

### 变量
之前的代码，我们使用Juicer来进行输出:
```javascript
<html>
  <head>
    <script type="text/javascript" src="juicer-min.js"></script>
    <script type="text/javascript">
      window.onload = function(){
        var json={
          name:"luoxiao",
          blog:"flyknows.info"
        };
        var tpl='${name} (blog: ${blog})';
        var html=juicer(tpl, json);
        console.log(html);
      }
    </script>
  </head>
  <body>
  </body>
</html>
```
如何使用自定义函数：
```javascript
  //定义json数据
        var json = {
            links: [{
                href: 'http://juicer.name',
                alt: 'Juicer'
            }, {
                href: 'http://benben.cc',
                alt: 'Benben'
            }, {
                href: 'http://ued.taobao.com',
                alt: 'Taobao UED'
            }]
        };
        // 模板结构,循环输出,使用“|”来使用自定义函数
        var tpl = [
            '{@each links as item}',
            '${item|links_build} <br />',
            '{@/each}'
        ].join('');

        //自定义函数
        var links = function(data) {
            return '<a href="' + data.href + '" alt="' + data.alt + '" />';
        };

        //注册自定义函数
        juicer.register('links_build', links); 
        var html = juicer(tpl, json);
        console.log(html);
```
可以看下输出的结果，很明显结果会被转义，那么如何避免被转义?
```javascript
var json = {
    value: '<strong>juicer</strong>'
};

var escape_tpl='${value}';
var unescape_tpl='$${value}';

juicer(escape_tpl, json); //输出 转义
juicer(unescape_tpl, json); //输出 为被转义
```

### 循环遍历
```javascript
{@each list as item, index}
  ${item.prop}
  ${index} //当前索引
{@/each}
```

### if判断
```javascript
{@each list as item,index}
    {@if index===3}
        the index is 3, the value is ${item.prop}
    {@else if index === 4}
        the index is 4, the value is ${item.prop}
    {@else}
        the index is not 3, the value is ${item.prop}
    {@/if}
{@/each}
```

### 注释
```javascript
{# 这里是注释内容}
```

### 完整的例子
```javascript
<script id="tpl" type="text/template">
    <ul>
        {@each list as it,index}
            <li>${it.name} (index: ${index})</li>
        {@/each}
        {@each blah as it}
            <li>
                num: ${it.num} <br />
                {@if it.num==3}
                    {@each it.inner as it2}
                        ${it2.time} <br />
                    {@/each}
                {@/if}
            </li>
        {@/each}
    </ul>
</script>

var data = {
    list: [
        {name:' guokai', show: true},
        {name:' benben', show: false},
        {name:' dierbaby', show: true}
    ],
    blah: [
        {num: 1},
        {num: 2},
        {num: 3, inner:[
            {'time': '15:00'},
            {'time': '16:00'},
            {'time': '17:00'},
            {'time': '18:00'}
        ]},
        {num: 4}
    ]
};

var tpl = document.getElementById('tpl').innerHTML;
var html = juicer(tpl, data);
```
