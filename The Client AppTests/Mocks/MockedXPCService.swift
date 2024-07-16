//
//  MockedXPCService.swift
//  The Client AppTests
//
//  Created by Slehyder Martinez on 16/07/24.
//

import Foundation

class MockedXPCService : XPCServiceProtocol {
    var encryptionResult: Result<Data, Error>?
    var decryptionResult: Result<String, Error>?
    
    func encrypt(message: String, key: Data) async throws -> Data? {
        guard let result = encryptionResult else {
            fatalError("MockXPCService: encryptionResult not set")
        }
        switch result {
        case .success(let encryptedData):
            return encryptedData
        case .failure(let error):
            throw error
        }
    }
    
    func decrypt(cipherMessage: Data, key: Data) async throws -> String? {
        guard let result = decryptionResult else {
            fatalError("MockXPCService: decryptionResult not set")
        }
        switch result {
        case .success(let decryptedString):
            return decryptedString
        case .failure(let error):
            throw error
        }
    }
    
    
}

