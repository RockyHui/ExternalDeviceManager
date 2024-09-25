//
//  ExternalDeviceManager+Mouse.swift
//  
//
//  Created by cook on 2024/9/9.
//  Copyright © 2024 cook. All rights reserved.
//
//
//          鼠标🖱️
//

import UIKit
import GameController

extension ExternalDeviceManager {

    /// 开启鼠标事件监听
    public func startMouseDeviceObservers() {
        if #available(iOS 14.0, *) {
            NotificationCenter.default.addObserver(self, selector: #selector(mouseDidConnect), name: NSNotification.Name.GCMouseDidConnect, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(mouseDidDisconnect), name: NSNotification.Name.GCMouseDidDisconnect, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(mouseDidBecomeCurrent), name: NSNotification.Name.GCMouseDidBecomeCurrent, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(mouseDidStopBeingCurrent), name: NSNotification.Name.GCMouseDidStopBeingCurrent, object: nil)
            if let mouse = GCMouse.mice().first {
                configureMouse(mouse)
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    /// 移除鼠标事件监听
    public func stopMouseDeviceObservers() {
        if #available(iOS 14.0, *) {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.GCMouseDidConnect, object: nil)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.GCMouseDidDisconnect, object: nil)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.GCMouseDidBecomeCurrent, object: nil)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.GCMouseDidStopBeingCurrent, object: nil)
        } else {
            // Fallback on earlier versions
        }
    }
    
    /// 鼠标连接上通知
    @objc private func mouseDidConnect(notification: Notification) {
        if #available(iOS 14.0, *) {
            print("[鼠标] 连接通知")
            guard let mouseObject = notification.object as? GCMouse else {
                return
            }
            configureMouse(mouseObject)
        } else {
            // Fallback on earlier versions
        }
    }
    
    @available(iOS 14.0, *)
    private func configureMouse(_ mouse: GCMouse) {
        let mouseModel = MouseDeviceModel()
        mouseModel.bindMouseEventHandler(mouse: mouse)
        mouseModel.mouseButtonCallBack = { [weak self] model, button, pressed in
            self?.mouseButtonCallBack?(model, button, pressed)
        }
        mouseModel.mouseMoveCallBack = { [weak self] model, point in
            self?.mouseMoveCallBack?(model, point)
        }
        mouseModel.mouseScrollCallBack = { [weak self] model, point in
            self?.mouseScrollCallBack?(model, point)
        }
        // 避免重复添加
        if !self.mouseArr.contains(where: { oneModel in
            return oneModel.mouseObjectId == mouseModel.mouseObjectId
        }) {
            self.mouseArr.append(mouseModel)
            NotificationCenter.default.post(name: .mouseConnected, object: mouse)
        }
    }
    
    /// 鼠标断开通知
    @objc private func mouseDidDisconnect(notification: Notification) {
        if #available(iOS 14.0, *) {
            print("[鼠标] 断开通知")
            guard let mouseObject = notification.object as? GCMouse else { return }
            for (index, mouseModel) in self.mouseArr.enumerated() {
                if mouseModel.mouseObjectId == mouseObject.hashValue {
                    mouseArr.remove(at: index)
                    break
                }
            }
            NotificationCenter.default.post(name: .mouseDisConnected, object: nil)
        } else {
            // Fallback on earlier versions
        }
    }
    
    /// 鼠标激活通知
    @objc private func mouseDidBecomeCurrent(notification: Notification) {
        if #available(iOS 14.0, *) {
            print("[鼠标] 激活通知")
//            guard let mouseObject = notification.object as? GCMouse else { return }
        } else {
            // Fallback on earlier versions
        }
    }
    
    /// 鼠标休眠通知
    @objc private func mouseDidStopBeingCurrent(notification: Notification) {
        if #available(iOS 14.0, *) {
            print("[鼠标] 休眠通知")
//            guard let mouseObject = notification.object as? GCMouse else { return }
        } else {
            // Fallback on earlier versions
        }
    }
    
    // MARK: - Public
    
    /// 获取连接上的鼠标个数
    /// - Returns: 返回结果
    func getAttachedMouseCount() -> Int {
        return mouseArr.count
    }
}
