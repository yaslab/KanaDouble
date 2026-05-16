//
//  AppMenu.swift
//  KanaDouble
//
//  Created by Yasuhiro Hatta on 2017/10/14.
//  Copyright © 2017 yaslab. All rights reserved.
//

import SwiftUI

struct AppMenu: View {
    @Environment(KeyboardEventService.self) private var keyboardEventService

    var body: some View {
        if keyboardEventService.isTapEnabled {
            Label("Accessibility permissions have been granted", systemImage: "checkmark.rectangle")
        } else {
            Label("Accessibility permissions are not available", systemImage: "exclamationmark.triangle")
        }
        SettingsLink {
            Label("Settings...", systemImage: "gear")
        }
        Button("Quit KanaDouble", systemImage: "xmark.rectangle") {
            NSApp.terminate(nil)
        }
    }
}
