//
//  ModifierKey.swift
//  KanaDouble
//
//  Created by Yasuhiro Hatta on 2026/04/18.
//

import CoreGraphics

private let kShiftKeyCharacter = "\u{21E7}"
private let kCupsLockKeyCharacter = "\u{21EA}"
private let kControlKeyCharacter = "\u{2303}"
private let kOptionKeyCharacter = "\u{2325}"
private let kCommandKeyCharacter = "\u{2318}"
private let kFunctionKeyCharacter = "fn"

enum ModifierKey: String, CaseIterable {
    case control
    case option
    case command
    case shift

    var title: String {
        switch self {
        case .control:
            "\(kControlKeyCharacter) Control"
        case .option:
            "\(kOptionKeyCharacter) Option"
        case .command:
            "\(kCommandKeyCharacter) Command"
        case .shift:
            "\(kShiftKeyCharacter) Shift"
        }
    }

    var flag: CGEventFlags {
        switch self {
        case .control:
            .maskControl
        case .option:
            .maskAlternate
        case .command:
            .maskCommand
        case .shift:
            .maskShift
        }
    }

    var icon: String {
        switch self {
        case .control:
            "control"
        case .option:
            "option"
        case .command:
            "command"
        case .shift:
            "shift"
        }
    }
}

extension ModifierKey: Identifiable {
    var id: ModifierKey { self }
}
