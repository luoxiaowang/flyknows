title: "React+Flow使用指南"
date: 2017-10-14 13:15:00
categories: React
tags: [React]
---
本文主要介绍如何在React项目中使用Flow.js进行静态代码检查，接入的过程中也遇到了很多的问题，flow相关的资料比较少，因此这里把遇到的问题和解决方案同时也一并记录下来。
<!--more-->
## 一、flow解决的问题？
其实问题的根源就是因为javascript太灵活了，在代码运行期间几乎可以做任何的修改，没有东西可以在代码运行前就保证某个变量，某个函数跟预期的一致。所以要加入类型系统来确保代码的可靠性，在后期维护的时候同样能够传达出有效的信息。facebook出品的flow.js 做的就是这种事情。而且flow.js相比于TypeScript对工程的侵入性很小，无需大量的额外工作就能使用起来。

## 二、如何接入flow
### 1. 安装环境依赖
```shell
yarn add --dev babel-cli babel-preset-flow flow-bin
```
同时在webpack js babel转换中配置flow：
```javascript
presets: ['react', 'stage-0', 'es2015', 'flow'],
```
*********
### 2. 初始化flow配置
```shell
flow init
```
这样会生成一个.flowconfig的文件，该文件下有几块内容需要进行配置：
```javascript
[ignore]
.*/node_modules/.*

[include]
.*/src/**/*.js

[libs]

[options]

[lints]
```
* ignore：忽略文件
* include: 包含文件
* libs: 配置后，当检测代码的时候， flow 就会包含指定的库的声明文件(接口文件)，例如某些第三方库注册的全局变量可以新建interface
* options: 支持多个键值对，flow的各种配置
* lints: 定义flow的一些语法规则检测，键对值

*********

### 3. 启用flow检测
两种方式可以开启文件flow检测，文件的头部最开始写入：
```javascript
/* @flow */
```
或者
```javascript
// @flow
```
只要在文件头部进行声明，然后执行`flow`命令进行检测即可。

*********

### 4. eslint + flow处理
首先需要安装eslint对flow语法的兼容，按照相关依赖：
```shell
yarn add --dev babel-eslint eslint-plugin-flowtype
```
同时需要对eslint进行配置，修改.eslintrc配置文件：
```shell
"extends": [
    "airbnb",
    "plugin:flowtype/recommended"
  ],
  "parser": "babel-eslint",
  "plugins": [
    "flowtype"
  ]
```
这样eslint就能支持flow语法，并且会检测flow写法是否规范

*********

### 5. webstrome对flow语法的支持
![](https://d3nmt5vlzunoa1.cloudfront.net/webstorm/files/2016/11/flow-preferences.png)
*********

### 6. 常见问题解决
1）import css文件找不到？
在.flowconfig文件中配置options：
```shell
module.file_ext=.js
module.file_ext=.jsx
module.file_ext=.json
module.file_ext=.less
```

2) 在ignore中忽略了node_modules下的文件，导致import antd等包找不到模块？
通过flow-scripts自动生成Stub：
```shell
npm install -g flow-scripts --dev-save
flow-scripts stub
```
它会做两件事情：
- 告诉flow忽略检查node_modules
- 生成所需要的在package.json中的，但是不在flow-typed/npm中的包的依赖，并且写入依赖配置文件中去。
这将会生成一个`flow-typed/package-dep-libdefs.js`的文件，之后如果我们需要新增某个第三方依赖包，都需要去重新生成下stub。因此我们可以把它放到npm install的hook里面，在`package.json`里面加上:
```javascript
"scripts": {
  "postinstall": "flow-scripts stub"
}
```

3) webpack中的alias在js中引用，flow中无法识别？
```javascript
[options]
esproposal.class_instance_fields=ignore
esproposal.class_static_fields=ignore
esproposal.decorators=ignore
module.system=haste

module.file_ext=.js
module.file_ext=.jsx
module.file_ext=.json
module.file_ext=.less
module.name_mapper='^@lib/\(.*\)$' -> '<PROJECT_ROOT>/src/lib/\1'
module.name_mapper='^@lib$' -> '<PROJECT_ROOT>/src/lib'
```
主要是下面的两个设置，指定@lib的具体模块地址，网上的有些方式的正则写的有问题，这里可以参考：https://github.com/facebook/flow/issues/1620

### 三、语法说明
```javascript
// @flow

/**
 * 组件说明： 密码校验组件 by luoxiao
 * 使用方法：
 * <Password
          placeholder="请输入密码"
          minLen="8"
          rules={rules}
          verifySize="3"
          value={password}
          onChange={(val, result) => this.onChangeAccount(val, result)}
        />
 * param：
 * - placeholder string 默认提示
 * - minLen number 最小值 1
 * - maxLen number 最大值
 * - rules Array 规则 ["number", "upperCase", "lowerCase", "special"]
 * - verifySize number 满足多少条规则
 * - value string 值
 */

import React from 'react';
import { Input, Icon, Progress } from 'antd';
import './style.less';

type SuggestType = {
  text: string,
  type: string,
  verify: boolean
}

export default class PasswordBox extends React.Component {

  state: {
    suggest: Array<SuggestType>,
    visiable: boolean,
    password: string,
    countStrength: number,
    result: boolean,
    timer: number,
    status: string
  }

  constructor(props: Object) {
    super(props);
    this.state = {
      suggest: [],
      visiable: false,
      password: '',
      countStrength: 0,
      result: false,
      timer: 0,
      status: 'active'
    };
  }

  componentDidMount() {
    this.initSuggest();
  }

  onChange(e: Object) {
  }

  // 验证密码规则
  validatePassword(password: string) {
  }

  render() {
    const _this = this;
    const { placeholder, minLen, maxLen, rules, verifySize, value, ...obj } = _this.props;
    const { suggest, visiable, password, countStrength, status } = _this.state;
    const style: { display: string } = {
      display: visiable ? 'block' : 'none'
    };

    return (
      <div className="password--container">
        <Input
          placeholder={placeholder}
          {...obj}
          value={value}
          onBlur={(e) => this.hideValidate()}
          onFocus={(e) => this.showValidate()}
          onChange={(e) => this.onChange(e)}
        />
        <div className="password__validate" style={style}>
          <div className="arrow"></div>
          <p className="tip">您的密码必须符合以下规则:</p>
          {
            _this.renderSuggest()
          }
          <p className="tip strength">密码强度:</p>
          <Progress percent={countStrength} status={status} showInfo={false} />
        </div>
      </div>
    )
  }
}

PasswordBox.propTypes = {
  placeholder: React.PropTypes.string,
  minLen: React.PropTypes.number,
  maxLen: React.PropTypes.number,
  rules: React.PropTypes.array,
  verifySize: React.PropTypes.number,
  value: React.PropTypes.string
}

PasswordBox.defaultProps = {
  placeholder: '',
  minLen: 1,
  rules: [],
  verifySize: 0,
  value: ''
}
```
![](/image/2017-10/1.png)

![](/image/2017-10/2.png)

### 四、参考文档
[Flow + React官方文档](https://flow.org/en/docs/frameworks/react/)
[Flow + React组件编写方式](https://blog.callstack.io/type-checking-react-and-redux-thunk-with-flow-part-1-ad12de935c36)
[flow-scripts解决flowignore node_modules问题](https://stackoverflow.com/questions/42465256/flow-takes-very-long-to-start-up-because-it-checks-node-modules?rq=1)
[flow-script](https://github.com/yangshun/flow-scripts)
[Using Flow in WebStorm](https://blog.jetbrains.com/webstorm/2016/11/using-flow-in-webstorm/)
[Flow + React中文文档](https://zhenyong.github.io/flowtype/docs/getting-started.html#_)



