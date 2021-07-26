//
//  FBOption.swift
//  FBArgumentParser
//
//  Created by Gaétan Zanella on 26/07/2021.
//

import Foundation

@propertyWrapper
public struct FBOption<Value> {

    enum State {
        case resolved(Value)
        case defined((FBInputKey) -> FBArgumentDefinition)
    }

    let state: State

    public var wrappedValue: Value {
        switch state {
        case let .resolved(value):
            return value
        case .defined:
            fatalError()
        }
    }

    @available(*, unavailable, message: "A default value must be provided unless the value type conforms to ExpressibleByArgument.")
    public init() {
      fatalError("unavailable")
    }

    public init<T: FBExpressibleByArgument>(help: String? = nil) where Value == T? {
        self.state = .defined { key in
            FBArgumentDefinition(
                key: key,
                help: help,
                isOptional: true,
                defaultValue: nil,
                initial: { _ in },
                update: { valueString, storage in
                    guard let value = T(argument: valueString) else { return }
                    storage.addValue(value, for: key)
                }
            )
        }
    }
}

extension FBOption where Value: FBExpressibleByArgument {

    public init(help: String? = nil) {
        self.state = .defined { key in
            FBArgumentDefinition(
                key: key,
                help: help,
                isOptional: false,
                defaultValue: nil,
                initial: { _ in },
                update: { valueString, storage in
                    guard let value = Value(argument: valueString) else { return }
                    storage.addValue(value, for: key)
                }
            )
        }
    }

    public init(wrappedValue: Value, help: String? = nil) {
        self.state = .defined { key in
            FBArgumentDefinition(
                key: key,
                help: help,
                isOptional: true,
                defaultValue: "\(wrappedValue)",
                initial: { values in
                    values.addValue(wrappedValue as Any, for: key)
                },
                update: { valueString, storage in
                    guard let value = Value(argument: valueString) else { return }
                    storage.addValue(value, for: key)
                }
            )
        }
    }
}

extension FBOption: Decodable {

    public init(from decoder: Decoder) throws {
        guard let d = decoder as? SingleValueDecoder,
              let value = d.parsedElement as? Value else {
          throw ParserError.invalidState
        }
        state = .resolved(value)
    }
}

extension FBOption: ArgumentDefinitionProvider {

    func argumentDefinition(for key: FBInputKey) -> FBArgumentDefinition {
        switch state {
        case .resolved:
            fatalError()
        case let .defined(provider):
            return provider(key)
        }
    }
}
