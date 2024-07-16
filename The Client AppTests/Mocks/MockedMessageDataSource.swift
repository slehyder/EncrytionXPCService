//
//  MockedMessageDataSource.swift
//  The Client AppTests
//
//  Created by Slehyder Martinez on 16/07/24.
//

import Foundation

class MockedMessageDataSource: MessageDataSourceProtocol {
    
    var messages: [Message] = []
    
    func appendItem(item: Message) {
        messages.append(item)
    }
    
    func fetchItems() -> [Message] {
        return messages
    }
    
    func removeItem(_ item: Message) {
        if let index = messages.firstIndex(where: { $0 === item }) {
            messages.remove(at: index)
        }
    }
    
    func removeAll() {
        messages.removeAll()
    }
}
