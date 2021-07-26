//
//  FBArgumentSet.swift
//  FBArgumentParser
//
//  Created by Gaétan Zanella on 26/07/2021.
//

import Foundation

struct FBArgumentSet {

    let definitions: [FBArgumentDefinition]

    init(_ command: FBParsableCommand.Type) {
        definitions = Mirror(reflecting: command.init()).children.compactMap { child in
            guard var codingKey = child.label else { return nil }
            let provider = (child.value as? ArgumentDefinitionProvider)
            codingKey = String(codingKey.first == "_"
                             ? codingKey.dropFirst(1)
                             : codingKey.dropFirst(0))
            return provider?.argumentDefinition(for: FBInputKey(codingKey))
        }
    }

    func valueStorage(for arguments: FBSplitArguments) throws -> ArgumentValueStorage {
        var storage = ArgumentValueStorage()
        var all = arguments
        definitions.forEach { definition in
            definition.initial(&storage)
        }
        while let argument = all.popNext() {
            switch argument {
            case .value:
                break
            case let .option(name):
                guard let definition = definition(forOptionNamed: name) else { break }
                guard let value = all.elements.first?.value else { throw ParserError.invalidArguments }
                definition.update(value, &storage)
            }
        }
        return storage
    }

    func definition(forOptionNamed option: String) -> FBArgumentDefinition? {
        definitions.first(where: { $0.key.rawValue == option })
    }
}
