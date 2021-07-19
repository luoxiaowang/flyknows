title: web性能领域概要
author: luoxiao
tags:
  - 前端性能
categories: []
date: 2021-07-19 09:29:00
---
### web性能领域术语

#### FP（全称“First Paint”，翻译为“首次绘制”）
是时间线上的第一个“时间点”，它代表浏览器第一次向屏幕传输像素的时间，也就是页面在屏幕上首次发生视觉变化的时间。

#### FCP（全称“First Contentful Paint”，翻译为“首次内容绘制”）
顾名思义，它代表浏览器第一次向屏幕绘制 “内容”。

注意：只有首次绘制文本、图片（包含背景图）、非白色的canvas或SVG时才被算作FCP。
FP与FCP这两个指标之间的主要区别是：FP是当浏览器开始绘制内容到屏幕上的时候，只要在视觉上开始发生变化，无论是什么内容触发的视觉变化，在这一刻，这个时间点，叫做FP。

相比之下，FCP指的是浏览器首次绘制来自DOM的内容。例如：文本，图片，SVG，canvas元素等，这个时间点叫FCP。

FP和FCP可能是相同的时间，也可能是先FP后FCP。

#### FMP（全称“First Meaningful Paint”，翻译为“首次有效绘制”） 
表示页面的“主要内容”开始出现在屏幕上的时间点。它是我们测量用户加载体验的主要指标。

FMP本质上是通过一个算法来猜测某个时间点可能是FMP，所以有时候不准。

卡顿是人的一种视觉感受，比如我们滑动界面时，如果滑动不流程我们就会有卡顿的感觉，这种感觉我们需要有一个量化指标，在编程时如果开发的程序超过了这个指标我们认为其是卡顿的。

FPS（帧率）：每秒显示帧数（Frames per Second）。表示图形处理器每秒钟能够更新的次数。高的帧率可以得到更流畅、更逼真的动画。一般来说12fps大概类似手动快速翻动书籍的帧率，这明显是可以感知到不够顺滑的。30fps就是可以接受的，但是无法顺畅表现绚丽的画面内容。提升至60fps则可以明显提升交互感和逼真感，但是一般来说超过75fps就不容易察觉到有明显的流畅度提升了，如果是VR设备需要高于75fps，才可能消除眩晕的感觉。

开发app的性能目标就是保持60fps，这意味着每一帧你只有16ms≈1000/60的时间来处理所有的任务。


![upload successful](/images/pasted-3.png)

#### LCP（全称“Largest Contentful Paint”）
表示可视区“内容”最大的可见元素开始出现在屏幕上的时间点。

![upload successful](/images/pasted-4.png)

#### TTI（全称“Time to Interactive”，翻译为“可交互时间”） 
表示网页第一次 完全达到可交互状态 的时间点。可交互状态指的是页面上的UI组件是可以交互的（可以响应按钮的点击或在文本框输入文字等），不仅如此，此时主线程已经达到“流畅”的程度，主线程的任务均不超过50毫秒。TTI很重要，因为TTI可以让我们了解我们的产品需要多久可以真正达到“可用”的状态。

#### TTFB（全称“Time to First Byte”） 
表示浏览器接收第一个字节的时间

#### FCI（全称“First CPU Idle”）
是对TTI的一种补充，TTI可以告诉我们页面什么时候完全达到可用，但是我们不知道浏览器第一次可以响应用户输入是什么时候。我们不知道网页的“最小可交互时间”是多少，最小可交互时间是说网页的首屏已经达到了可交互的状态了，但整个页面可能还没达到。从名字也可以看出这个指标的意思，第一次CPU空闲，主线程空闲就代表可以接收用户的响应了。

更通俗的理解TTI与FCI的区别：FCI代表浏览器真正的第一次可以响应用户的输入，而TTI代表浏览器已经可以持续性的响应用户的输入。

#### FID（全称“First Input Delay”，翻译为“首次输入延迟”）
顾名思义，FID指的是用户首次与产品进行交互时，我们产品可以在多长时间给出反馈。TTI可以告诉我们网页什么时候可以开始流畅地响应用户的交互，但是如果用户在TTI的时间内，没有与网页产生交互，那么TTI其实是影响不到用户的，TTI是不需要用户参与的指标，但如果我们真的想知道TTI对用户的影响，我们需要FID。不同的用户可能会在TTI之前开始与网页产生交互，也可能在TTI之后才与网页产生交互。所以对于不同的用户它的FID是不同的。如果在TTI之前用户就已经与网页产生了交互，那么它的FID时间就比较长，而如果在TTI之后才第一次与网页产生交互，那么他的FID时间就短。

#### DCL 表示DomContentloaded事件触发的时间。
当纯HTML被完全加载以及解析时，DOMContentLoaded 事件会被触发，而不必等待样式表，图片或者子框架完成加载。

#### L 表示onLoad事件触发的时间。
DomContentloaded事件与onLoad事件的区别是，浏览器解析HTML这个操作完成后立刻触发DomContentloaded事件，而只有页面所有资源都加载完毕后（比如图片，CSS），才会触发onLoad事件。

#### Speed Index 
表示显示页面可见部分的平均时间（注意，是真正的可见，用户可以立马看见的，屏幕外的部分不算），数值越小说明速度越快，它主要用于测量页面内容在视觉上填充的速度。通常会使用这个指标来进行性能的比较。比如优化前和优化后，我们的产品与竞品的性能比较等。但是只能用于 粗略 的比较，不同的产品侧重点完全不同，所以还是需要根据自己产品所侧重的方向，并结合其他指标来进行更详细的对比。


### RAIL模型
RAIL是一个以用户为中心的性能模型，它把用户的体验拆分成几个关键点（例如，tap，scroll，load），并且帮你定义好了每一个的性能指标。

有以下四个方面：
* Response
* Animation
* Idle
* Load

![upload successful](/images/pasted-6.png)

#### Response：事件处理最好在50ms内完成

##### 目标

用户的输入到响应的时间不超过100ms，给用户的感受是瞬间就完成了。

##### 优化方案

* 事件处理函数在50ms内完成，考虑到idle task的情况，事件会排队，等待时间大概在50ms。适用于click，toggle，starting animations等，不适用于drag和scroll。
* 复杂的js计算尽可能放在后台，如web worker，避免对用户输入造成阻塞
* 超过50ms的响应，一定要提供反馈，比如倒计时，进度百分比等。

#### Animation: 在10ms内产生一帧

##### 目标

* 产生每一帧的时间不要超过10ms，为了保证浏览器60帧，每一帧的时间在16ms左右，但浏览器需要用6ms来渲染每一帧。
* 旨在视觉上的平滑。用户对帧率变化感知很敏感。

##### 优化方案

* 在一些高压点上，比如动画，不要去挑战cpu，尽可能地少做事，如：取offset，设置style等操作。尽可能地保证60帧的体验。
* 在渲染性能上，针对不同的动画做一些特定优化

#### Idle: 最大化空闲时间

##### 目标
最大化空闲时间，以增大50ms内响应用户输入的几率

##### 优化方案

* 用空闲时间来完成一些延后的工作，如先加载页面可见的部分，然后利用空闲时间加载剩余部分，此处可以使用 requestIdleCallback API
* 在空闲时间内执行的任务尽量控制在50ms以内，如果更长的话，会影响input handle的pending时间
* 如果用户在空闲时间任务进行时进行交互，必须以此为最高优先级，并暂停空闲时间的任务

#### Load: 传输内容到页面可交互的时间不超过5秒

##### 目标
如果页面加载比较慢，用户的交点可能会离开。加载很快的页面，用户平均停留时间会变长，跳出率会更低，也就有更高的广告查看率

##### 优化方案

* 优化加载速度，可以根据设备、网络等条件。目前，比较好的一个方式是，让你的页面在一个中配的3G网络手机上打开时间不超过5秒
* 对于第二次打开，尽量不超过2秒


### 性能计算规则

```
DNS 解析耗时: domainLookupEnd - domainLookupStart
TCP 连接耗时: connectEnd - connectStart
SSL 安全连接耗时: connectEnd - secureConnectionStart
网络请求耗时 (TTFB): responseStart - requestStart
数据传输耗时: responseEnd - responseStart
DOM 解析耗时: domInteractive - responseEnd
资源加载耗时: loadEventStart - domContentLoadedEventEnd
First Byte时间: responseStart - domainLookupStart
白屏时间: responseEnd - fetchStart
首次可交互时间: domInteractive - fetchStart
DOM Ready 时间: domContentLoadEventEnd - fetchStart
页面完全加载时间: loadEventStart - fetchStart
http 头部大小： transferSize - encodedBodySize
重定向次数：performance.navigation.redirectCount
重定向耗时: redirectEnd - redirectStart
```

### 优化地图
![upload successful](/images/pasted-5.png)

### 测试工具

* [google speed test](https://projectstream.google.com/speedtest)
* [Lighthouse](https://web.dev/measure/)
* [Web page test](https://webpagetest.org/easy)
