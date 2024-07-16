//
//  Keychain.swift
//  The Client App
//
//  Created by Slehyder Martinez on 9/04/24.
//

import SwiftUI
import Security
import CryptoKit

protocol KeyChainServiceProtocol {
    func storeKey(value: Data, key: String) throws
    func loadKeyFor(key: String) throws -> Data
}

final class KeychainService: KeyChainServiceProtocol {
    
    static let shared = KeychainService()
    
    func storeKey(value: Data, key: String) throws {
        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: value
        ]

        let addKeychainStatus = SecItemAdd(attributes as CFDictionary, nil)
        switch addKeychainStatus {
        case errSecSuccess:
            break
        case errSecDuplicateItem:
            try updateKey(key: key, value: value)
        default:
            throw KeychainError(status: addKeychainStatus, type: .servicesError)
        }
    }

    func loadKeyFor(key: String) throws -> Data {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]
        var item: CFTypeRef?
        let searchStatus = SecItemCopyMatching(query as CFDictionary, &item)
        guard searchStatus != errSecItemNotFound else {
            throw KeychainError(type: .notFound)
        }
        guard searchStatus == errSecSuccess else {
            throw KeychainError(status: searchStatus, type: .servicesError)
        }
        guard let existingItem = item as? [String: Any],
              let valueData = existingItem[kSecValueData as String] as? Data
              else {
            throw KeychainError(type: .incorrectData)
        }

        return valueData
    }

    private func updateKey(key: String, value: Data) throws {

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        let attributes: [String: Any] = [
            kSecValueData as String: value
        ]
        let updateKeychainItemStatus = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        guard updateKeychainItemStatus != errSecItemNotFound else {
            throw KeychainError(type: .notFound)
        }
        guard updateKeychainItemStatus == errSecSuccess else {
            throw KeychainError(status: updateKeychainItemStatus, type: .servicesError)
        }
    }
}

struct KeychainError: Error {
    var errorMessage: String?
    var type: KeychainErrorType
    
    enum KeychainErrorType {
        case servicesError
        case notFound
        case stringConversionError
        case incorrectData
    }
    
    init(status: OSStatus, type: KeychainErrorType) {
        self.type = type
        if let message = SecCopyErrorMessageString(status, nil) {
            self.errorMessage = String(message)
        } else {
            self.errorMessage = "Status Code: \(status)"
        }
    }
    
    init(type: KeychainErrorType) {
        self.type = type
    }
    
    init(errorMessage: String, type: KeychainErrorType) {
        self.type = type
        self.errorMessage = errorMessage
    }
}
