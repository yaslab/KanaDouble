//
//  MenuBarButton.swift
//  KanaDouble
//
//  Created by Yasuhiro Hatta on 2026/04/19.
//

import SwiftUI

struct MenuBarButton: View {
    @Environment(SettingsModel.self) private var settingsModel

    var body: some View {
        Label("KanaDouble", systemImage: settingsModel.modifierKey.icon)
    }
}
