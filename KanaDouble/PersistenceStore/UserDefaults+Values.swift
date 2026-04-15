//
//  UserDefaults+Values.swift
//  KanaDouble
//
//  Created by Yasuhiro Hatta on 2017/10/18.
//  Copyright © 2017 yaslab. All rights reserved.
//

import CoreGraphics
import Foundation

private struct Keys {
    static let isInitialAutoStartSetupCompleted = "KanaDouble.isInitialAutoStartSetupCompleted"
    static let modifierKey = "KanaDouble.modifierKey"
    static let boundary = "KanaDouble.boundary"
    static let timeout = "KanaDouble.timeout"
}

extension UserDefaults {
    static let defaultModifierKey: ModifierKey = .command

    func register() {
        register(
            defaults: [
                Keys.boundary: 0.25,
                Keys.timeout: 0.75,
            ]
        )
    }
}

extension UserDefaults {
    var isInitialAutoStartSetupCompleted: Bool {
        get { bool(forKey: Keys.isInitialAutoStartSetupCompleted) }
        set { set(newValue, forKey: Keys.isInitialAutoStartSetupCompleted) }
    }

    var modifierKey: ModifierKey {
        get {
            guard let string = string(forKey: Keys.modifierKey) else {
                return UserDefaults.defaultModifierKey
            }
            guard let key = ModifierKey(rawValue: string) else {
                return UserDefaults.defaultModifierKey
            }
            return key
        }
        set { set(newValue.rawValue, forKey: Keys.modifierKey) }
    }

    var boundary: Double {
        get { double(forKey: Keys.boundary) }
        set { set(newValue, forKey: Keys.boundary) }
    }

    var timeout: Double {
        get { double(forKey: Keys.timeout) }
        set { set(newValue, forKey: Keys.timeout) }
    }
}
