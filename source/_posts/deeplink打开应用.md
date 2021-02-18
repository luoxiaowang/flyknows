title: ' Electron系列文章 - deeplink打开应用'
author: luoxiao
tags:
  - Electron
categories:
  - Electron
date: 2020-08-13 16:06:00
---
### 一、deeplink名称

浏览器deeplink唤起客户端：[eva:?customerId=11111&sellerId=2222](eva:?customerId=11111&sellerId=2222)

### 二、检测系统是否存在deeplink

[https://github.com/ismailhabib/custom-protocol-detection](https://github.com/ismailhabib/custom-protocol-detection)

```javascript
import ProtocolCheck from 'custom-protocol-detection'
export function checkDeepLink(url) {
  ProtocolCheck(url, () => {
    const title = '检测到您还未安装客服工作台PC客户端，请先下载安装？'
    const openDialog = withDialog({
      title,
    })
    openDialog(this, () => {
    })
  }, () => {
  })
}
```

### 三、详细设计

#### 1、浏览器通过url调起应用的原理

max下：会在要调起应用的包内容中，Info.plist 文件下注册一个URL Schemes，名字为为deeplink注册名

windows下：在注册表的HKEY_CALSSES_ROOT目录下，添加一个deeplink scheme的字段，并将值指向要唤起的exe 包的路径


![upload successful](/images/pasted-1.png)

#### 2、如何定义协议？

electron中提供了协议注册的方法，使用`app.setAsDefaultProtocolClient('你要注册的协议名称')`即可：

```javascript
const PROTOCOL = 'eva'
function registerLink() {
  const args = []
  if (getEnv() === 'dev') {
    // 如果是开发阶段，需要把我们的脚本的绝对路径加入参数中
    args.push(path.resolve(process.argv[1]))
  }
  // 此处有一个安全漏洞，加一个 `--` 以确保后面的参数不被 Electron 处理，https://www.nsfocus.com.cn/html/2018/39_0125/732.html
  args.push('--')

  // 注册协议  Notice: mac下没有args参数，因此无法开发环境调试，具体参考：https://newsn.net/say/electron-fake-protocal-debug.html
  app.setAsDefaultProtocolClient(PROTOCOL, process.execPath, args)
}
```

以上方式会在用户启动应用后，在主进程中进行注册操作，之后web端即可唤起应用。但是如果用户是第一次安装，并没有打开过app，仍然需要通过deeplink唤起的话，可以通过 nsis 去进行应用的安装和卸载的相关配置，在应用安装和卸载的时候进行注册：

```shell
"nsis": {
      "allowToChangeInstallationDirectory": true,
      "oneClick": false,
      "menuCategory": false,
      "allowElevation": true,
      // 这里指定要包含 nsis 的脚本，基于内置的nsis脚本进一步扩展
      "include": "build/installer.nsh",
      "installerIcon": "build/images/eva.ico",
      "uninstallerIcon": "build/images/eva.ico",
      "installerHeaderIcon": "build/images/eva.ico",
      "createDesktopShortcut": true
},
```

下面我们就可以在installer.nsh中自定义安装和卸载的一些逻辑了，customInstall和customUnInstall分别是安装和卸载时候的钩子：

```shell
!macro customInstall
  DetailPrint "Register eva URI Handler"
  DeleteRegKey HKCR "eva"
  WriteRegStr HKCR "eva" "" "URL:eva"
  WriteRegStr HKCR "eva" "URL Protocol" ""
  WriteRegStr HKCR "eva\shell" "" ""
  WriteRegStr HKCR "eva\shell\Open" "" ""
  WriteRegStr HKCR "eva\shell\Open\command" "" "$INSTDIR\${APP_EXECUTABLE_FILENAME} %1"
!macroend

!macro customUnInstall
  DeleteRegKey HKCR "eva"
!macroend
```

#### 3、唤起引用时触发的钩子函数

* mac 通过 app.on('open-url', fun)监听
* window 通过 app.on("second-instance",fun)监听

```javascript
function listenerInstance() {
  // 其他实例启动时，主实例会通过 second-instance 事件接收其他实例的启动参数 `argv`
  app.on('second-instance', (event, argv) => {
    if (process.platform === 'win32') {
      // Windows 下通过协议URL启动时，URL会作为参数，所以需要在这个事件里处理
      handleArgv(argv)
    }
  })

  // macOS 下通过协议URL启动时，主实例会通过 open-url 事件接收这个 URL
  app.on('open-url', (event, urlStr) => {
    handleUrl(urlStr)
  })
}
```

3.1 macOS 下通过URL Schemes协议调起应用时触发open-url事件，mac下应用只能单开，这个时候我们可以根据解析url获取到具体的参数：

```javascript
let schemeParam = null
function handleUrl(urlStr) {
  log.info('handleUrl>>>', urlStr)
  // eva:?customerId=585bc8a7b25a3b60efd36f60&sellerId=2222
  const urlObj = new URL(urlStr)
  const { searchParams } = urlObj

  const entries = searchParams.entries()
  const result = {}
  for (const entry of entries) {
    const [key, value] = entry
    result[key] = value
  }
  schemeParam = result

  const evaAppWin = global.evaAppWin
  if (evaAppWin) {
    // 如果这个时候app是ready的，并且能拿到win的对象，则通知webview进行link的行为触发，且传递参数
    evaAppWin.webContents.send('schemeLink', schemeParam)
    // 调用完成之后，清掉内存中记下的参数（因为考虑到登录后再发起会话，所以需要缓存下参数）
    emptySchemeParam()
  }
}
```

3.2  window下通过URL Schemes协议调起应用会分两种情况：

* 应用处于打开状态，会触发 second-instance 事件并接收这个 URL。
* 应用处于未打开状态，在网页端通过浏览器调起应用之后不会触发 second-instance 事件；这个时候需要主动判断应用是否是从网页端调起，并主动触发 second-instance 事件；

通过deeplink请求后，会开启一个新的进程，打开新的应用（mac下不会），这时候我们需要检测是否已经有app已经启动。因为我们的app是支持多开的，如果应用已经打开的情况下，这里还会分为两种情况：

* 如果再次通过deeplink唤起的，唤起的应用要立刻退出，因为deeplink情况下，不需要再开一个应用，只需在目前已经打开的应用上操作即可。已经启动的应用主进程则会检测到second-instance获取到参数
* 如果不是通过deeplink唤起的，而是手动在开启一个应用，则放开限制，同时新开的应用需要一起监听 second-instance

```javascript
function checkSchemeSetup() {
  // 获取单实例锁
  const gotTheLock = app.requestSingleInstanceLock()
  // windows如果是通过url schema启动则发出事件处理
  // 启动参数超过1个才可能是通过url schema启动
  // mac下process.argv只有一个
  if (process.argv.length > 1) {
    // scheme唤起，并且没有获取到单例锁
    if (!gotTheLock) {
      // 如果获取失败，说明已经有实例在运行了，直接退出
      app.quit()
    } else {
      listenerInstance()
      // 第一次被deeplink唤起的时候，先需要预存下参数，便于登录后发起会话
      handleArgv(process.argv)
    }
  } else {
    listenerInstance()
  }
}

// win下
function handleArgv(argv) {
  const prefix = `${PROTOCOL}:`
  // 开发阶段，跳过前两个参数（`electron.exe .`）
  // 打包后，跳过第一个参数（`evaclient.exe`）
  const offset = getEnv() === 'dev' ? 2 : 1
  const url = argv.find((arg, i) => i >= offset && arg.startsWith(prefix))
  if (url) handleUrl(url)
}
```

3.3 没有登录的情况下，则先缓存url参数，等到登录成功后，传递参数，通知webview触发行为。

### 四、一些注意点

* mac下electron应用只能单开，通过deeplink可以唤起当前应用
mac下开发环境无法进行deeplink调试，原因是setAsDefaultProtocolClient不支持args指定参数，只能* 打开electron自己的壳子，无法指向要执行的代码文件。参考：
https://newsn.net/say/electron-fake-protocal-debug.html

### 五、可能存在的问题

* windows下setAsDefaultProtocolClient注册协议时，安全管家有弹出提示警告，有程序在修改注册表，是否允许。（选允许则没有问题，不是必现，要用户注意一下，否则拦截后可能会导致deeplink无法唤起应用）
* 有一定概率卸载后，注册表删除不干净，再次点击deeplink时依旧弹窗，但是打不开应用，不过没有什么影响。

### 六、参考文章

https://juejin.im/post/6844904146848448525

https://www.jianshu.com/p/d880c0ca0911

https://github.com/oikonomopo/electron-deep-linking-mac-win

https://www.jianshu.com/p/5c0bb0599dff

https://segmentfault.com/a/1190000020187358