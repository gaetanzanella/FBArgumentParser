//
//  FBParsableCommand.swift
//  FBArgumentParser
//
//  Created by Gaétan Zanella on 26/07/2021.
//

import Foundation

public struct FBCommandConfiguration {

    public let name: String
    public let usage: String

    public init(name: String, usage: String) {
        self.name = name
        self.usage = usage
    }
}

public protocol FBParsableCommand: Decodable {

    static var configuration: FBCommandConfiguration { get }

    init()
    mutating func run() throws
}

public extension FBParsableCommand {

    static var configuration: FBCommandConfiguration {
        FBCommandConfiguration(
            name: String(describing: Self.self).lowercased(),
            usage: ""
        )
    }
}

public extension FBParsableCommand {

    static func main() {
        do {
            var command = try parseAsRoot()
            try command.run()
        } catch is FBHelpRequested {
            print(HelpGenerator(self).description)
        } catch {
            print(error.localizedDescription)
            exit(EXIT_FAILURE)
        }
    }

    private static func parseAsRoot() throws -> FBParsableCommand {
        let parser = FBCommandParser(command: self)
        return try parser.parse(options: Array(CommandLine.arguments))
    }
}
