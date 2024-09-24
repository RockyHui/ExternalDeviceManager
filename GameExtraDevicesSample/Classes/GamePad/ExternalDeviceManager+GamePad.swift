//
//  ExternalDeviceManager+GamePad.swift
//  
//
//  Created by Hui Linchao on 2024/9/9.
//  Copyright © 2024 cook. All rights reserved.
//
//
//          游戏手柄🎮
//

import Foundation
import GameController

extension ExternalDeviceManager {

    /// 开启手柄相关事件监听
    func startGamePadObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(gamePadDidConnect), name: NSNotification.Name.GCControllerDidConnect, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(gamePadDidDisconnect), name: NSNotification.Name.GCControllerDidDisconnect, object: nil)
        if #available(iOS 14.0, *) {
            NotificationCenter.default.addObserver(self, selector: #selector(gamePadDidBecomeCurrent), name: NSNotification.Name.GCControllerDidBecomeCurrent, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(gamePadDidStopBeingCurrent), name: NSNotification.Name.GCControllerDidStopBeingCurrent, object: nil)
        }
    }
    
    /// 停止手柄相关事件监听
    func stopGamePadObservers() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.GCControllerDidConnect, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.GCControllerDidDisconnect, object: nil)
        if #available(iOS 14.0, *) {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.GCControllerDidBecomeCurrent, object: nil)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.GCControllerDidStopBeingCurrent, object: nil)
        }
        if #available(iOS 16.0, *) {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.GCControllerUserCustomizationsDidChange, object: nil)
        }
    }
    
    // MARK: - Notification
    
    @objc func gamePadDidConnect(notification: Notification) {
        guard let controller = notification.object as? GCController else { return }
        print("手柄连上：序号\(controller.playerIndex.rawValue) 名称：\(controller.vendorName ?? "") 型号：\(controller.productCategory)")
        
        #if DEBUG
        if let identifier = controller.value(forKey: "identifier") {
            print("手柄连上了，设备私有ID：\(identifier)")
        }
        #endif
        let model = setupGameController(controller: controller)
        NotificationCenter.default.post(name: .gamePadConnected, object: model)
    }
    
    @objc func gamePadDidDisconnect(notification: Notification) {
        guard let controller = notification.object as? GCController else { return }
        print("手柄[\(controller.playerIndex.rawValue)]断开连接 名称：\(controller.vendorName ?? "") 型号：\(controller.productCategory)")
        let model = removeGameController(controller: controller)
        NotificationCenter.default.post(name: .gamePadDisConnected, object: model)
    }
    
    @objc func gamePadDidBecomeCurrent(notification: Notification) {
        guard let controller = notification.object as? GCController else { return }
        print("手柄[\(controller.playerIndex.rawValue)]激活 名称：\(controller.vendorName ?? "") 型号：\(controller.productCategory)")
    }
    
    @objc func gamePadDidStopBeingCurrent(notification: Notification) {
        guard let controller = notification.object as? GCController else { return }
        print("手柄[\(controller.playerIndex.rawValue)]休眠 名称：\(controller.vendorName ?? "") 型号：\(controller.productCategory)")
    }
    
    // MARK: - Action
    
    private func removeGameController(controller: GCController) -> GamePadModel? {
        if controller.playerIndex != .indexUnset {
            if let indexObject = GamePadIndex(rawValue: controller.playerIndex.rawValue) {
                let model = gamePads.removeValue(forKey: indexObject)
                print("移除手柄[\(indexObject.rawValue)]")
                return model
            }
        }
        return nil
    }
    
    private func setupGameController(controller: GCController) -> GamePadModel? {
        let searchSequence: [GCControllerPlayerIndex] = [.index1, .index2, .index3, .index4]
        for oneIndex in searchSequence {
            let indexObject = GamePadIndex(rawValue: oneIndex.rawValue) ?? .index1
            if gamePads[indexObject] == nil { // 找到第一个为空的位置
                controller.playerIndex = oneIndex
                print("分配手柄序号：\(oneIndex.rawValue)")
                break
            }
        }
        
        if controller.playerIndex != .indexUnset {
            let gamePadModel = GamePadModel()
            gamePadModel.categoryName = controller.productCategory
            gamePadModel.displayName = controller.vendorName
            gamePadModel.index = GamePadIndex(rawValue: controller.playerIndex.rawValue) ?? .index1
            gamePadModel.gameController = controller
            if let gamepad = controller.extendedGamepad {
                if #available(iOS 14.0, *) {
                    if gamepad is GCXboxGamepad {
                        gamePadModel.category = .XBox
                    }
                    if gamepad is GCDualShockGamepad { // PS4
                        gamePadModel.category = .DualShock
                    }
                }
                if #available(iOS 14.5, *) {
                    if gamepad is GCDualSenseGamepad { // PS5
                        gamePadModel.category = .DualSense
                    }
                }
                
            }
            gamePadModel.keyButtonCallBack = { [weak self] model, button, pressed in
                self?.gamepadButtonCallBack?(model, button, .button(pressed: pressed))
            }
            gamePadModel.intensityButtonCallBack = { [weak self] model, button, intensity in
                self?.gamepadButtonCallBack?(model, button, .intensity(intensity: intensity))
            }
            gamePadModel.dimensionButtonCallBack = { [weak self] model, button, point in
                self?.gamepadButtonCallBack?(model, button, .dimension(point: point))
            }
            gamePads[gamePadModel.index] = gamePadModel
            
            return gamePadModel
        }
        return nil
    }
    
    // MARK: - Public
    
    /// 获取当前连接上的设备数量
    /// - Returns: 返回结果
    func getAttachedGamePadCount() -> Int {
        return gamePads.keys.count
    }
    
}
