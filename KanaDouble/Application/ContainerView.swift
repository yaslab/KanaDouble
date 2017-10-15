//
//  ContainerView.swift
//  KanaDouble
//
//  Created by Yasuhiro Hatta on 2017/10/15.
//  Copyright © 2017年 yaslab. All rights reserved.
//

import Cocoa

class ContainerView: NSView {
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        commonInit()
    }
    
    override init(frame: NSRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        wantsLayer = true
        layer!.masksToBounds = false
    }
    
}
