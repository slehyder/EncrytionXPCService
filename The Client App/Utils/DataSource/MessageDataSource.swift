//
//  MessageDataSource.swift
//  The Client App
//
//  Created by Slehyder Martinez on 9/04/24.
//

import Foundation
import SwiftData

protocol MessageDataSourceProtocol {
    func appendItem(item: Message)
    func fetchItems() -> [Message]
    func removeItem(_ item: Message)
    func removeAll()
}


final class MessageDataSource: MessageDataSourceProtocol {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext

    @MainActor
    static let shared = MessageDataSource()

    @MainActor
    private init() {
        self.modelContainer = MessageDataSource.create()
        self.modelContext = modelContainer.mainContext
    }
    
    @MainActor
    static func create() -> ModelContainer {
        let schema = Schema ( [Message.self])
        let configuration = ModelConfiguration()
        let container = try! ModelContainer(
            for: schema,
    //        migrationPlan: TodoMigrationPlan.self,
            configurations: [configuration])
        
        return container
    }

    func appendItem(item: Message) {
        modelContext.insert(item)
        do {
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func fetchItems() -> [Message] {
        do {
            return try modelContext.fetch(FetchDescriptor<Message>())
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func removeItem(_ item: Message) {
        modelContext.delete(item)
    }
    
    func removeAll() {
        do {
            try modelContext.delete(model: Message.self)
        }catch{
            fatalError(error.localizedDescription)
        }
    }
}
