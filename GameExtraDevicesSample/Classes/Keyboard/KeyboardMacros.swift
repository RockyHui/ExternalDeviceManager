//
//  KeyboardMacros.swift
//  
//
//  Created by Hui Linchao on 2024/9/9.
//  Copyright © 2024 cook. All rights reserved.
//

import UIKit

typealias KeyboardButtonInputCallBack = (_ key: KeyboardValueType, _ preesed: Bool) -> Void

extension Notification.Name {
    /// 键盘连接通知
    static let keyboardConnected = Notification.Name("keyboardConnected")
    /// 键盘断开通知
    static let keyboardDisConnected = Notification.Name("keyboardDisConnected")
}

/// 键盘按键
enum KeyboardValueType: String, CaseIterable {
    case A
    case B
    case C
    case D
    case E
    case F
    case G
    case H
    case I
    case J
    case K
    case L
    case M
    case N
    case O
    case P
    case Q
    case R
    case S
    case T
    case U
    case V
    case W
    case X
    case Y
    case Z
    case Backspace
    case Space
    case Caps
    case Enter
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case zero = "0"
    case F1
    case F2
    case F3
    case F4
    case F5
    case F6
    case F7
    case F8
    case F9
    case F10
    case F11
    case F12
    case Esc
    case Tab
    case PrtScr
    case ScrLK
    case Pause
    case Ins
    case Home
    case PgUp
    case Del
    case End
    case PgDn
    case ArrowUp
    case ArrowDown
    case ArrowLeft
    case ArrowRight
    case gamepadArrowUp
    case gamepadArrowDown
    case gamepadArrowLeft
    case gamepadArrowRight
    case Tilde = "~  `"
    case Hyphen = "-_"
    case EqualSign = "+="
    case OpenBracket = "[  {"
    case CloseBracket = "]  }"
    case Backslash = "|  \\"
    case Semicolon = ";  :"
    case Quote = "\"  \'"
    case Comma = "<  ,"
    case Period = "<  ."
    case Slash = "?  /"
    case LeftControl = "Ctrl" /* Left Control */

    case LeftShift = "Shift" /* Left Shift */

    case LeftAlt = "Alt" /* Left Alt */

    case LeftWin = "Win" /* Left Win */

    case RightControl = "Ctrl " /* Right Control */

    case RightShift = "Shift " /* Right Shift */

    case RightAlt = "Alt " /* Right Alt */

    case RightWin = "Win " /* Right Win */
    
    case Menu = "Menu"
    
    case keypadNum = "Num"

    case keypadSlash = "/" /* Keypad / */

    case keypadAsterisk = "*" /* Keypad * */

    case keypadHyphen = "-" /* Keypad - */

    case keypadPlus = "+" /* Keypad + */

    case keypad1 = "Num1" /* Keypad 1 or End */

    case keypad2 = "Num2" /* Keypad 2 or Down Arrow */

    case keypad3 = "Num3" /* Keypad 3 or Page Down */

    case keypad4 = "Num4" /* Keypad 4 or Left Arrow */

    case keypad5 = "Num5" /* Keypad 5 */

    case keypad6 = "Num6" /* Keypad 6 or Right Arrow */

    case keypad7 = "Num7" /* Keypad 7 or Home */

    case keypad8 = "Num8" /* Keypad 8 or Up Arrow */

    case keypad9 = "Num9" /* Keypad 9 or Page Up */

    case keypad0 = "Num0" /* Keypad 0 or Insert */
    
    case keypadPeriod = "."
    
    case keypadEnter = "NumEnter"
}
