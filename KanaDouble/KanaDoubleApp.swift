//
//  KanaDoubleApp.swift
//  KanaDouble
//
//  Created by Yasuhiro Hatta on 2017/10/13.
//  Copyright © 2017 yaslab. All rights reserved.
//

import SwiftUI

private let liveResolver: DIResolver = .live()

@main
struct KanaDoubleApp: App {
    @NSApplicationDelegateAdaptor
    private var delegate: AppDelegate

    var body: some Scene {
        MenuBarExtra {
            AppMenu()
                .environment(liveResolver.resolve() as KeyboardEventService)
        } label: {
            MenuBarButton()
                .environment(liveResolver.resolve() as SettingsModel)
        }
        .menuBarExtraStyle(.menu)

        Settings {
            SettingsView()
                .environment(liveResolver.resolve() as SettingsModel)
                .environment(liveResolver.resolve() as AutoStartModel)
        }
    }
}

private class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        let service: KeyboardEventService = liveResolver.resolve()
        let autoStartModel: AutoStartModel = liveResolver.resolve()

        UserDefaults.standard.register()
        autoStartModel.setup()

        Task {
            try await service.start()
        }
    }
}
