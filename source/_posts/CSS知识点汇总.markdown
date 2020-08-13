title: CSS知识点汇总
categories:
  - CSS
tags:
  - CSS
date: 2019-03-31 19:07:00
---
### CSS技术点

#### BFC
块级格式化上下文，BFC规定了内部的Block Box如何布局。

定位方案：
* 内部的Box会在垂直方向上一个接一个放置。
* Box垂直方向的距离由margin决定，属于同一个BFC的两个相邻Box的margin会发生重叠。
* 每个元素的margin box 的左边，与包含块border box的左边相接触。
* BFC的区域不会与float box重叠。
* BFC是页面上的一个隔离的独立容器，容器里面的子元素不会影响到外面的元素。
* 计算BFC的高度时，浮动元素也会参与计算。

满足下列条件之一就可触发BFC：
* float的值不为none（默认）
* overflow的值不为visible（默认）
* display的值为inline-block、table-cell、table-caption
* position的值为absolute或fixed

#### 标准的CSS的盒子模型？与低版本IE的盒子模型有什么不同的？
* 标准盒子模型：宽度=内容的宽度（content）+ border + padding + margin
* 低版本IE盒子模型：宽度=内容宽度（content+border+padding）+ margin

#### box-sizing属性
用来控制元素的盒子模型的解析模式，默认为content-box
* context-box：W3C的标准盒子模型，设置元素的 height/width 属性指的是content部分的高/宽
* border-box：IE传统盒子模型。设置元素的height/width属性指的是border + padding + content部分的高/宽

#### CSS选择器有哪些？哪些属性可以继承？
* CSS选择符：id选择器(#myid)、类选择器(.myclassname)、标签选择器(div, h1, p)、相邻选择器(h1 + p)、子选择器（ul > li）、后代选择器（li a）、通配符选择器（*）、属性选择器（a[rel="external"]）、伪类选择器（a:hover, li:nth-child）
* 可继承的属性：font-size, font-family, color
* 不可继承的样式：border, padding, margin, width, height
* 优先级（就近原则）：!important > [ id > class > tag ] 
* !important 比内联优先级高

#### CSS优先级算法如何计算？
* 元素标签选择符： 1
* class选择符： 10
* id选择符：100
选择器匹配从右到左，!important声明的样式优先级最高，如果冲突再进行计算。如果优先级相同，则选择最后出现的样式。继承得到的样式的优先级最低。

#### display有哪些值？
* inline（默认）--内联
* none--隐藏
* block--块显示
* table--表格显示
* list-item--项目列表
* inline-block

#### position的值？
* static（默认）：按照正常文档流进行排列；
* relative（相对定位）：不脱离文档流，参考自身静态位置通过 top, bottom, left, right 定位；
* absolute(绝对定位)：参考距其最近一个不为static的父级元素通过top, bottom, left, right 定位；
* fixed(固定定位)：所固定的参照对像是可视窗口。
* sticky(粘性布局)

#### CSS3有哪些新特性?
* RGBA和透明度
* background-image background-origin(content-box/padding-box/border-box) background-size background-repeat
* word-wrap（对长的不可分割单词换行）word-wrap：break-word
* 文字阴影：text-shadow： 5px 5px 5px #FF0000;（水平阴影，垂直阴影，模糊距离，阴影颜色）
* font-face属性：定义自己的字体
* 圆角（边框半径）：border-radius 属性用于创建圆角
* 边框图片：border-image: url(border.png) 30 30 round
* 盒阴影：box-shadow: 10px 10px 5px #888888
* 媒体查询：定义两套css，当浏览器的尺寸变化时会采用不同的属性

#### CSS3的flexbox（弹性盒布局模型）,以及适用场景?
该布局模型的目的是提供一种更加高效的方式来对容器中的条目进行布局、对齐和分配空间。在传统的布局方式中，block 布局是把块在垂直方向从上到下依次排列的；而 inline 布局则是在水平方向来排列。弹性盒布局并没有这样内在的方向限制，可以由开发人员自由操作。
试用场景：弹性布局适合于移动前端开发，在Android和ios上也完美支持。

#### 纯CSS创建一个三角形的原理是什么?

```css
width: 0;
height: 0;
border-top: 40px solid transparent;
border-left: 40px solid transparent;
border-right: 40px solid transparent;
border-bottom: 40px solid #ff0000;
```

#### 对长的英文进行强制换行？
`word-break: break-all`

#### 对文字强行一行显示？
`white-space: nowrap`

#### 浏览器是怎样解析CSS选择器的?
CSS选择器的解析是从右向左解析的。若从左向右的匹配，发现不符合规则，需要进行回溯，会损失很多性能。若从右向左匹配，先找到所有的最右节点，对于每一个节点，向上寻找其父节点直到找到根元素或满足条件的匹配规则，则结束这个分支的遍历。两种匹配规则的性能差别很大，是因为从右向左的匹配在第一步就筛选掉了大量的不符合条件的最右节点（叶子节点），而从左向右的匹配规则的性能都浪费在了失败的查找上面。

#### CSS优化、提高性能的方法有哪些？
* 避免过度约束
* 避免后代选择符
* 避免链式选择符
* 使用紧凑的语法
* 避免不必要的命名空间
* 避免不必要的重复
* 最好使用表示语义的名字。一个好的类名应该是描述他是什么而不是像什么
* 避免！important，可以选择其他选择器
* 尽可能的精简规则，你可以合并不同类里的重复规则

#### 全屏滚动的原理是什么？用到了CSS的哪些属性？
* 有点类似于轮播，整体的元素一直排列下去，假设有5个需要展示的全屏页面，那么高度是500%，只是展示100%，剩下的可以通过transform进行y轴定位，也可以通过margin-top实现
* `overflow：hidden；transition：all 1000ms ease；`

#### 怎么让Chrome支持小于12px 的文字？
`p{font-size:10px;-webkit-transform:scale(0.8);} //0.8是缩放比例`

#### 如果需要手动写动画，你认为最小时间间隔是多久，为什么？
多数显示器默认频率是60Hz，即1秒刷新60次，所以理论上最小间隔为1/60＊1000ms ＝ 16.7ms。这个情况下最好使用requestAnimationFrame

#### CSS属性overflow属性定义溢出元素内容区的内容会如何处理?
* 参数是scroll时候，必会出现滚动条。
* 参数是auto时候，子元素内容大于父元素时出现滚动条。
* 参数是visible时候，溢出的内容出现在父元素之外。
* 参数是hidden时候，溢出隐藏。

#### 水平居中？
* 行内元素：对父元素设置text-align:center;
* 定宽块状元素: 设置左右margin值为0 auto;
* 不定宽块状元素: absolute + left: 50% + margin-left: -50%或者transform: translateX(-50%)
* 通用方案: flex布局，对父元素设置display:flex;justify-content:center;

#### 垂直居中？
* 父元素一定，子元素为单行内联文本：设置父元素的height等于行高line-height
* 父元素一定，子元素为多行内联文本：设置父元素的display:table-cell或inline-block，再设置vertical-align:middle;
* 块状元素:设置子元素position:absolute 并设置top、bottom为0，父元素要设置定位为static以外的值，margin:auto;
* 不定高块状元素：absolute+translateY方式
* 通用方案: flex布局，给父元素设置{display:flex; align-items:center;}

#### 单行省略

```css
overflow: hidden;
text-overflow: ellipsis;
white-space: nowrap;
```

#### 多行省略

```css
display: -webkit-box;
-webkit-box-orient: vertical;
-webkit-line-clamp: 3;
overflow: hidden;
```

#### 参考文档
* https://segmentfault.com/a/1190000013860482
* https://segmentfault.com/a/1190000013325778
* https://zhuanlan.zhihu.com/p/25565751
* http://www.w3school.com.cn/css3/css3_animation.asp