//
//  FBCommandParser.swift
//  FBArgumentParser
//
//  Created by Gaétan Zanella on 26/07/2021.
//

import Foundation

struct HelpError: LocalizedError {
    let localizedDescription: String
}

struct FBCommandParser {

    enum ParsingError: Error {
        case invalidParameters
    }

    let command: FBParsableCommand.Type

    // MARK: - Public

    func parse(arguments: [String]) throws -> FBParsableCommand {
        try checkForHelp(in: arguments)
        var argumentDict = try parseArguments(arguments)
        argumentDict.merge(defaultParameters()) { left, right in left }
        let decoder = FBArgumentsDecoder(arguments: argumentDict)
        return try command.init(from: decoder)
    }

    // MARK: - Private

    private func parseArguments(_ arguments: [String]) throws -> [String: String] {
        var argumentsToParse = arguments
        var result: [String: String] = [:]
        while argumentsToParse.count >= 2 {
            let argument = argumentsToParse.removeFirst()
            let isAnArgument = argument.starts(with: "-") || argument.starts(with: "--")
            if !isAnArgument {
                throw ParsingError.invalidParameters
            }
            result[argument.replacingOccurrences(of: "-", with: "")] = argumentsToParse.removeFirst()
        }
        return result
    }

    private func defaultParameters() -> [String: String] {
        command.argumentDefinitions().compactMapValues { $0.defaultValue }
    }

    private func checkForHelp(in arguments: [String]) throws {
        let helpIndicators = ["-h", "--help", "help"]
        let requestsHelp = helpIndicators.contains { indicator in arguments.contains(indicator) }
        if requestsHelp {
            throw HelpError(localizedDescription: generateHelpDescription())
        }
    }

    private func generateHelpDescription() -> String {
        var description = ""
        description += command.configuration.name
        description += "\n"
        if !command.configuration.usage.isEmpty {
            description += command.configuration.usage
            description += "\n"
        }
        for (key, definition) in command.argumentDefinitions() {
            description += "--" + key
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
        return description
    }
}

private extension FBParsableCommand {

    static func argumentDefinitions() -> [String: FBArgumentDefinition] {
        var definitionByKey: [String: FBArgumentDefinition] = [:]
        Mirror(reflecting: Self.init()).children.forEach { child in
            guard let codingKey = child.label, let definition = (child.value as? FBOption)?.definition() else { return }
            // property wrappers are prefixed with "_"
            let sanitizedCodingKey = String(codingKey.first == "_" ? codingKey.dropFirst(1) : codingKey.dropFirst(0))
            definitionByKey[sanitizedCodingKey] = definition
        }
        return definitionByKey
    }
}
