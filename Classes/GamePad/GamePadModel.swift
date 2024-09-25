//
//  GamePadModel.swift
//  
//
//  Created by cook on 2024/9/9.
//  Copyright © 2024 cook. All rights reserved.
//

import Foundation
import GameController
import CoreHaptics

public class GamePadModel {
    
    public var identifier: String = ""
    // 类型
    public var category: GamePadCategory = .Others
    public var categoryName: String?
    public var displayName: String?
    // 序号
    public var index: GamePadIndex = .index1
    // 手柄对象
    public var gameController: GCController? {
        didSet {
            if gameController != nil {
                bindGameControllerEventHandler(controller: gameController!)
            }
        }
    }
    
    var keyButtonCallBack: GamePadButtonCallBack?
    var intensityButtonCallBack: GamePadIntensityCallBack?
    var dimensionButtonCallBack: GamePadDimensionCallBack?
    
    init() {
        // 本地自己维护的设备唯一id
        let randomNum = Int32.random(in: 1000..<9999)
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy_MM_dd_HH_mm_ss"
        let dateString = dateFormatter.string(from: date)
        self.identifier = "gamepad_\(randomNum)_\(dateString)"
    }
    
    /// 绑定事件
    private func bindGameControllerEventHandler(controller: GCController) {
        guard let gamepad = controller.extendedGamepad else { return }
        /// 按键(A\B\X\Y)
        gamepad.buttonA.valueChangedHandler = { [weak self] (_, value, pressed) in
            self?.handleSingleButtonEvent(button: .btnA, buttonVal: value, pressed: pressed)
        }
        gamepad.buttonB.valueChangedHandler = { [weak self] (_, value, pressed) in
            self?.handleSingleButtonEvent(button: .btnB, buttonVal: value, pressed: pressed)
        }
        gamepad.buttonX.valueChangedHandler = { [weak self] (_, value, pressed) in
            self?.handleSingleButtonEvent(button: .btnX, buttonVal: value, pressed: pressed)
        }
        gamepad.buttonY.valueChangedHandler = { [weak self] (_, value, pressed) in
            self?.handleSingleButtonEvent(button: .btnY, buttonVal: value, pressed: pressed)
        }
        
        /// 功能键
        if #available(iOS 13.0, *) {
            gamepad.buttonMenu.valueChangedHandler = { [weak self] (_, value, pressed) in
                self?.handleSingleButtonEvent(button: .menu, buttonVal: value, pressed: pressed)
            }
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 13.0, *) {
            if let buttonOptions = gamepad.buttonOptions {
                buttonOptions.valueChangedHandler = { [weak self] (_, value, pressed) in
                    self?.handleSingleButtonEvent(button: .option, buttonVal: value, pressed: pressed)
                }
            }
        }
        if #available(iOS 14.0, *) {
            if let buttonHome = gamepad.buttonHome {
                buttonHome.valueChangedHandler = { [weak self] (_, value, pressed) in
                    self?.handleSingleButtonEvent(button: .home, buttonVal: value, pressed: pressed)
                }
            }
        }
        
        // 肩键
        gamepad.leftShoulder.valueChangedHandler = { [weak self] (_, value, pressed) in
            self?.handleSingleButtonEvent(button: .leftShoulder, buttonVal: value, pressed: pressed)
        }
        gamepad.rightShoulder.valueChangedHandler = { [weak self] (_, value, pressed) in
            self?.handleSingleButtonEvent(button: .rightShoulder, buttonVal: value, pressed: pressed)
        }
        gamepad.leftTrigger.valueChangedHandler = { [weak self] (_, value, pressed) in
            self?.handleIntensityButtonEvent(button: .leftTriger, buttonVal: value, pressed: pressed)
        }
        gamepad.rightTrigger.valueChangedHandler = { [weak self] (_, value, pressed) in
            self?.handleIntensityButtonEvent(button: .rightTriger, buttonVal: value, pressed: pressed)
        }
        
        /// 方向键
        gamepad.dpad.valueChangedHandler = { [weak self] (_, xAxis, yAxis) in
            let point = CGPoint(x: CGFloat(xAxis), y: CGFloat(yAxis))
            self?.handleDimensionalButtonEvent(button: .direction, location: point)
        }
        
        /// 摇杆
        gamepad.leftThumbstick.valueChangedHandler = { [weak self] (_, xAxis, yAxis) in
            let point = CGPoint(x: CGFloat(xAxis), y: CGFloat(yAxis))
            self?.handleDimensionalButtonEvent(button: .leftThumbstick, location: point)
        }
        gamepad.rightThumbstick.valueChangedHandler = { [weak self] (_, xAxis, yAxis) in
            let point = CGPoint(x: CGFloat(xAxis), y: CGFloat(yAxis))
            self?.handleDimensionalButtonEvent(button: .rightThumbstick, location: point)
        }
        if #available(iOS 12.1, *) {
            gamepad.leftThumbstickButton?.valueChangedHandler = { [weak self] (_, value, pressed) in
                self?.handleSingleButtonEvent(button: .leftThumbButton, buttonVal: value, pressed: pressed)
            }
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 12.1, *) {
            gamepad.rightThumbstickButton?.valueChangedHandler = { [weak self] (_, value, pressed) in
                self?.handleSingleButtonEvent(button: .rightThumbButton, buttonVal: value, pressed: pressed)
            }
        } else {
            // Fallback on earlier versions
        }
        
        // Xbox手柄
        if #available(iOS 14.0, *) {
            if let xboxGamepad = gamepad as? GCXboxGamepad {
                xboxGamepad.paddleButton1?.valueChangedHandler = { [weak self] (_, value, pressed) in
                    self?.handleSingleButtonEvent(button: .paddle1, buttonVal: value, pressed: pressed)
                }
                xboxGamepad.paddleButton2?.valueChangedHandler = { [weak self] (_, value, pressed) in
                    self?.handleSingleButtonEvent(button: .paddle2, buttonVal: value, pressed: pressed)
                }
                xboxGamepad.paddleButton3?.valueChangedHandler = { [weak self] (_, value, pressed) in
                    self?.handleSingleButtonEvent(button: .paddle3, buttonVal: value, pressed: pressed)
                }
                xboxGamepad.paddleButton4?.valueChangedHandler = { [weak self] (_, value, pressed) in
                    self?.handleSingleButtonEvent(button: .paddle4, buttonVal: value, pressed: pressed)
                }
                if #available(iOS 15.0, *) {
                    xboxGamepad.buttonShare?.valueChangedHandler = { [weak self] (_, value, pressed) in
                        self?.handleSingleButtonEvent(button: .share, buttonVal: value, pressed: pressed)
                    }
                }
            }
        }
        
        // PS4手柄
        if #available(iOS 14.0, *) {
            if let dualShockGamepad = gamepad as? GCDualShockGamepad {
                dualShockGamepad.touchpadButton.valueChangedHandler = { [weak self] (_, value, pressed) in
                    self?.handleSingleButtonEvent(button: .touchPad, buttonVal: value, pressed: pressed)
                }
                
                dualShockGamepad.touchpadPrimary.valueChangedHandler = { [weak self] (_, xAxis, yAxis) in
                    let point = CGPoint(x: CGFloat(xAxis), y: CGFloat(yAxis))
                    self?.handleDimensionalButtonEvent(button: .touchFirst, location: point)
                }
                
                dualShockGamepad.touchpadSecondary.valueChangedHandler = { [weak self] (_, xAxis, yAxis) in
                    let point = CGPoint(x: CGFloat(xAxis), y: CGFloat(yAxis))
                    self?.handleDimensionalButtonEvent(button: .touchSecond, location: point)
                }
            }
        }
        
        // PS5手柄，支持触摸板
        if #available(iOS 14.5, *) {
            if let dualSenseGamepad = gamepad as? GCDualSenseGamepad {
                dualSenseGamepad.touchpadButton.valueChangedHandler = { [weak self] (_, value, pressed) in
                    self?.handleSingleButtonEvent(button: .touchPad, buttonVal: value, pressed: pressed)
                }
                
                dualSenseGamepad.touchpadPrimary.valueChangedHandler = { [weak self] (_, xAxis, yAxis) in
                    let point = CGPoint(x: CGFloat(xAxis), y: CGFloat(yAxis))
                    self?.handleDimensionalButtonEvent(button: .touchFirst, location: point)
                }
                
                dualSenseGamepad.touchpadSecondary.valueChangedHandler = { [weak self] (_, xAxis, yAxis) in
                    let point = CGPoint(x: CGFloat(xAxis), y: CGFloat(yAxis))
                    self?.handleDimensionalButtonEvent(button: .touchSecond, location: point)
                }
                dualSenseGamepad.leftTrigger.valueChangedHandler = { [weak self] (_, value, pressed) in
                    self?.handleIntensityButtonEvent(button: .leftTriger, buttonVal: value, pressed: pressed)
                }
                dualSenseGamepad.rightTrigger.valueChangedHandler = { [weak self] (_, value, pressed) in
                    self?.handleIntensityButtonEvent(button: .rightTriger, buttonVal: value, pressed: pressed)
                }
            }
        }
    }
    
    /// 处理单键事件
    private func handleSingleButtonEvent(button: GamePadButton, buttonVal: Float, pressed: Bool) {
        print("手柄[\(index.rawValue)] 按键：\(button.description) value:\(buttonVal) \(pressed ? "按下": "抬起")")
        keyButtonCallBack?(self, button, pressed)
    }
    
    /// 处理带力度的按键
    private func handleIntensityButtonEvent(button: GamePadButton, buttonVal: Float, pressed: Bool) {
        print("手柄[\(index.rawValue)] 按键：\(button.description) value:\(buttonVal) \(pressed ? "按下": "抬起")")
        intensityButtonCallBack?(self, button, buttonVal)
    }
    
    /// 处理两个维度的按键
    private func handleDimensionalButtonEvent(button: GamePadButton, location: CGPoint) {
        print("手柄[\(index.rawValue)] 按键：\(button.description) x:\(location.x) y:\(location.y)")
        dimensionButtonCallBack?(self, button, location)
    }
}
