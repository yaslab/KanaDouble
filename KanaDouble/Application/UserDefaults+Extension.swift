//
//  UserDefaults+Extension.swift
//  KanaDouble
//
//  Created by Yasuhiro Hatta on 2017/10/18.
//  Copyright © 2017 yaslab. All rights reserved.
//

import Foundation

protocol UserDefaultsValueProtocol {
}

protocol UserDefaultsCodable: Codable, UserDefaultsValueProtocol {
}

extension URL: UserDefaultsValueProtocol {}
extension String: UserDefaultsValueProtocol {}
extension Data: UserDefaultsValueProtocol {}
extension Bool: UserDefaultsValueProtocol {}
extension Int: UserDefaultsValueProtocol {}
extension Float: UserDefaultsValueProtocol {}
extension Double: UserDefaultsValueProtocol {}

extension UserDefaults {
    struct Key<Value: UserDefaultsValueProtocol> {
        let name: String
        init(_ name: String) {
            self.name = name
        }
    }
    subscript<V: UserDefaultsCodable>(key: Key<V>) -> V? {
        get {
            guard let data = self.data(forKey: key.name) else {
                return nil
            }
            let decoder = PropertyListDecoder()
            return try? decoder.decode(V.self, from: data)
        }
        set {
            let encoder = PropertyListEncoder()
            encoder.outputFormat = .binary
            guard let value = newValue, let data = try? encoder.encode(value) else {
                self.set(nil, forKey: key.name)
                return
            }
            self.set(data, forKey: key.name)
        }
    }
    subscript(key: Key<URL>) -> URL? {
        get { return self.url(forKey: key.name) }
        set { self.set(newValue, forKey: key.name) }
    }
    subscript(key: Key<String>) -> String? {
        get { return self.string(forKey: key.name) }
        set { self.set(newValue, forKey: key.name) }
    }
    subscript(key: Key<Data>) -> Data? {
        get { return self.data(forKey: key.name) }
        set { self.set(newValue, forKey: key.name) }
    }
    subscript(key: Key<Bool>) -> Bool {
        get { return self.bool(forKey: key.name) }
        set { self.set(newValue, forKey: key.name) }
    }
    subscript(key: Key<Int>) -> Int {
        get { return self.integer(forKey: key.name) }
        set { self.set(newValue, forKey: key.name) }
    }
    subscript(key: Key<Float>) -> Float {
        get { return self.float(forKey: key.name) }
        set { self.set(newValue, forKey: key.name) }
    }
    subscript(key: Key<Double>) -> Double {
        get { return self.double(forKey: key.name) }
        set { self.set(newValue, forKey: key.name) }
    }
}
