//
//  FBInputKey.swift
//  FBArgumentParser
//
//  Created by Gaétan Zanella on 26/07/2021.
//

import Foundation

struct FBInputKey {

    let rawValue: String

    init(_ rawValue: String) {
        self.rawValue = rawValue
    }

    init<K: CodingKey>(_ key: K) {
        self.rawValue = key.stringValue
    }
}
