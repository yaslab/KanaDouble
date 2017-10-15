//
//  ViewController.swift
//  KanaDouble
//
//  Created by Yasuhiro Hatta on 2017/10/13.
//  Copyright © 2017 yaslab. All rights reserved.
//

import Cocoa

extension String {
    
    static let udModifierFlag = "modifierFlag"
    static let udBoundary = "boundary"
    static let udTimeout = "timeout"
    
}

private let kShiftKeyCharacter = "\u{21E7}"
private let kCupsLockKeyCharacter = "\u{21EA}"
private let kControlKeyCharacter = "\u{2303}"
private let kOptionKeyCharacter = "\u{2325}"
private let kCommandKeyCharacter = "\u{2318}"
private let kFunctionKeyCharacter = "fn"

class ViewController: NSViewController {
    
    @IBOutlet private var modifierKeyPopUpButton: NSPopUpButton!
    //@IBOutlet private var modifierKeyPopUpButtonMenu: NSMenu!
    
    //@IBOutlet private var boundaryTextField: NSTextField!
    
    @IBOutlet private var boundarySlider: NSSlider!
    @IBOutlet private var boundaryLabel: NSTextField!
    
    @IBOutlet private var timeoutSlider: NSSlider!
    @IBOutlet private var timeoutLabel: NSTextField!

    private enum ModifierKeyMenuIndex: Int {
        case shift = 0
        //case cupsLock
        case control
        case option
        case command
        //case esc
        //case fn
    }
    
    private let modifierKeyMenuItems = [
        NSMenuItem(title: "\(kShiftKeyCharacter) Shift", action: #selector(onMenuItemSelect(_:)), keyEquivalent: ""),
        //NSMenuItem(title: "\(kCupsLockKeyCharacter) Cups Lock", action: #selector(onMenuItemSelect(_:)), keyEquivalent: ""),
        NSMenuItem(title: "\(kControlKeyCharacter) Control", action: #selector(onMenuItemSelect(_:)), keyEquivalent: ""),
        NSMenuItem(title: "\(kOptionKeyCharacter) Option", action: #selector(onMenuItemSelect(_:)), keyEquivalent: ""),
        NSMenuItem(title: "\(kCommandKeyCharacter) Command", action: #selector(onMenuItemSelect(_:)), keyEquivalent: ""),
        //NSMenuItem(title: "\u{238B} Esc", action: #selector(onMenuItemSelect(_:)), keyEquivalent: ""),
        //NSMenuItem(title: "\(kFunctionKeyCharacter) Function", action: #selector(onMenuItemSelect(_:)), keyEquivalent: "")
    ]
    
    private var modifierKeyPopUpButtonMenu: NSMenu {
        return (modifierKeyPopUpButton.cell as! NSPopUpButtonCell).menu!
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let cell = NSPopUpButtonCell(textCell: "test")
//        cell.addItem(withTitle: "ssss")
//
//        modifierKeyPopUpButton.cell = cell
        
        //modifierKeyPopUpButtonMenu.addItem(withTitle: "aaaaa", action: nil, keyEquivalent: "")

        
        //let x = NSMenuItem(title: "", action: nil, keyEquivalent: "")
        
//        view.subviews.forEach {
//            if let lv = $0 as? LayerView {
//                lv.clipsToBounds = false
//            }
//        }

        modifierKeyMenuItems.forEach {
            modifierKeyPopUpButtonMenu.addItem($0)
        }
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        let mask = UserDefaults.standard.integer(forKey: .udModifierFlag)
        let flags = CGEventFlags(rawValue: UInt64(mask))
        let menuItem: NSMenuItem
        if flags.contains(.maskShift) {
            menuItem = modifierKeyMenuItems[ModifierKeyMenuIndex.shift.rawValue]
        } else if flags.contains(.maskControl) {
            menuItem = modifierKeyMenuItems[ModifierKeyMenuIndex.control.rawValue]
        } else if flags.contains(.maskAlternate) {
            menuItem = modifierKeyMenuItems[ModifierKeyMenuIndex.option.rawValue]
        } else if flags.contains(.maskCommand) {
            menuItem = modifierKeyMenuItems[ModifierKeyMenuIndex.command.rawValue]
        } else {
            fatalError()
        }
        modifierKeyPopUpButton.select(menuItem)
        boundarySlider.doubleValue = UserDefaults.standard.double(forKey: .udBoundary) * 1000
        timeoutSlider.doubleValue = UserDefaults.standard.double(forKey: .udTimeout) * 1000
        updateLabel()
    }

//    @IBAction private func onBoundaryStepperClick(_ sender: NSStepper) {
//        boundaryTextField.cell?.title = sender.stringValue
//    }

    @IBAction private func onSliderValueChange(_ sender: NSSlider) {
        if boundarySlider.doubleValue > timeoutSlider.doubleValue {
            if sender === boundarySlider {
                timeoutSlider.doubleValue = boundarySlider.doubleValue
            } else if sender === timeoutSlider {
                boundarySlider.doubleValue = timeoutSlider.doubleValue
            }
        }

        save()
        updateLabel()
    }
    
    @objc private func onMenuItemSelect(_ sender: NSMenuItem) {
        let index = modifierKeyMenuItems.index(of: sender)!
        let udModifierFlag: CGEventFlags
        switch ModifierKeyMenuIndex(rawValue: index)! {
        case .shift: udModifierFlag = .maskShift
        //case .cupsLock: udModifierFlag = .maskShift
        case .control: udModifierFlag = .maskControl
        case .option: udModifierFlag = .maskAlternate
        case .command: udModifierFlag = .maskCommand
        //case .esc: udModifierFlag = .maskShift
        //case .fn: udModifierFlag = .maskShift
        }
        UserDefaults.standard.set(udModifierFlag.rawValue, forKey: .udModifierFlag)
    }
    
    private func updateLabel() {
        boundaryLabel.cell?.title = String(format: "%.2f (sec)", boundarySlider.doubleValue / 1000)
        timeoutLabel.cell?.title = String(format: "%.2f (sec)", timeoutSlider.doubleValue / 1000)
    }
    
    private func save() {
        let boundary = boundarySlider.doubleValue / 1000
        let timeout = timeoutSlider.doubleValue / 1000
        UserDefaults.standard.set(boundary, forKey: .udBoundary)
        UserDefaults.standard.set(timeout, forKey: .udTimeout)
    }
    
}

