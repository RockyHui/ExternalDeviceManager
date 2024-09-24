//
//  ExternalDeviceManager.swift
//  
//
//  Created by Hui Linchao on 2024/9/9.
//  Copyright © 2024 cook. All rights reserved.
//

import Foundation
import GameController

class ExternalDeviceManager: NSObject {
    
    static let shared = ExternalDeviceManager()
    
    /// 手柄实体信息
    var gamePads: [GamePadIndex: GamePadModel] = [:]
    /// 手柄按键回调
    var gamepadButtonCallBack: GamePadInputCallBack?
    
    /// 键盘实体信息
    var keyboardArr: [KeyboardModel] = []
    /// 键盘按键回调
    var keyBoardCallBack: KeyboardButtonInputCallBack?
    
    /// 鼠标实体信息
    var mouseArr: [MouseDeviceModel] = []
    /// 鼠标按键
    var mouseButtonCallBack: MouseButtonInputCallBack?
    /// 鼠标移动
    var mouseMoveCallBack: MouseMoveInputCallBack?
    /// 鼠标滚轮滑动
    var mouseScrollCallBack: MouseScrollInputCallBack?
    
    private override init() {
        super.init()
    }
    
    /// 开启对硬件设备的监听
    func startAllDeviceObservers() {
        startGamePadObservers()
        startKeyboardObservers()
        startMouseDeviceObservers()
    }
    
    /// 移除对硬件设备的监听
    func removeAllDeviceObserver() {
        stopGamePadObservers()
        stopKeyboardObservers()
        stopMouseDeviceObservers()
    }
    
}
