//
//  Message.swift
//  The Client App
//
//  Created by Slehyder Martinez on 16/07/24.
//

import Foundation
import SwiftData

@Model
class Message : Identifiable {
    let id = UUID()
    var content: Data
    var keyEncrypt: String
    
    init(content: Data, keyEncrypt: String) {
        self.content = content
        self.keyEncrypt = keyEncrypt
    }
}

