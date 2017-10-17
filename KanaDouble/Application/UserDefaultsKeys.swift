//
//  UserDefaultsKeys.swift
//  KanaDouble
//
//  Created by Yasuhiro Hatta on 2017/10/18.
//  Copyright © 2017 yaslab. All rights reserved.
//

import Cocoa

private let kModifierFlag = UserDefaults.Key<Int>("modifierFlag")
private let kBoundary = UserDefaults.Key<TimeInterval>("boundary")
private let kTimeout = UserDefaults.Key<TimeInterval>("timeout")

extension UserDefaults {
    
    static var initialValues: [String: Any] {
        return [
            kModifierFlag.name: Int(CGEventFlags.maskCommand.rawValue),
            kBoundary.name: 0.25 as TimeInterval,
            kTimeout.name: 0.75 as TimeInterval
        ]
    }
    
}

extension UserDefaults.Key {
    
    static var modifierFlag: UserDefaults.Key<Int> { return kModifierFlag }
    static var boundary: UserDefaults.Key<TimeInterval> { return kBoundary }
    static var timeout: UserDefaults.Key<TimeInterval> { return kTimeout }
    
}
