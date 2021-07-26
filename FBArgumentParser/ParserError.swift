//
//  ParserError.swift
//  FBArgumentParser
//
//  Created by Gaétan Zanella on 26/07/2021.
//

import Foundation

enum ParserError: Error {
    case invalidArguments
    case unknownKey
    case invalidState
}
