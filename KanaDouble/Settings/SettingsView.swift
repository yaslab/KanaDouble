//
//  SettingsView.swift
//  KanaDouble
//
//  Created by Yasuhiro Hatta on 2017/10/13.
//  Copyright © 2017 yaslab. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @Environment(SettingsModel.self) private var settingsModel
    @Environment(AutoStartModel.self) private var autoStartModel

    var body: some View {
        content()
            .onAppear {
                settingsModel.fetchValues()
            }
    }

    private func content() -> some View {
        @Bindable var settingsModel = settingsModel
        @Bindable var autoStartModel = autoStartModel

        return Form {
            Picker("Key", selection: $settingsModel.modifierKey) {
                ForEach(ModifierKey.allCases) { key in
                    Text(key.title)
                }
            }

            slider(value: $settingsModel.boundary, label: "Boundary")
                .onChange(of: settingsModel.boundary) { oldValue, newValue in
                    if settingsModel.timeout < newValue {
                        settingsModel.timeout = newValue
                    }
                }

            slider(value: $settingsModel.timeout, label: "Timeout")
                .onChange(of: settingsModel.timeout) { oldValue, newValue in
                    if newValue < settingsModel.boundary {
                        settingsModel.boundary = newValue
                    }
                }

            Toggle("Launch at login", systemImage: "arrow.up.right", isOn: $autoStartModel.isEnabled)
        }
        .scenePadding()
        .frame(maxWidth: 350, minHeight: 100)
    }

    private func slider(value: Binding<Double>, label: String) -> some View {
        HStack {
            Slider(
                value: value,
                in: 0.1 ... 1.0,
                //step: 0.01,
                label: { Text(label) }
            )

            Text(value.wrappedValue.formatted(.number.precision(.fractionLength(2))))
                .monospacedDigit()
        }
    }
}
