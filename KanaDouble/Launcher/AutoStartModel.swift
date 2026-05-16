//
//  AutoStartModel.swift
//  KanaDouble
//
//  Created by Yasuhiro Hatta on 2022/08/28.
//

import Observation
import ServiceManagement

@Observable
class AutoStartModel {
    private let store: UserDefaults
    private let manager: AutoStartManager
    private var status: SMAppService.Status

    init(store: UserDefaults, manager: AutoStartManager) {
        self.store = store
        self.manager = manager
        self.status = manager.status
    }

    var isEnabled: Bool {
        get { status == .enabled }
        set { onChange(enabled: newValue) }
    }

    func register() throws {
        try manager.register()
        fetchStatus()
    }

    func unregister() throws {
        try manager.unregister()
        fetchStatus()
    }

    func openSystemSettingsLoginItems() {
        manager.openSystemSettingsLoginItems()
    }

    func fetchStatus() {
        status = manager.status
    }
}

extension AutoStartModel {
    func setup() {
        if store.isInitialAutoStartSetupCompleted {
            return
        }

        do {
            try register()
        } catch {
            fetchStatus()
        }

        store.isInitialAutoStartSetupCompleted = true
    }

    private func onChange(enabled: Bool) {
        do {
            if enabled {
                try register()
            } else {
                try unregister()
            }
        } catch {
            fetchStatus()
        }
    }
}
