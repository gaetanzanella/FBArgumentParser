//
//  FBArgumentDefinition.swift
//  FBArgumentParser
//
//  Created by Gaétan Zanella on 26/07/2021.
//

import Foundation

struct FBArgumentDefinition {
    let key: FBInputKey
    let help: String?
    let isOptional: Bool
    let defaultValue: String?
    let initial: (inout ArgumentValueStorage) -> Void
    let update: (String, inout ArgumentValueStorage) -> Void
}

protocol ArgumentDefinitionProvider {
    func argumentDefinition(for key: FBInputKey) -> FBArgumentDefinition
}
