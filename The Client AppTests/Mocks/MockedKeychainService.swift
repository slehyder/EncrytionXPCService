//
//  MockedKeychainService.swift
//  The Client AppTests
//
//  Created by Slehyder Martinez on 16/07/24.
//

import Foundation

class MockedKeychainService: KeyChainServiceProtocol{
    
    var key: Data?
    func storeKey(value: Data, key: String) throws {
        self.key = value
    }
    func loadKeyFor(key: String) throws -> Data {
        if let keyData = self.key {
            return keyData
        } else {
            throw KeychainError(errorMessage: "Error", type: .notFound)
        }
    }
}
