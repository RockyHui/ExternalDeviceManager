//
//  ViewController.swift
//  GameExtraDevicesSample
//
//  Created by cook on 2024/9/23.
//

import UIKit
import ExternalDeviceManager

class ViewController: UIViewController {
    
    @IBOutlet weak var gamePadCountLabel: UILabel!
    
    @IBOutlet weak var gamePadOutputLabel: UILabel!
    
    @IBOutlet weak var keyboardCountLabel: UILabel!
    
    @IBOutlet weak var keyboardOutputLabel: UILabel!
    
    @IBOutlet weak var mouseCountLabel: UILabel!
    
    @IBOutlet weak var mouseOutputLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        receiveAllDeviceInputData()
        
        
        /// 开启对所有外设设备的监听
        ExternalDeviceManager.shared.startAllDeviceObservers()
        
        
        /// 单独监听某一类设备
        /*
         receiveGamePadInputData()
         ExternalDeviceManager.shared.startGamePadObservers()
         
         receiveKeyboardInputData()
         ExternalDeviceManager.shared.startKeyboardObservers()
         
         receiveMouseInputData()
         ExternalDeviceManager.shared.startMouseDeviceObservers()
         */
    }
    
    func receiveAllDeviceInputData() {
        receiveGamePadInputData()
        receiveKeyboardInputData()
        receiveMouseInputData()
    }
    
}


// MARK: - 手柄

extension ViewController {
    
    func receiveGamePadInputData() {
        /// 接受手柄数据回调
        ExternalDeviceManager.shared.gamepadButtonCallBack = { [weak self] model, button, data in
            var str = ""
            // model： 可以拿到手柄的相关信息
            str += "手柄 序号：\(model.index.rawValue) 型号：\(model.category.rawValue) \(model.categoryName ?? "") \(model.displayName ?? "")"
            // button： 表示手柄上具体哪个按键
            str += "\n"
            str += "\(button.description)"
            str += "\n"
            switch data {
            case .button(let pressed):
                str += pressed ? "按下" : "抬起"
                break
            case .dimension(let point):
                str += "x:\(point.x) y:\(point.y)"
                break
            case .intensity(let intensity):
                str += "力度：\(intensity)"
                break
            }
            
            self?.gamePadOutputLabel.text = str
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshGamePadCount), name: .gamePadConnected, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshGamePadCount), name: .gamePadDisConnected, object: nil)
    }
    
    @objc private func refreshGamePadCount() {
        let gamePadArr = ExternalDeviceManager.shared.gamePads
        let str = "当前连接的手柄个数：\(gamePadArr.count)"
        self.gamePadCountLabel.text = str
    }

}

// MARK: - 键盘

extension ViewController {
    
    func receiveKeyboardInputData() {
        
        ExternalDeviceManager.shared.keyBoardCallBack = { [weak self] button, pressed in
            var str = ""
            str += button.rawValue
            str += "\n"
            str += pressed ? "按下" : "抬起"
            self?.keyboardOutputLabel.text = str
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshKeyboardCount), name: .keyboardConnected, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshKeyboardCount), name: .keyboardDisConnected, object: nil)
    }
    
    @objc private func refreshKeyboardCount() {
        let keyboardArr = ExternalDeviceManager.shared.keyboardArr
        let str = "当前连接的键盘个数：\(keyboardArr.count)"
        self.keyboardCountLabel.text = str
    }
}

// MARK: - 鼠标

extension ViewController {
    
    func receiveMouseInputData() {
        
        ExternalDeviceManager.shared.mouseButtonCallBack = { [weak self] mouse, button, pressed in
            var str = ""
            str += "鼠标 \(mouse.categoryName ?? "") \(mouse.displayName ?? "")"
            str += "\n"
            str += "\(button.description)"
            str += "\n"
            str += pressed ? "按下" : "抬起"
            self?.mouseOutputLabel.text = str
        }
        
        ExternalDeviceManager.shared.mouseMoveCallBack = { [weak self] mouse, offset in
            var str = ""
            str += "鼠标 \(mouse.categoryName ?? "") \(mouse.displayName ?? "")"
            str += "\n"
            str += "移动 x:\(offset.x) y:\(offset.y)"
            self?.mouseOutputLabel.text = str
        }
        
        ExternalDeviceManager.shared.mouseScrollCallBack = { [weak self] mouse, offset in
            var str = ""
            str += "鼠标 \(mouse.categoryName ?? "") \(mouse.displayName ?? "")"
            str += "\n"
            str += "滚轮 x:\(offset.x) y:\(offset.y)"
            self?.mouseOutputLabel.text = str
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshMouseCount), name: .mouseConnected, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshMouseCount), name: .mouseDisConnected, object: nil)
    }
    
    @objc private func refreshMouseCount() {
        let mouseArr = ExternalDeviceManager.shared.mouseArr
        let str = "当前连接的鼠标个数：\(mouseArr.count)"
        self.mouseCountLabel.text = str
    }
}

