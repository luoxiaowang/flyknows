title: "React知识点汇总"
date: 2019-03-29 14:55:10
categories: React
tags: [React]
---

### React技术点
#### 什么情况下setState是异步的？
react事件处理函数中，以及生命周期函数中。避免重复re-render。但是在自己去addEventListener()的事件中，以及setTimeout这样的异步操作中，都是同步的。
原理在于，React在setState的实现中，主要使用isBatchingUpdates判断是直接更新this.state 还是放到队列中（放到dirtyComponent中）回头再说，而isBatchingUpdates 默认是false，也就表示 setState 会同步更新 this.state，但是，有一个函数batchedUpdates，这个函数会把 isBatchingUpdates 修改为true，而当 React 在调用事件处理函数之前就会调用这个 batchedUpdates，造成的后果就是由 React 控制的事件处理过程 setState 不会同步更新 this.state。

#### 如何同步或者避免批量更新？
放到setTimeout中或者在setState的回调中去取，或者setState的时候不要传递对象，而是传递一个生成函数。setTimeout的回调函数不受react所控制，因此不会执行batchupdate。

```javascript
incrementCount() {
  this.setState((state) => {
    // Important: read `state` instead of `this.state` when updating.
    return {count: state.count + 1}
  });
}

handleSomething() {
  // Let's say `this.state.count` starts at 0.
  this.incrementCount();
  this.incrementCount();
  this.incrementCount();
  // If you read `this.state.count` now, it would still be 0.
  // But when React re-renders the component, it will be 3.
}
```

#### React中的Transaction事务？
简单地说，一个所谓的 Transaction 就是将需要执行的 method 使用 wrapper 封装起来，再通过 Transaction 提供的 perform 方法执行。而在 perform 之前，先执行所有 wrapper 中的 initialize 方法；perform 完成之后（即 method 执行后）再执行所有的 close 方法。一组 initialize 及 close 方法称为一个 wrapper，从上面的示例图中可以看出 Transaction 支持多个 wrapper 叠加。
在声明周期中调用setState的时候，其实就处于一个 batchedUpdates 执行的 transaction 中它会先执行batchedUpdates方法。

https://zhuanlan.zhihu.com/p/20328570

#### React 中的事件处理逻辑
为了解决跨浏览器兼容性问题，React 会将浏览器原生事件（Browser Native Event）封装为合成事件（SyntheticEvent）传入设置的事件处理器中。这里的合成事件提供了与原生事件相同的接口，不过它们屏蔽了底层浏览器的细节差异，保证了行为的一致性。另外有意思的是，React 并没有直接将事件附着到子元素上，而是以单一事件监听器的方式将所有的事件发送到顶层进行处理。这样 React 在更新 DOM 的时候就不需要考虑如何去处理附着在 DOM 上的事件监听器，最终达到优化性能的目的。

#### React与Vue区别？
* **监听数据变化的实现原理不同**：Vue 通过 getter/setter 以及一些函数的劫持，能精确知道数据变化，不需要特别的优化就能达到很好的性能。React 默认是通过比较引用的方式进行的，如果不优化（PureComponent/shouldComponentUpdate）可能导致大量不必要的VDOM的重新渲染。
* **数据流的不同**：Vue中默认是支持双向绑定的，组件与DOM之间可以通过 v-model 双向绑定。，React一直提倡的是单向数据流，他称之为 onChange/setState()模式。
* **HoC 和 mixins**：Vue 一直是使用 mixin 来实现的，Vue中组件是一个被包装的函数，比如我们定义的模板怎么被编译的？比如声明的props怎么接收到的？这些都是vue创建组件实例的时候隐式干的事。由于vue默默帮我们做了这么多事，所以我们自己如果直接把组件的声明包装一下，返回一个高阶组件，那么这个被包装的组件就无法正常工作了。react觉得mixins代码侵入性太强。
* **组件通信的区别**：Vue中子组件向父组件传递消息有两种方式：事件和回调函数，而且Vue更倾向于使用事件，子组件通过 事件 向父组件发送消息， props 只向子组件传递数据。但是在 React 中我们都是使用回调函数的，这可能是他们二者最大的区别。
* **模板渲染方式的不同**：Vue是通过一种拓展的HTML语法进行渲染，Vue是在和组件JS代码分离的单独的模板中，通过指令来实现的。容易让html看起来很乱。 Vue中，由于模板中使用的数据都必须挂在 this 上进行一次中转，所以我们import 一个组件完了之后，还需要在 components 中再声明下。React 是通过JSX渲染模板，更加纯粹更加原生，通过js去控制各种逻辑，import之后可以在render中直接使用。
* Redux 使用的是不可变数据，而Vuex的数据是可变的。Redux每次都是用新的state替换旧的state，而Vuex是直接修改。在 Redux 中，我们每一个组件都需要显示的用 connect 把需要的 props 和 dispatch 连接起来。在 Vuex 中，$store 被直接注入到了组件实例中，因此可以比较灵活的使用。
* React更偏向于构建稳定大型的应用，非常的科班化。相比之下，Vue更偏向于简单迅速的解决问题，更灵活，不那么严格遵循条条框框。

#### JSX
JSX 只是为 React.createElement(component, props, ...children) 方法提供的语法糖

```javascript
<MyButton color="blue" shadowSize={2}>
  Click Me
</MyButton>

React.createElement(
  MyButton,
  {color: 'blue', shadowSize: 2},
  'Click Me'
)
```

https://react.docschina.org/docs/jsx-in-depth.html

#### HOC
高阶组件就是一个函数，且该函数接受一个组件作为参数，并返回一个新的组件。

```javascript
import React, { Component } from 'react';
import ExampleHoc from './example-hoc';

class UseContent extends Component {
  render() {
    console.log('props:',this.props);
    return (
    <div>
       {this.props.title} - {this.props.name}
    </div>
    )
  }
}
export default ExampleHoc(UseContent)
```

```javascript
import React, { Component } from 'react';

const ExampleHoc = WrappedComponent => {
  return class extends Component {
    constructor(props) {
        super(props)
        this.state = {
         title: 'hoc-component',
         name: 'arcsin1',
        }
    }
    render() {
       const newProps = {
        ...this.state,
       }
       return <WrappedComponent {...this.props} {...this.newProps} />
    }
  }
}
export default ExampleHoc
```

高阶组件既不会修改输入组件，也不会使用继承拷贝它的行为。而是，高阶组件 组合（composes） 原始组件，通过用一个容器组件 包裹着（wrapping） 原始组件。高阶组件就是一个没有副作用的纯函数。
高阶组件可以传递所有的props属性给包裹的组件，但是不能传递refs引用。因为并不是像key一样，refs是一个伪属性，React对它进行了特殊处理。如果你向一个由高阶组件创建的组件的元素添加ref应用，那么ref指向的是最外层容器组件实例的，而不是被包裹的组件。

#### 事件处理
通过bind这种方式推荐，但是比较麻烦：

```javascript
class Toggle extends React.Component {
  constructor(props) {
    super(props);
    this.state = {isToggleOn: true};

    // This binding is necessary to make `this` work in the callback
    this.handleClick = this.handleClick.bind(this);
  }

  handleClick() {
    this.setState(prevState => ({
      isToggleOn: !prevState.isToggleOn
    }));
  }

  render() {
    return (
      <button onClick={this.handleClick}>
        {this.state.isToggleOn ? 'ON' : 'OFF'}
      </button>
    );
  }
}
```

```
class LoggingButton extends React.Component {
  handleClick() {
    console.log('this is:', this);
  }

  render() {
    // This syntax ensures `this` is bound within handleClick
    return (
      <button onClick={(e) => this.handleClick(e)}>
        Click me
      </button>
    );
  }
}
```

使用箭头函数语法有个问题就是，每次 LoggingButton 渲染的时候都会创建一个不同的回调函数。在大多数情况下，这没有问题。然而如果这个回调函数作为一个属性值传入低阶组件，这些组件可能会进行额外的重新渲染。我们通常建议在构造函数中绑定或使用**属性初始化器语法**来避免这类性能问题。

```javascript
class LoggingButton extends React.Component {
  // This syntax ensures `this` is bound within handleClick.
  // Warning: this is *experimental* syntax.
  handleClick = () => {
    console.log('this is:', this);
  }

  render() {
    return (
      <button onClick={this.handleClick}>
        Click me
      </button>
    );
  }
}
```

#### HOOK
* 跳出class的组织方式，函数式组件更好复用
* 有了钩子，你可以在组件中按照代码块的相关性组织副作用，而不是基于生命周期方法强制进行切分，相关联的逻辑也不会被强行拆分开
* 不要在循环、条件、或者嵌套函数中调用hooks，并且最好在函数顶层使用。确保
* 不要在常规的函数中调用hooks，应该在react函数组件中调用
* 如果想要加条件，可以将if条件放到hook内部

##### useState

```javascript
import { useState, useEffect } from 'react';

function Example() {
  const [count, setCount] = useState(0);

  useEffect(() => {
    document.title = `You clicked ${count} times`;
    return () => {
        document.title = `default title`;
    }
  }, [count]);

  return (
    <div>
      <p>You clicked {count} times</p>
      <button onClick={() => setCount(count + 1)}>
        Click me
      </button>
    </div>
  );
}
```

* 接受一个初始值，返回一个数组包含2个元素，一个是当前的状态，一个是设置状态的函数。初始值只有第一次有用
* hooks只能在函数最顶层使用，必须use开头，可声明多个

##### useEffect
* 用来替代class用法中的声明周期，更好的组织和复用代码。React将运行useEffect的时机放到了浏览器绘制之后
* 第一次render完成后会调用一次，类似componentDidMount。并且每次render后都会再调用一次，类似componentDidUpdate
* 接受一个函数作为参数，调用完成之后会将其销毁（如果有销毁函数的话），每次调用内部都会新传递一个函数，包含了最新的状态值，避免存储了错误的状态
* 可以return一个函数出去，这个函数会在组件unmount的时候调用（如上），类似componentWillUnmount可以用于清除一些状态，每次render之后调用effect，然后执行完成之后调用return的销毁函数
* useEffect接受第二个参数，是一个数组的形式。它会去判断传进来的这个参数，之前的值和现在的值有没有什么变化，如果没有变化，将不会去重新应用和销毁。如果传递的数组有多个项目，当中只要有一个不同的，那么都会重新应用。（类似于componentDidUpdate的优化）
* 你也可以传递一个空数组，这样你的效果只会运行及清理一次

##### useCallback

```javascript
const memoizedCallback = useCallback(
  () => {
    doSomething(a, b);
  },
  [a, b],
);
```
只要有一个方式变化，都会调用回调

##### useMemo

```javascript
const memoizedValue = useMemo(() => computeExpensiveValue(a, b), [a, b]);
```

传递一个计算函数，和一个数组，当数组中的值发生变化时，会调用这个计算函数

#### render props
**让一个组件自己动态决定什么需要渲染的，而不是硬编码在内部。**

##### 在 React.PureComponent 中使用 render props 要注意：
如果你在 render 方法里创建函数，那么使用 render prop 会抵消使用 React.PureComponent 带来的优势。这是因为浅 prop 比较对于新 props 总会返回 false，并且在这种情况下每一个 render 对于 render prop 将会生成一个新的值。

```javascript
class Cat extends React.Component {
  render() {
    const mouse = this.props.mouse;
    return (
      <img src="/cat.jpg" style={{ position: 'absolute', left: mouse.x, top: mouse.y }} />
    );
  }
}

class Mouse extends React.Component {
  constructor(props) {
    super(props);
    this.handleMouseMove = this.handleMouseMove.bind(this);
    this.state = { x: 0, y: 0 };
  }

  handleMouseMove(event) {
    this.setState({
      x: event.clientX,
      y: event.clientY
    });
  }

  render() {
    return (
      <div style={{ height: '100%' }} onMouseMove={this.handleMouseMove}>

        {/*
          Instead of providing a static representation of what <Mouse> renders,
          use the `render` prop to dynamically determine what to render.
        */}
        {this.props.render(this.state)}
      </div>
    );
  }
}

class MouseTracker extends React.Component {
  render() {
    return (
      <div>
        <h1>Move the mouse around!</h1>
        <Mouse render={mouse => (
          <Cat mouse={mouse} />
        )}/>
      </div>
    );
  }
}
```

##### 参考文档
https://zhuanlan.zhihu.com/p/50597236

#### React 16声明周期的变更
之前：
![-w1343](//pp801w79g.bkt.clouddn.com/15511517356966.jpg)

声明周期为什么要变更，这个主要源自于React 16中的新特征：[React Fiber](https://zhuanlan.zhihu.com/p/26027085)。

为了解决体验和效率的问题，引入Fiber这个概念，英文含义就是“纤维”，意指比Thread更细的线，也就是比线程(Thread)控制得更精密的并发处理机制。也就是分片的概念。

在React Fiber中，一次更新过程会分成多个分片完成，所以完全有可能一个更新任务还没有完成，就被另一个更高优先级的更新过程打断，这时候，优先级高的更新任务会优先处理完，而低优先级更新任务所做的工作则会完全作废，然后等待机会重头再来。

因为一个更新过程可能被打断，所以React Fiber一个更新过程被分为两个阶段(Phase)：第一个阶段Reconciliation Phase和第二阶段Commit Phase。在第一阶段Reconciliation Phase，React Fiber会找出需要更新哪些DOM，这个阶段是可以被打断的；但是到了第二阶段Commit Phase，那就一鼓作气把DOM更新完，绝不会被打断。

![-w717](//pp801w79g.bkt.clouddn.com/15511537436707.jpg)

第一阶段的这些可能会被打断，并且重新反复执行。如果要开启async rendering，在render函数之前的所有函数，都有可能被执行多次。长期以来，原有的生命周期函数总是会诱惑开发者在render之前的生命周期函数做一些动作，现在这些动作还放在这些函数中的话，有可能会被调用多次，这肯定不是你想要的结果。

componentWillMount里面最好不要进行异步数据请求，首先他无论如何也赶不上render，而且componentWillMount在服务器端渲染也会被调用到。这样的IO操作放在componentDidMount里更合适。在Fiber启用async render之后，更没有理由在componentWillMount里做AJAX，因为componentWillMount可能会被调用多次，谁也不会希望无谓地多次调用AJAX吧。

随着getDerivedStateFromProps的推出，同时deprecate了一组生命周期API，包括：

* componentWillReceiveProps
* componentWillMount
* componentWillUpdate

##### 新添加的声明周期
getDerivedStateFromProps是一个静态函数，所以函数体内不能访问this。

```javascript
class ExampleComponent extends React.Component {
  state = {
    isScrollingDown: false,
    lastRow: null,
  };

  static getDerivedStateFromProps(nextProps, prevState) {
    // 不再提供 prevProps 的获取方式
    // 根据nextProps和prevState计算出预期的状态改变，返回结果会被送给setState
    if (nextProps.currentRow !== prevState.lastRow) {
      return {
        isScrollingDown: nextProps.currentRow > prevState.lastRow,
        lastRow: nextProps.currentRow,
      };
    }

    // 默认不改动 state
    return null;
  }
  
  componentDidUpdate() {
    // 仅在更新触发后请求数据
    this.loadAsyncData()
  }

  loadAsyncData() {/* ... */}
}
```

每当父组件引发当前组件的渲染过程时，getDerivedStateFromProps会被调用，这样我们有一个机会可以根据新的props和之前的state来调整新的state。getDerivedStateFromProps在Updating和Mounting过程中都会被调用。

React v16.3还引入了一个新的声明周期函数getSnapshotBeforeUpdate，这函数会在render之后执行，而执行之时DOM元素还没有被更新，给了一个机会去获取DOM信息，计算得到一个snapshot，这个snapshot会作为componentDidUpdate的第三个参数传入。

```javascript
getSnapshotBeforeUpdate(prevProps, prevState) {
    console.log('#enter getSnapshotBeforeUpdate');
    return 'foo';
  }

  componentDidUpdate(prevProps, prevState, snapshot) {
    console.log('#enter componentDidUpdate snapshot = ', snapshot);
  }
```

更改后的生命周期：

![-w1380](http://pp801w79g.bkt.clouddn.com/15511546301362.jpg)

##### 参考文档：
https://zhuanlan.zhihu.com/p/38030418
https://zhuanlan.zhihu.com/p/26027085

#### react-router原理？
https://github.com/fi3ework/blog/issues/21

#### 虚拟dom及diff
https://www.cnblogs.com/zhuzhenwei918/p/7271305.html

#### 如何实现一个 Virtual DOM 算法
https://github.com/livoras/blog/issues/13

#### 如何实现一个React？
https://github.com/hujiulong/blog/issues/4

#### 数据管理方案？
* https://segmentfault.com/a/1190000007248878
* https://km.sankuai.com/page/23026896

#### 理解中间件
* https://juejin.im/post/59dc7e43f265da4332268906
* https://juejin.im/post/5b237569f265da59bf79f3e9

#### Connect的实现
https://blog.csdn.net/c_kite/article/details/79018469

#### React同构
https://juejin.im/post/5bc7ea48e51d450e46289eab

#### React小书
http://huziketang.mangojuice.top/books/react/lesson20

