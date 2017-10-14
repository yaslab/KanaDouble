//
//  AppDelegate.swift
//  AutoLaunchHelper
//
//  Created by Yasuhiro Hatta on 2017/10/14.
//  Copyright © 2017 yaslab. All rights reserved.
//

import Cocoa

private let kMainAppName = "KanaDouble"
private let kMainAppBundleIdentifier = "net.yaslab.\(kMainAppName)"
private let kMainAppURLScheme: URL = {
    var builder = URLComponents()
    builder.scheme = kMainAppName
    return builder.url!
}()

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ notification: Notification) {
        let apps = NSRunningApplication.runningApplications(withBundleIdentifier: kMainAppBundleIdentifier)
        if apps.count == 0 || apps[0].isActive == false {
            NSWorkspace.shared.open(kMainAppURLScheme)
        }
        
        // Quit
        NSApp.perform(#selector(NSApplication.terminate(_:)), with: nil, afterDelay: 0.0)
    }

}
