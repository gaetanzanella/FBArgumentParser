//
//  FBSplitArguments.swift
//  FBArgumentParser
//
//  Created by Gaétan Zanella on 26/07/2021.
//

import Foundation

struct FBSplitArguments {

    enum Element {
        case option(String)
        case value(String)

        var value: String? {
            switch self {
            case .option:
                return nil
            case let .value(value):
                return value
            }
        }

        var option: String? {
            switch self {
            case let .option(option):
                return option
            case .value:
                return nil
            }
        }
    }

    private(set) var elements: [Element]

    init(_ options: [String]) throws {
        self.elements = options.map { option -> Element in
            if option.starts(with: "-") || option.starts(with: "--") {
                return .option(option.replacingOccurrences(of: "-", with: ""))
            } else {
                return .value(option)
            }
        }
    }

    func value(forOption option: String) -> String? {
        for (i, element) in elements.enumerated() {
            switch element {
            case let .option(name) where name == option:
                if i + 1 < elements.count {
                    return elements[i + 1].value
                } else {
                    return nil
                }
            case .option, .value:
                break
            }
        }
        return nil
    }

    mutating func popNext() -> Element? {
        guard let element = elements.first else { return nil }
        elements.removeFirst()
        return element
    }
}
