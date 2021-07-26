//
//  FBOption.swift
//  FBArgumentParser
//
//  Created by Gaétan Zanella on 26/07/2021.
//

import Foundation

struct FBArgumentDefinition {
    let isOptional: Bool
    let defaultValue: String?
    let help: String?
}

@propertyWrapper
public struct FBOption {

    enum State {
        case definition(FBArgumentDefinition)
        case resolved(String)
    }

    public var wrappedValue: String {
        switch state {
            case let .resolved(value):
                return value
            case .definition:
                fatalError("Do not instantiate commands yourself, use FBParsableCommand.main instead.")
        }
    }

    private let state: State
}

extension FBOption: Decodable {

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        state = .resolved(try container.decode(String.self))
    }
}

public extension FBOption  {

    init(wrappedValue: String, help: String? = nil) {
        self.state = .definition(FBArgumentDefinition(isOptional: true, defaultValue: wrappedValue, help: help))
    }

    init(help: String? = nil) {
        self.state = .definition(FBArgumentDefinition(isOptional: false, defaultValue: nil, help: help))
    }
}

extension FBOption {

    func definition() -> FBArgumentDefinition? {
        switch state {
            case let .definition(definition):
                return definition
            case .resolved:
                fatalError("FBArgument is already decoded")
        }
    }
}
