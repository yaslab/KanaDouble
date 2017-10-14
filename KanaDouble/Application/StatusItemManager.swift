//
//  StatusItemManager.swift
//  KanaDouble
//
//  Created by Yasuhiro Hatta on 2017/10/14.
//  Copyright © 2017 yaslab. All rights reserved.
//

import Cocoa

class StatusItemManager {
    
    static let shared = StatusItemManager()
    
    private let statusItem: NSStatusItem
    
    private init() {
        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    }
    
    func setup() {
        let menu = NSMenu()
        menu.addItem(withTitle: "Open window", action: .onOpenWindowItemClick, keyEquivalent: "")
        menu.addItem(withTitle: "Quit", action: .onQuitItemClick, keyEquivalent: "")
        
        statusItem.title = ".25"
        statusItem.highlightMode = true
        statusItem.menu = menu
    }

}

extension Selector {
    
    fileprivate static let onOpenWindowItemClick = #selector(AppDelegate.onOpenWindowItemClick(_:))
    fileprivate static let onQuitItemClick = #selector(AppDelegate.onQuitItemClick(_:))

}

extension AppDelegate {
    
    @objc fileprivate func onOpenWindowItemClick(_ sender: NSMenuItem) {
        showWindow()
    }
    
    @objc fileprivate func onQuitItemClick(_ sender: NSMenuItem) {
        NSApp.terminate(nil)
    }

}
