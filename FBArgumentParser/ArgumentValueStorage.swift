//
//  ArgumentValueStorage.swift
//  FBArgumentParser
//
//  Created by Gaétan Zanella on 26/07/2021.
//

import Foundation

struct ArgumentValueStorage {

    private var valueByKey: [String: Any] = [:]

    func value(for input: FBInputKey) -> Any? {
        valueByKey[input.rawValue]
    }

    mutating func addValue(_ value: Any, for input: FBInputKey) {
        valueByKey[input.rawValue] = value
    }
}
