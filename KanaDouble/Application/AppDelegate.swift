//
//  AppDelegate.swift
//  KanaDouble
//
//  Created by Yasuhiro Hatta on 2017/10/13.
//  Copyright © 2017 yaslab. All rights reserved.
//

import Cocoa
import ServiceManagement

private let kHelperAppName = "AutoLaunchHelper"
private let kHelperAppBundleIdentifier = Bundle.main.bundleIdentifier! + "." + kHelperAppName

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    private var windowController: NSWindowController?

    func applicationDidFinishLaunching(_ notification: Notification) {
        StatusItemManager.shared.setup()
        KeyboardEventService.shared.start()
        _ = SMLoginItemSetEnabled(kHelperAppBundleIdentifier as CFString, true)

        let storyboard = NSStoryboard(name: .init(rawValue: "Main"), bundle: .main)
        windowController = storyboard.instantiateController(withIdentifier: .init(rawValue: "MainWindowController")) as? NSWindowController
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }

    // MARK: - Utility
    
    func showWindow() {
        if let wc = windowController, let win = wc.window, win.isKeyWindow == false {
            wc.showWindow(NSApp)
            wc.window?.makeKeyAndOrderFront(NSApp)
            NSApp.activate(ignoringOtherApps: true)
        }
    }
    
}
