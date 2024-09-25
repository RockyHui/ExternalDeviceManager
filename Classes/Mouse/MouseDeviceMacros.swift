//
//  MouseDeviceMacros.swift
//  
//
//  Created by cook on 2024/9/9.
//  Copyright © 2024 cook. All rights reserved.
//

import Foundation

/// 鼠标按键
public enum MouseButton: Int {
    case leftButton             // 左键
    case rightButton            // 右键
    case middleButton           // 中键
    case sideForwardButton      // 侧边前键
    case sideBackwardButton     // 侧边后键
    case others                 // 其他
    
    public var description: String {
        get {
            switch self {
            case .leftButton:
                return "鼠标左键"
            case .rightButton:
                return "鼠标右键"
            case .middleButton:
                return "鼠标中键"
            case .sideForwardButton:
                return "鼠标侧边前进键"
            case .sideBackwardButton:
                return "鼠标侧边后退键"
            case .others:
                return "鼠标其他键"
            }
        }
    }
}

public typealias MouseButtonInputCallBack = (_ model: MouseDeviceModel, _ button: MouseButton, _ pressed: Bool) -> Void

public typealias MouseMoveInputCallBack = (_ model: MouseDeviceModel, _ point: CGPoint) -> Void

public typealias MouseScrollInputCallBack = (_ model: MouseDeviceModel, _ point: CGPoint) -> Void

public extension Notification.Name {
    /// 鼠标连接通知
    static let mouseConnected = Notification.Name("mouseConnected")
    /// 鼠标断开通知
    static let mouseDisConnected = Notification.Name("mouseDisConnected")
}
