//
//  VersionSchemaV1.swift
//  The Client App
//
//  Created by Slehyder Martinez on 9/04/24.
//

import Foundation
import SwiftData

enum VersionSchemaV1: VersionedSchema {
    
    static var models: [any PersistentModel.Type] {
        [Message.self]
    }
    
    static var versionIdentifier: Schema.Version = .init(1, 0, 0)
}
