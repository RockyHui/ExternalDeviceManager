//
//  ExternalDeviceManager+Keyboard.swift
//  
//
//  Created by cook on 2024/9/9.
//  Copyright © 2024 cook. All rights reserved.
//
//
//          键盘⌨️
//

import UIKit
import GameController

extension ExternalDeviceManager {
    
    /// 开启键盘事件监听
    public func startKeyboardObservers() {
        if #available(iOS 14.0, *) {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidConnect), name: NSNotification.Name.GCKeyboardDidConnect, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidDisconnect), name: NSNotification.Name.GCKeyboardDidDisconnect, object: nil)
            
            if let keyboard = GCKeyboard.coalesced {
                configKeyboard(keyboard: keyboard)
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    /// 停止键盘事件监听
    public func stopKeyboardObservers() {
        if #available(iOS 14.0, *) {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.GCKeyboardDidConnect, object: nil)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.GCKeyboardDidDisconnect, object: nil)
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc private func keyboardDidConnect(notification: Notification) {
        if #available(iOS 14.0, *) {
            print("[键盘] 连接通知")
            if let keyboard = notification.object as? GCKeyboard {
                configKeyboard(keyboard: keyboard)
                NotificationCenter.default.post(name: .keyboardConnected, object: nil)
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc private func keyboardDidDisconnect(notification: Notification) {
        if #available(iOS 14.0, *) {
            print("[键盘] 连接断开通知")
            if let keyboard = notification.object as? GCKeyboard {
                keyboardArr.removeAll { oneModel in
                    return oneModel.keyboardId == keyboard.hashValue
                }
            }
            NotificationCenter.default.post(name: .keyboardDisConnected, object: nil)
        } else {
            // Fallback on earlier versions
        }
    }
    
    @available(iOS 14.0, *)
    func configKeyboard(keyboard: GCKeyboard) {
        if let keyboardInput = keyboard.keyboardInput {
            keyboardInput.keyChangedHandler = { (_, _, keyCode, pressed) in
                if let keyCodeType = self.mapKeyboardCode(keyCode: keyCode) {
//                        let inputDescription  = input.description
                    self.keyBoardCallBack?(keyCodeType, pressed)
                    print("[键盘] \(keyCodeType.rawValue) \(pressed ? "按下" : "抬起")")
                }
            }
        }
        let keyboardModel = KeyboardModel()
        keyboardModel.keyboardId = keyboard.hashValue
        keyboardModel.categoryName = keyboard.productCategory
        keyboardModel.displayName = keyboard.vendorName
        if !keyboardArr.contains(where: { oneModel in
            return oneModel.keyboardId == keyboard.hashValue
        }) {
            keyboardArr.append(keyboardModel)
        }
    }
    
    @available(iOS 14.0, *)
    private func mapKeyboardCode(keyCode: GCKeyCode) -> KeyboardValueType? {
        switch keyCode {
        case .keyA:
            return .A
        case .keyB:
            return .B
        case .keyC:
            return .C
        case .keyD:
            return .D
        case .keyE:
            return .E
        case .keyF:
            return .F
        case .keyG:
            return .G
        case .keyH:
            return .H
        case .keyI:
            return .I
        case .keyJ:
            return .J
        case .keyK:
            return .K
        case .keyL:
            return .L
        case .keyM:
            return .M
        case .keyN:
            return .N
        case .keyO:
            return .O
        case .keyP:
            return .P
        case .keyQ:
            return .Q
        case .keyR:
            return .R
        case .keyS:
            return .S
        case .keyT:
            return .T
        case .keyU:
            return .U
        case .keyV:
            return .V
        case .keyW:
            return .W
        case .keyX:
            return .X
        case .keyY:
            return .Y
        case .keyZ:
            return .Z
        case .deleteOrBackspace:
            return .Backspace
        case .spacebar:
            return .Space
        case .capsLock:
            return .Caps
        case .returnOrEnter:
            return .Enter
        case .one:
            return .one
        case .two:
            return .two
        case .three:
            return .three
        case .four:
            return .four
        case .five:
            return .five
        case .six:
            return .six
        case .seven:
            return .seven
        case .eight:
            return .eight
        case .nine:
            return .nine
        case .zero:
            return .zero
        case .F1:
            return .F1
        case .F2:
            return .F2
        case .F3:
            return .F3
        case .F4:
            return .F4
        case .F5:
            return .F5
        case .F6:
            return .F6
        case .F7:
            return .F7
        case .F8:
            return .F8
        case .F9:
            return .F9
        case .F10:
            return .F10
        case .F11:
            return .F11
        case .F12:
            return .F12
        case .escape:
            return .Esc
        case .tab:
            return .Tab
        case .printScreen:
            return .PrtScr
        case .scrollLock:
            return .ScrLK
        case .pause:
            return .Pause
        case .insert:
            return .Ins
        case .home:
            return .Home
        case .pageUp:
            return .PgUp
        case .deleteForward:
            return .Del
        case .end:
            return .End
        case .pageDown:
            return .PgDn
        case .upArrow:
            return .ArrowUp
        case .downArrow:
            return .ArrowDown
        case .leftArrow:
            return .ArrowLeft
        case .rightArrow:
            return .ArrowRight
        case .graveAccentAndTilde:
            return .Tilde
        case .hyphen:
            return .Hyphen
        case .equalSign:
            return .EqualSign
        case .openBracket:
            return .OpenBracket
        case .closeBracket:
            return .CloseBracket
        case .backslash:
            return .Backslash
        case .semicolon:
            return .Semicolon
        case .quote:
            return .Quote
        case .comma:
            return .Comma
        case .period:
            return .Period
        case .slash:
            return .Slash
        case .leftControl:
            return .LeftControl
        case .leftShift:
            return .LeftShift
        case .leftAlt:
            return .LeftAlt
        case .leftGUI:
            return .LeftWin
        case .rightControl:
            return .RightControl
        case .rightShift:
            return .RightShift
        case .rightAlt:
            return .RightAlt
        case .rightGUI:
            return .RightWin
        case .printScreen:
            return .PrtScr
        case .scrollLock:
            return .ScrLK
        case .pause:
            return .Pause
        case .insert:
            return .Ins
        case .keypadSlash:
            return .keypadSlash
        case .keypadAsterisk:
            return .keypadAsterisk
        case .keypadHyphen:
            return .keypadHyphen
        case .keypadPlus:
            return .keypadPlus
        case .keypad1:
            return .keypad1
        case .keypad2:
            return .keypad2
        case .keypad3:
            return .keypad3
        case .keypad4:
            return .keypad4
        case .keypad5:
            return .keypad5
        case .keypad6:
            return .keypad6
        case .keypad7:
            return .keypad7
        case .keypad8:
            return .keypad8
        case .keypad9:
            return .keypad9
        case .keypad0:
            return .keypad0
        default:
            print("未能识别：\(keyCode.rawValue.description)")
        }
        return nil
    }
}
