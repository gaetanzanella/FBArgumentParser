//
//  FBCommandParser.swift
//  FBArgumentParser
//
//  Created by Gaétan Zanella on 26/07/2021.
//

import Foundation

struct FBCommandParser {

    let command: FBParsableCommand.Type

    func parse(options: [String]) throws -> FBParsableCommand {
        try checkForHelp(in: options)
        let splitArguments = try FBSplitArguments(Array(options.dropFirst()))
        let storage = try FBArgumentSet(command).valueStorage(for: splitArguments)
        let decoder = FBArgumentsDecoder(storage: storage)
        return try command.init(from: decoder)
    }

    private func checkForHelp(in options: [String]) throws {
        let helpIndicators = ["-h", "--help", "help"]
        let requestsHelp = helpIndicators.contains { indicator in options.contains(indicator) }
        if requestsHelp {
            throw FBHelpRequested()
        }
    }
}
