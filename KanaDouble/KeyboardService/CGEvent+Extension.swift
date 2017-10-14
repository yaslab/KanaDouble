//
//  CGEvent+Extension.swift
//  KanaDouble
//
//  Created by Yasuhiro Hatta on 2017/10/14.
//  Copyright © 2017 yaslab. All rights reserved.
//

import Cocoa

extension CGEvent {
    
    static func postKeyDownUpEvent(virtualKey vk: CGKeyCode, flags: CGEventFlags = []) {
        _post(virtualKey: vk, flags: flags, keyDown: true)
        _post(virtualKey: vk, flags: flags, keyDown: false)
    }
    
    static func postKeyDownEvent(virtualKey vk: CGKeyCode, flags: CGEventFlags = []) {
        _post(virtualKey: vk, flags: flags, keyDown: true)
    }
    
    static func postKeyUpEvent(virtualKey vk: CGKeyCode, flags: CGEventFlags = []) {
        _post(virtualKey: vk, flags: flags, keyDown: false)
    }
    
    private static func _post(virtualKey vk: CGKeyCode, flags: CGEventFlags, keyDown: Bool) {
        let event = CGEvent(keyboardEventSource: nil, virtualKey: vk, keyDown: keyDown)!
        event.flags = flags
        event.post(tap: .cghidEventTap)
    }
    
}

extension CGEvent {
    
    var keyCode: CGKeyCode {
        return CGKeyCode(getIntegerValueField(.keyboardEventKeycode))
    }
    
}

extension CGEventFlags {

    static let maskLeftShift: CGEventFlags      = [.maskShift, .init(rawValue: 0b00000000_00000010)]
    static let maskRightShift: CGEventFlags     = [.maskShift, .init(rawValue: 0b00000000_00000100)]

    static let maskLeftControl: CGEventFlags    = [.maskControl, .init(rawValue: 0b00000000_00000001)]
    static let maskRightControl: CGEventFlags   = [.maskControl, .init(rawValue: 0b00100000_00000000)]

    static let maskLeftAlternate: CGEventFlags  = [.maskAlternate, .init(rawValue: 0b00000000_00100000)]
    static let maskRightAlternate: CGEventFlags = [.maskAlternate, .init(rawValue: 0b00000000_01000000)]

    static let maskLeftCommand: CGEventFlags    = [.maskCommand, .init(rawValue: 0b00000000_00010000)]
    static let maskRightCommand: CGEventFlags   = [.maskCommand, .init(rawValue: 0b00000000_00001000)]
    
}

extension CGEventFlags {
    
    func compare(_ other: CGEventFlags, contains flags: CGEventFlags) -> Bool {
        return self.contains(flags) && other.contains(flags)
    }
    
}
