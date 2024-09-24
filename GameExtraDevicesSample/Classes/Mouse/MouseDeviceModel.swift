//
//  MouseDeviceModel.swift
//  
//
//  Created by Hui Linchao on 2024/9/9.
//  Copyright © 2024 cook. All rights reserved.
//

import UIKit
import GameController

class MouseDeviceModel: NSObject {

    var deviceIndex: Int = 0
    var categoryName: String?
    var displayName: String?
    
    var mouseObjectId: Int = 0
    
    /// 鼠标按键
    var mouseButtonCallBack: MouseButtonInputCallBack?
    /// 鼠标移动
    var mouseMoveCallBack: MouseMoveInputCallBack?
    /// 鼠标滚轮滑动
    var mouseScrollCallBack: MouseScrollInputCallBack?
    
    @available(iOS 14.0, *)
    func bindMouseEventHandler(mouse: GCMouse) {
        categoryName = mouse.productCategory
        displayName = mouse.vendorName
        mouseObjectId = mouse.hashValue
        
        guard let mouseInput = mouse.mouseInput else {
            return
        }
        mouseInput.leftButton.pressedChangedHandler = { [weak self] button, val, pressed in
            guard self != nil else { return }
            let buttonName = button.localizedName ?? button.sfSymbolsName ?? ""
            print("[鼠标] 左键\(buttonName) \(pressed ? "按下" : "抬起")")
            self?.mouseButtonCallBack?(self!, .leftButton, pressed)
        }
        
        mouseInput.rightButton?.pressedChangedHandler = { [weak self] button, val, pressed in
            guard self != nil else { return }
            let buttonName = button.localizedName ?? button.sfSymbolsName ?? ""
            print("[鼠标] 右键\(buttonName) \(pressed ? "按下" : "抬起")")
            self?.mouseButtonCallBack?(self!, .rightButton, pressed)
        }
        
        mouseInput.middleButton?.pressedChangedHandler = { [weak self] button, val, pressed in
            guard self != nil else { return }
            let buttonName = button.localizedName ?? button.sfSymbolsName ?? ""
            print("[鼠标] 中键\(buttonName) \(pressed ? "按下" : "抬起")")
            self?.mouseButtonCallBack?(self!, .middleButton, pressed)
        }
        
        /// 其他功能按键
        if let otherButtons = mouseInput.auxiliaryButtons {
            for (index, button) in otherButtons.enumerated() {
                button.pressedChangedHandler = { [weak self] (button, value, pressed) in
                    if index == 0 {
                        self?.mouseButtonCallBack?(self!, .sideBackwardButton, pressed)
                        print("[鼠标] 下侧键 \(pressed ? "按下" : "抬起")")
                    } else if index == 1 {
                        self?.mouseButtonCallBack?(self!, .sideForwardButton, pressed)
                        print("[鼠标] 上侧键 \(pressed ? "按下" : "抬起")")
                    }
                }
            }
        }
        
        /// 鼠标移动
        mouseInput.mouseMovedHandler = { [weak self] button, deltaX, deltaY in
            guard self != nil else { return }
            if abs(deltaX) == 0 && abs(deltaY) == 0 {
                print("[鼠标] 移动无效 x:\(deltaX) y:\(deltaX)")
                return
            }
            let point = CGPoint(x: CGFloat(deltaX), y: CGFloat(deltaY))
            print("[鼠标] 移动 \(point)")
            self?.mouseMoveCallBack?(self!, point)
        }
        
        /// 鼠标滑轮
        mouseInput.scroll.valueChangedHandler = { [weak self] button, deltaX, deltaY in
            guard self != nil else { return }
            var point = CGPoint(x: CGFloat(deltaX), y: CGFloat(deltaY))
            // 优化返回数据不平滑的问题(慢慢滚动滚轮和快速滚动时返回的数据值相差太大)
            // 优化方法：
            //      1、返回数值最少为3。
            //      2、返回的数值超过50，进行减半处理。
            if abs(point.x) < 3 {
                if point.x > 0 {
                    point.x = 3
                } else if point.x < 0 {
                    point.x = -3
                }
            }
            
            if abs(point.y) < 3 {
                if point.y > 0 {
                    point.y = 3
                } else if point.y < 0 {
                    point.y = -3
                }
            }
            
            if abs(point.x) > 50 {
                point.x /= 2
            }
            if abs(point.y) > 50 {
                point.y /= 2
            }
            
            print("[鼠标] 滚轮滚动 \(point)")
            self?.mouseScrollCallBack?(self!, point)
        }
        
    }
}
