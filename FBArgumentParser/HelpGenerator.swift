//
//  HelpGenerator.swift
//  FBArgumentParser
//
//  Created by Gaétan Zanella on 26/07/2021.
//

import Foundation

struct FBHelpRequested: Error {}

struct HelpGenerator {

    let description: String

    init(_ command: FBParsableCommand.Type) {
        let arguments = FBArgumentSet(command)
        var description = ""
        description += command.configuration.name
        description += "\n"
        if !command.configuration.usage.isEmpty {
            description += command.configuration.usage
            description += "\n"
        }
        for definition in arguments.definitions {
            description += "--" + definition.key.rawValue
            if let help = definition.help {
                description += ": " + help
            }
            if definition.isOptional {
                description += " (optional)"
            }
            if let value = definition.defaultValue {
                description += " (default \(value))"
            }
            description += "\n"
        }
        self.description = description
    }
}
