//
//  SettingsModel.swift
//  KanaDouble
//
//  Created by Yasuhiro Hatta on 2026/04/18.
//

import Combine
import Foundation
import Observation

@Observable
class SettingsModel {
    private let store: UserDefaults

    var modifierKey: ModifierKey {
        didSet {
            store.modifierKey = modifierKey
        }
    }

    var boundary: Double {
        didSet {
            store.boundary = boundary
        }
    }

    var timeout: Double {
        didSet {
            store.timeout = timeout
        }
    }

    init(store: UserDefaults) {
        self.store = store

        modifierKey = store.modifierKey
        boundary = store.boundary
        timeout = store.timeout
    }

    func fetchValues() {
        modifierKey = store.modifierKey
        boundary = store.boundary
        timeout = store.timeout
    }
}
