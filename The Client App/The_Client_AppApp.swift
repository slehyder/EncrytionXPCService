//
//  The_Client_AppApp.swift
//  The Client App
//
//  Created by Slehyder Martinez on 8/04/24.
//

import SwiftUI
import SwiftData

// MARK: MIGRATION PLAN
enum TodoMigrationPlan: SchemaMigrationPlan {
    static var stages: [MigrationStage] {
        [migrateV1toV2]
    }
    
    static var schemas: [VersionedSchema.Type] {
        [VersionSchemaV1.self]
    }
    
    static let migrateV1toV2 = MigrationStage.lightweight(fromVersion: VersionSchemaV1.self, toVersion: VersionSchemaV1.self)
}

@main
struct The_Client_AppApp: App {
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
