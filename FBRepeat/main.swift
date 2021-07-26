//
//  main.swift
//  FBRepeat
//
//  Created by Gaétan Zanella on 26/07/2021.
//

import FBArgumentParser
import Foundation

struct FBRepeat: FBParsableCommand {

    @FBOption()
    var requiredPhrase: String

    @FBOption
    var optionalPhrase: String = "hello"

    mutating func run() throws {
        for _ in 1...2 {
            print(requiredPhrase)
            print(optionalPhrase)
        }
    }
}

FBRepeat.main()
