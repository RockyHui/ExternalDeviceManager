//
//  GamePadMacros.swift
//  
//
//  Created by Hui Linchao on 2024/9/9.
//  Copyright © 2024 cook. All rights reserved.
//

import Foundation

/// 手柄类型
enum GamePadCategory: Int {
    case Others     // 未知
    case XBox       // Xbox
    case DualShock  // PS4
    case DualSense  // PS5
}

/// 手柄序号（最多同时支持4个）
enum GamePadIndex: Int {
    case index1 = 0
    case index2 = 1
    case index3 = 2
    case index4 = 3
}

/// 手柄按键
enum GamePadButton: Int {
    case btnA
    case btnB
    case btnX
    case btnY
    
    case menu       // 菜单
    case option     // 选项
    case home       // Home
    
    // 肩键
    case leftTriger
    case rightTriger
    case leftShoulder
    case rightShoulder
    
    // 方向键
    case direction
    // 摇杆
    case leftThumbstick
    case leftThumbButton
    case rightThumbstick
    case rightThumbButton
    
    // Xbox特有
    case paddle1
    case paddle2
    case paddle3
    case paddle4
    case share
    
    // PS手柄特有
    case touchPad
    case touchFirst
    case touchSecond
    
    var description: String {
        get {
            switch self {
            case .btnA:
                return "A"
            case .btnB:
                return "B"
            case .btnX:
                return "X"
            case .btnY:
                return "Y"
            case .menu:
                return "菜单"
            case .option:
                return "选项"
            case .home:
                return "主页"
            case .leftTriger:
                return "左扳机"
            case .rightTriger:
                return "右扳机"
            case .leftShoulder:
                return "左肩机"
            case .rightShoulder:
                return "右肩机"
            case .direction:
                return "方向键"
            case .leftThumbButton:
                return "左摇杆按键"
            case .leftThumbstick:
                return "左摇杆"
            case .rightThumbButton:
                return "右摇杆按键"
            case .rightThumbstick:
                return "右摇杆"
            case .paddle1:
                return "背键1"
            case .paddle2:
                return "背键2"
            case .paddle3:
                return "背键3"
            case .paddle4:
                return "背键4"
            case .share:
                return "分享"
            case .touchPad:
                return "触摸板"
            case .touchFirst:
                return "触摸板手指1"
            case .touchSecond:
                return "触摸板手指2"
            }
        }
    }
}

enum GamePadInputDataType {
    
    case button(pressed: Bool)          // 按键类型：按下、抬起 两种状态
    case intensity(intensity: Float)    // 带有力度的按键：如，扳机键
    case dimension(point: CGPoint)      // 二维数据的按键：如，摇杆
    
    /// 判断按键是否按下
    /// - Returns: 返回按下状态
    func isPressed() -> Bool {
        switch self {
        case .button(let pressed):
            return pressed
        case .intensity(let inte):
            return inte != 0
        default:
            return false
        }
    }
    
    /// 获取按键的按下力度值（离散/连续）
    /// - Returns: 返回力度值
    func intensityVal() -> Float {
        switch self {
        case .intensity(let inte):
            return inte
        case .button(let pressed):
            return pressed ? 1 : 0
        default:
            return 0
        }
    }
    
    /// 获取按键的二维数据值
    /// - Returns: 返回按键的二维数据值
    func dimensionVal() -> CGPoint {
        switch self {
        case .dimension(let point):
            return point
        default:
            return .zero
        }
    }
    
}

/// 单击类型按钮
typealias GamePadButtonCallBack = (_ model: GamePadModel, _ keyName: GamePadButton, _ pressed: Bool) -> Void

/// 力度类型按钮
typealias GamePadIntensityCallBack = (_ model: GamePadModel, _ keyName: GamePadButton, _ intensity: Float) -> Void

/// 二维数据类型按钮
typealias GamePadDimensionCallBack = (_ model: GamePadModel, _ keyName: GamePadButton, _ point: CGPoint) -> Void

/// 手柄数据监听回调（将三种数据类型合并成统一接口）
typealias GamePadInputCallBack = (_ model: GamePadModel, _ button: GamePadButton, _ inputValue: GamePadInputDataType) -> Void

extension Notification.Name {
    /// 手柄连接通知
    static let gamePadConnected = Notification.Name("gamePadConnected")
    /// 手柄断开通知
    static let gamePadDisConnected = Notification.Name("gamePadDisConnected")
}
