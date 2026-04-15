//
//  DIResolver+Live.swift
//  KanaDouble
//
//  Created by Yasuhiro Hatta on 2026/04/19.
//

import Foundation

extension DIResolver {
    static func live() -> DIResolver {
        return DIResolver(
            store: .standard,
            autoStartManager: AutoStartManagerLiveImpl()
        )
    }
}
