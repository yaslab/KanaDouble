//
//  DIResolver.swift
//  KanaDouble
//
//  Created by Yasuhiro Hatta on 2026/04/19.
//

import Foundation

class DIResolver {
    init(
        store: UserDefaults,
        autoStartManager: AutoStartManager
    ) {
        sharedKeyboardEventService = KeyboardEventService(
            store: store
        )
        sharedAutoStartModel = AutoStartModel(
            store: store,
            manager: autoStartManager
        )
        sharedSettingsModel = SettingsModel(
            store: store
        )
    }

    // MARK: Service

    private let sharedKeyboardEventService: KeyboardEventService

    func resolve() -> KeyboardEventService {
        return sharedKeyboardEventService
    }

    // MARK: Model

    private let sharedAutoStartModel: AutoStartModel

    func resolve() -> AutoStartModel {
        return sharedAutoStartModel
    }

    private let sharedSettingsModel: SettingsModel

    func resolve() -> SettingsModel {
        return sharedSettingsModel
    }
}
