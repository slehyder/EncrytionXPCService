//
//  EncryptionKey.swift
//  The Client App
//
//  Created by Slehyder Martinez on 16/07/24.
//

import Foundation

struct EncryptionKey {
    let id = UUID().uuidString
    let data: Data
}
