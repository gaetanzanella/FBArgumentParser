//
//  FBExpressibleByArgument.swift
//  FBArgumentParser
//
//  Created by Gaétan Zanella on 26/07/2021.
//

import Foundation

public protocol FBExpressibleByArgument {
    init?(argument: String)
}

extension String: FBExpressibleByArgument {

    public init?(argument: String) {
        self = argument
    }
}

extension LosslessStringConvertible where Self: FBExpressibleByArgument {

    public init?(argument: String) {
        self.init(argument)
    }
}

extension Int: FBExpressibleByArgument {

    public init?(argument: String) {
        self.init(argument)
    }
}
