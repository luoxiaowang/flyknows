title: "Webpack知识点汇总"
date: 2019-03-31 10:25:10
categories: Webpack
tags: [Webpack]
---

### Webpack技术点

#### babel原理
https://juejin.im/post/5ab9f2f3f265da239b4174f0

#### loader原理
##### 概念
当你在 webpack 项目中引入模块时，匹配到 rule （例如上面的 /\.js$/）就会启用对应的 loader (例如上面的 a-loader 和 b-loader)。这时，假设我们是 a-loader 的开发者，a-loader **会导出一个函数**，这个函数**接受的唯一参数是一个包含源文件内容的字符串**。我们暂且称它为「source」。

接着我们在函数中处理 source 的转化，最终返回处理好的值。当然返回值的数量和返回方式依据 a-loader 的需求来定。一般情况下可以通过 return 返回一个值，也就是转化后的值。如果需要返回多个参数，则须调用 this.callback(err, values...) 来返回。在异步 loader 中你可以通过抛错来处理异常情况。Webpack 建议我们返回 1 至 2 个参数，第一个参数是转化后的 source，可以是 string 或 buffer。第二个参数可选，是用来当作 SourceMap 的对象。

* 顺序最后的 loader 第一个被调用，它拿到的参数是 source 的内容
* 顺序第一的 loader 最后被调用， webpack 期望它返回 JS 代码，source map 如前面所说是可选的返回值。
* 夹在中间的 loader 被链式调用，他们拿到上个 loader 的返回值，为下一个 loader 提供输入。
* 因此是从右往左执行，从下往上执行

```javascript
module.exports = function (source) {
    // 处理 source ...
    this.callback(null, handledSource)
    return handledSource;
}

// 处理顺序排在最后的 loader
module.exports = function (source) {
    // 这个 loader 的功能是把源模块转化为字符串交给 require 的调用方
    return 'module.exports = ' + JSON.stringify(source);
}
```

##### 参考文档
* https://webpack.docschina.org/contribute/writing-a-loader/

#### Plugin原理
##### 示例

```javascript
class FileListPlugin {
  apply(compiler) {
    compiler.hooks.emit.tapAsync('FileListPlugin', (compilation, callback) => {
      // 在生成文件中，创建一个头部字符串：
      var filelist = 'In this build:\n\n';

      // 遍历所有编译过的资源文件，
      // 对于每个文件名称，都添加一行内容。
      for (var filename in compilation.assets) {
        filelist += ('- '+ filename +'\n');
      }

      // 将这个列表作为一个新的文件资源，插入到 webpack 构建中：
      compilation.assets['filelist.md'] = {
        source() {
          return filelist;
        },
        size() {
          return filelist.length;
        }
      };

      callback();
    });
  }
}

module.exports = FileListPlugin;
```

-------

```javascript
class HelloCompilationPlugin {
  apply(compiler) {
    // 置回调来访问 compilation 对象：
    compiler.hooks.compilation.tap('HelloCompilationPlugin', (compilation) => {
      // 现在，设置回调来访问 compilation 中的步骤：
      compilation.hooks.optimize.tap('HelloCompilationPlugin', () => {
        console.log('Hello compilation!');
      });
    });
  }
}

module.exports = HelloCompilationPlugin;
```

-------

```javascript
// MyPlugin.js

function MyPlugin(options) {
    // Configure your plugin with options...
}

MyPlugin.prototype.apply = function (compiler) {
    compiler.plugin('compile', function (params) {
        console.log('The compiler is starting to compile...');
    });

    compiler.plugin('compilation', function (compilation) {
        console.log('The compiler is starting a new compilation...');

        compilation.plugin('optimize', function () {
            console.log('The compilation is starting to optimize files...');
        });
    });

    // 异步的事件钩子
    compiler.plugin('emit', function (compilation, callback) {
        console.log('The compilation is going to emit files...');
        callback();
    });
};

module.exports = MyPlugin;
```

##### 几个概念

* compiler：compiler 对象是 webpack 的编译器对象，compiler 对象会在启动 webpack 的时候被一次性的初始化，compiler 对象中包含了所有 webpack 可自定义操作的配置，例如 loader 的配置，plugin 的配置，entry 的配置等各种原始 webpack 配置等，在 webpack 插件中的自定义子编译流程中，我们肯定会用到 compiler 对象中的相关配置信息，我们相当于可以通过 compiler 对象拿到 webpack 的主环境所有的信息。
* compilation：compilation 实例继承于 compiler，compilation 对象代表了一次单一的版本 webpack 构建和生成编译资源的过程。当运行 webpack 开发环境中间件时，每当检测到一个文件变化，一次新的编译将被创建，从而生成一组新的编译资源以及新的 compilation 对象。一个 compilation 对象包含了 当前的模块资源、编译生成资源、变化的文件、以及 被跟踪依赖的状态信息。编译对象也提供了很多关键点回调供插件做自定义处理时选择使用。
* Tapable：webpack 的插件架构主要基于 Tapable 实现的，Tapable 是 webpack 项目组的一个内部库，主要是抽象了一套插件机制，专注于自定义事件的触发和操作。webpack 中许多对象扩展自 Tapable 类。这个类暴露 tap, tapAsync 和 tapPromise 方法，可以使用这些方法，注入自定义的构建步骤，这些步骤将在整个编译过程中不同时机触发。根据你触发到 tap 事件，插件可能会以不同的方式运行。例如，当钩入 compile 阶段时，只能使用同步的 tap 方法。compiler 和 compilation都继承自Tapable。

##### 概念
* 是一个独立的模块。
* webpack 插件由「具名 JavaScript class(named JavaScript class)」构成
* 定义 apply 方法, 注入compiler对象
* apply 函数中需要有通过 compiler 对象挂载的 webpack 事件钩子，钩子的回调中能拿到当前编译的 compilation 对象，如果是异步编译插件的话可以拿到回调 callback。
* 完成自定义子编译流程并处理 complition 对象的内部数据。
* 如果异步编译插件的话，数据处理完成后执行 callback 回调。

-----------

* webpack打包执行插件时，会执行apply方法，首先获取到一个compiler对象。
* compiler.hooks.emit.tapAsync（例子），访问compiler的hook声明周期
* 在compiler中一些生命周期hooks中的回调函数参数中，例如compilation声明周期回调参数，可以获取到compilation对象
* 在compilation中再检测各种声明周期hooks，执行操作
* 如果是异步tapAsync，会获取到一个callback，执行完成操作后，调用callback

##### 参考文档
* https://webpack.docschina.org/contribute/writing-a-plugin/
* https://zoumiaojiang.com/article/what-is-real-webpack-plugin/
* http://taobaofed.org/blog/2016/09/09/webpack-flow/
