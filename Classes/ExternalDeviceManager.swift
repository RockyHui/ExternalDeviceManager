//
//  ExternalDeviceManager.swift
//  
//
//  Created by cook on 2024/9/9.
//  Copyright © 2024 cook. All rights reserved.
//

import Foundation
import GameController

public class ExternalDeviceManager: NSObject {
    
    public static let shared = ExternalDeviceManager()
    
    /// 手柄实体信息
    public var gamePads: [GamePadIndex: GamePadModel] = [:]
    /// 手柄按键回调
    public var gamepadButtonCallBack: GamePadInputCallBack?
    
    /// 键盘实体信息
    public var keyboardArr: [KeyboardModel] = []
    /// 键盘按键回调
    public var keyBoardCallBack: KeyboardButtonInputCallBack?
    
    /// 鼠标实体信息
    public var mouseArr: [MouseDeviceModel] = []
    /// 鼠标按键
    public var mouseButtonCallBack: MouseButtonInputCallBack?
    /// 鼠标移动
    public var mouseMoveCallBack: MouseMoveInputCallBack?
    /// 鼠标滚轮滑动
    public var mouseScrollCallBack: MouseScrollInputCallBack?
    
    private override init() {
        super.init()
    }
    
    /// 开启对硬件设备的监听
    public func startAllDeviceObservers() {
        startGamePadObservers()
        startKeyboardObservers()
        startMouseDeviceObservers()
    }
    
    /// 移除对硬件设备的监听
    public func removeAllDeviceObserver() {
        stopGamePadObservers()
        stopKeyboardObservers()
        stopMouseDeviceObservers()
    }
    
}
