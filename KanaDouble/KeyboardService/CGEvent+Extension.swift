//
//  CGEvent+Extension.swift
//  KanaDouble
//
//  Created by Yasuhiro Hatta on 2017/10/14.
//  Copyright © 2017 yaslab. All rights reserved.
//

import CoreGraphics
import Foundation

extension CGEvent {
    static func postKeyDownUpEvent(virtualKey vk: Int, flags: CGEventFlags = []) {
        _post(virtualKey: vk, flags: flags, keyDown: true)
        _post(virtualKey: vk, flags: flags, keyDown: false)
    }

    static func postKeyDownEvent(virtualKey vk: Int, flags: CGEventFlags = []) {
        _post(virtualKey: vk, flags: flags, keyDown: true)
    }

    static func postKeyUpEvent(virtualKey vk: Int, flags: CGEventFlags = []) {
        _post(virtualKey: vk, flags: flags, keyDown: false)
    }

    private static func _post(virtualKey vk: Int, flags: CGEventFlags, keyDown: Bool) {
        let event = CGEvent(
            keyboardEventSource: nil,
            virtualKey: CGKeyCode(vk),
            keyDown: keyDown
        )!
        event.flags = flags
        event.post(tap: .cghidEventTap)
    }
}

extension CGEvent {
    var timeInterval: TimeInterval {
        return TimeInterval(timestamp) / TimeInterval(NSEC_PER_SEC)
    }
}
