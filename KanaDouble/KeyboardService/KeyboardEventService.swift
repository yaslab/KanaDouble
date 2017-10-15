//
//  KeyboardEventService.swift
//  KanaDouble
//
//  Created by Yasuhiro Hatta on 2017/10/13.
//  Copyright © 2017 yaslab. All rights reserved.
//

import Cocoa

class KeyboardEventService {

    static let shared = KeyboardEventService()
    
    private let queue = DispatchQueue(label: "net.yaslab.KanaDouble.KeyboardEventService.queue")
    private var event: CFMachPort?
    
    private var lastFlagsChangeDate: Date?
    
    private var timer: DispatchSourceTimer?
    
    private init() {}
    
    func start() {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue(): true]
        guard AXIsProcessTrustedWithOptions(options as CFDictionary) else {
            startTimerToMonitorProcessTrust { [weak self] in
                self?.startMonitoringKeyboardEvents()
            }
            return
        }
        
        startMonitoringKeyboardEvents()
    }
    
    private func startTimerToMonitorProcessTrust(_ handler: @escaping () -> Void) {
        let label = "net.yaslab.KanaDouble.KeyboardEventService.timer"
        let timerQueue = DispatchQueue(label: label)
        let timer = DispatchSource.makeTimerSource(queue: timerQueue)
        self.timer = timer
        timer.schedule(deadline: .now(), repeating: .seconds(5), leeway: .milliseconds(100))
        timer.setEventHandler { [weak self] in
            if AXIsProcessTrusted() {
                if let `self` = self {
                    self.timer?.cancel()
                    self.timer = nil
                    handler()
                }
            }
        }
        timer.resume()
    }
    
    private func startMonitoringKeyboardEvents() {
        if self.event != nil {
            fatalError()
        }
        
        let eventsOfInterest: [CGEventType] = [.keyDown, .keyUp, .flagsChanged]
        let callback: CGEventTapCallBack = { (proxy, type, event, refcon) in
            let `self` = unsafeBitCast(refcon, to: KeyboardEventService.self)
            guard let converted = self.handleEvent(type: type, event: event) else {
                return nil
            }
            return Unmanaged.passUnretained(converted)
        }
        self.event = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: eventsOfInterest.reduce(0) { $0 | (1 << $1.rawValue) },
            callback: callback,
            userInfo: unsafeBitCast(self, to: UnsafeMutableRawPointer.self)
        )
        
        guard let event = self.event else {
            fatalError()
        }
        
        queue.async {
            let runLoop = CFRunLoopGetCurrent()
            let source = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, event, 0)
            CFRunLoopAddSource(runLoop, source, .commonModes)
            CGEvent.tapEnable(tap: event, enable: true)
            CFRunLoopRun()
        }
    }

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
        lastFlagsChangeDate = nil
        return event
    }
    
    private func onKeyUp(_ event: CGEvent) -> CGEvent? {
        lastFlagsChangeDate = nil
        return event
    }
    
    private func onFlagsChanged(_ event: CGEvent) -> CGEvent? {
        let modifierFlag = CGEventFlags(rawValue: UInt64(UserDefaults.standard.integer(forKey: .udModifierFlag)))
        
        if event.flags.contains(modifierFlag) {
            let now = Date()
            if let lastDate = lastFlagsChangeDate {
                // DEBUG
                print(now.timeIntervalSince(lastDate))
                
                let boundary = UserDefaults.standard.double(forKey: .udBoundary)
                let timeout = UserDefaults.standard.double(forKey: .udTimeout)
                
                let future1 = lastDate.addingTimeInterval(boundary)
                let future2 = lastDate.addingTimeInterval(timeout)
                if lastDate <= now && now < future1 {
                    CGEvent.postKeyDownUpEvent(virtualKey: .vkJISEisu)
                    lastFlagsChangeDate = nil
                } else if future1 <= now && now < future2 {
                    CGEvent.postKeyDownUpEvent(virtualKey: .vkJISKana)
                    lastFlagsChangeDate = nil
                } else {
                    lastFlagsChangeDate = now
                }
            } else {
                lastFlagsChangeDate = now
            }
        }
        return event
    }
    
}
