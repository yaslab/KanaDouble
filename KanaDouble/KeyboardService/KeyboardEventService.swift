//
//  KeyboardEventService.swift
//  KanaDouble
//
//  Created by Yasuhiro Hatta on 2017/10/13.
//  Copyright © 2017 yaslab. All rights reserved.
//

@preconcurrency import ApplicationServices
import Carbon.HIToolbox
import Cocoa
import CoreGraphics
import Foundation
import Observation

@Observable
class KeyboardEventService {
    private let store: UserDefaults

    init(store: UserDefaults) {
        self.store = store
    }

    private(set) var isTapEnabled: Bool = false

    @ObservationIgnored
    private lazy var tap: CFMachPort = {
        let eventsOfInterest: [CGEventType] = [.keyDown, .keyUp, .flagsChanged]
        let callback: CGEventTapCallBack = { _, type, event, context in
            let `self` = unsafeBitCast(context, to: KeyboardEventService.self)
            guard let converted = self.handleEvent(type: type, event: event) else {
                return nil
            }
            return Unmanaged.passUnretained(converted)
        }
        let _tap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: eventsOfInterest.reduce(0) { $0 | (1 << $1.rawValue) },
            callback: callback,
            userInfo: unsafeBitCast(self, to: UnsafeMutableRawPointer.self)
        )!
        CFRunLoopAddSource(
            CFRunLoopGetCurrent(),  // Current is always the @MainActor
            CFMachPortCreateRunLoopSource(nil, _tap, 0),
            .commonModes
        )
        return _tap
    }()

    @ObservationIgnored
    private var keyDownTime: TimeInterval?

    @ObservationIgnored
    private var keyDown_2: (count: Int, keyDownTime: TimeInterval)?

    func start() async throws {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue(): true]
        if AXIsProcessTrustedWithOptions(options as CFDictionary) == false {
            repeat {
                // DEBUG
                print("Trusted = false")

                try await Task.sleep(for: .seconds(2.5))
            } while AXIsProcessTrusted() == false
        }

        // DEBUG
        print("Trusted = true")

        CGEvent.tapEnable(tap: tap, enable: true)

        isTapEnabled = true
    }
}

extension KeyboardEventService {
    // MARK: - Event handler

    private func handleEvent(type: CGEventType, event: CGEvent) -> CGEvent? {
        switch type {
        case .keyDown:
            return onKeyDown(event)
        case .keyUp:
            return onKeyUp(event)
        case .flagsChanged:
            return onFlagsChanged(event)
        default:
            return event
        }
    }

    // MARK: - Keyboard events

    private func onKeyDown(_ event: CGEvent) -> CGEvent? {
        // DEBUG
        print("key down: 0x\(String(event.getIntegerValueField(.keyboardEventKeycode), radix: 16))")

        keyDownTime = nil
        return event
    }

    private func onKeyUp(_ event: CGEvent) -> CGEvent? {
        // DEBUG
        print("key up: 0x\(String(event.getIntegerValueField(.keyboardEventKeycode), radix: 16))")

        //keyDownTime = nil
        return event
    }

    private func onFlagsChanged(_ event: CGEvent) -> CGEvent? {
        let keycode = event.getIntegerValueField(.keyboardEventKeycode)
        let mask: CGEventFlags

        switch Int(keycode) {
        case kVK_Command, kVK_Command:
            mask = .maskCommand
        case kVK_Control, kVK_Control:
            mask = .maskControl
        case kVK_Option, kVK_RightOption:
            mask = .maskAlternate
        case kVK_Shift, kVK_RightShift:
            mask = .maskShift
        default:
            return event
        }

        if event.flags.contains(mask) {
            // down
            onTargetKeyDown(mask: mask, event)
        } else {
            // up
            onTargetKeyUp(mask: mask, event)
        }

        return event
    }

    private func onTargetKeyDown(mask: CGEventFlags, _ event: CGEvent) {
        let modifierKey = store.modifierKey

        // DEBUG
        print("key down *: 0x\(String(event.getIntegerValueField(.keyboardEventKeycode), radix: 16))")

        // Long Press
        if mask.contains(modifierKey.flag) {
            let now = event.timeInterval
            keyDownTime = now
        }

        // Double Tap
        if mask.contains(modifierKey.flag) {
            let now = event.timeInterval

            //let boundary = store.boundary
            let timeout = store.timeout

            if let (count, keyDownTime) = keyDown_2 {
                if count == 1 {
                    keyDown_2 = (2, keyDownTime)
                }
            } else {
                keyDown_2 = (1, now)

                Task {
                    try await Task.sleep(for: .seconds(timeout))
                    keyDown_2 = nil
                }
            }
        }
    }

    private func onTargetKeyUp(mask: CGEventFlags, _ event: CGEvent) {
        let modifierKey = store.modifierKey

        // DEBUG
        print("key up *: 0x\(String(event.getIntegerValueField(.keyboardEventKeycode), radix: 16))")

        // Long Press
        if mask.contains(modifierKey.flag), let keyDownTime {
            let now = event.timeInterval

            // DEBUG
            print("  \(now - keyDownTime)")

            let boundary = store.boundary
            let timeout = store.timeout

            if now < (keyDownTime + boundary) {
                CGEvent.postKeyDownUpEvent(virtualKey: kVK_JIS_Eisu)
            } else if now < (keyDownTime + timeout) {
                CGEvent.postKeyDownUpEvent(virtualKey: kVK_JIS_Kana)
            }

            self.keyDownTime = nil
        }

        // Double Tap
        if mask.contains(modifierKey.flag), let (count, keyDownTime) = keyDown_2 {
            // DEBUG
            print("double tap: \(count)")

            if count == 2 {
                let now = event.timeInterval

                //let boundary = store.boundary
                let timeout = store.timeout

                // DEBUG
                print("  * \(now - keyDownTime)")

                if now < (keyDownTime + timeout) {
                    let wk = NSWorkspace.shared
                    if let url = wk.urlForApplication(withBundleIdentifier: "com.apple.apps.launcher") {
                        wk.openApplication(
                            at: url,
                            configuration: NSWorkspace.OpenConfiguration()
                        )
                    }
                }

                self.keyDown_2 = nil
            }
        }
    }
}
