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

    static func main() {
        do {
            let arguments = CommandLine.arguments.dropFirst() // we always ignore the first one ## TO EXPLICIT ##
            var command = try parseAsRoot(Array(arguments))
            try command.run()
        } catch {
            print(error.localizedDescription)
            exit(EXIT_FAILURE)
        }
    }

    private static func parseAsRoot(_ arguments: [String]) throws -> FBParsableCommand {
        let parser = FBCommandParser(command: self)
        return try parser.parse(arguments: arguments)
    }
}

public extension FBParsableCommand {

    static var configuration: FBCommandConfiguration {
        FBCommandConfiguration(
            name: String(describing: Self.self).lowercased(),
            usage: ""
        )
    }
}
