# 蓝牙外设监听模块
使用官方提供的GameController模块，监听接入的硬件外设（游戏手柄、键盘、鼠标），并处理传入的数据。

# 支持
* iOS，13.0 以上

# 安装
Pod导入：

```
pod 'ExternalDeviceManager', '~> 1.0.0'
```

# 用法
接口使用的单例对象`ExternalDeviceManager`,所有的数据都能从该接口获取到。

### 1、开启硬件设备输入事件监听
一键开启所有外设事件监听。


```
/// 开启对所有外设设备的监听
ExternalDeviceManager.shared.startAllDeviceObservers()
```

也可以每种设备按照需要去单独开启监听。

```
/// 监听手柄外设
ExternalDeviceManager.shared.startGamePadObservers()

/// 监听键盘外设
ExternalDeviceManager.shared.startKeyboardObservers()

/// 监听鼠标外设
ExternalDeviceManager.shared.startMouseDeviceObservers()
```
### 2、监听硬件设备的连接状态
```
/// 监听手柄的连接和断开事件
NotificationCenter.default.addObserver(self, selector: #selector(handleGamepadConnected), name: .gamePadConnected, object: nil)
NotificationCenter.default.addObserver(self, selector: #selector(handleGamepadDisconnected), name: .gamePadDisConnected, object: nil)
```
鼠标、键盘也有类似的事件，可在`KeyboardMacros.swift `和`MouseDeviceMacros.swift` 中查阅。

### 3、处理从监听获得数据
#### 3.1、手柄

```
/// 接收手柄数据回调
ExternalDeviceManager.shared.gamepadButtonCallBack = { [weak self] gamepad, button, data in
    // gamepad： 可以拿到手柄的相关信息
    // button： 表示手柄上具体哪个按键
    switch data {
    case .button(let pressed):
        // 按键按下和抬起
    case .dimension(let point):
        // 二维数据的按键
    case .intensity(let intensity):
        // 带有力度的按键
    }
}
```

#### 3.2、键盘

```
/// 键盘上按键事件回调
ExternalDeviceManager.shared.keyBoardCallBack = { [weak self] button, pressed in
	// button: 对应键盘上的按键
	// pressed: 按键按下和抬起的状态
}
```

#### 3.3、鼠标

```
/// 鼠标上按钮事件回调
ExternalDeviceManager.shared.mouseButtonCallBack = { [weak self] mouse, button, pressed in
	// mouse: 当前的鼠标对象
	// button: 对应键盘上的按键
   	// pressed: 按键按下和抬起的状态
}

/// 鼠标移动事件回调
ExternalDeviceManager.shared.mouseMoveCallBack = { [weak self] mouse, offset in
	// mouse: 当前的鼠标对象
	// offset: 偏移量
}

/// 鼠标中间滚轮回调
ExternalDeviceManager.shared.mouseScrollCallBack = { [weak self] mouse, offset in
	// mouse: 当前的鼠标对象
	// offset: 偏移量
}
```

# 参考资料
[GameConrtller 官方链接](https://developer.apple.com/documentation/gamecontroller)