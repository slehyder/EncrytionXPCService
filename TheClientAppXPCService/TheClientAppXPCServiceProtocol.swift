//
//  TheClientAppXPCServiceProtocol.swift
//  TheClientAppXPCService
//
//  Created by Slehyder Martinez on 9/04/24.
//

import Foundation

let TheClientAppServiceName = "com.TheClientAppXPCService"

/// The protocol that this service will vend as its API. This protocol will also need to be visible to the process hosting the service.
@objc protocol TheClientAppXPCServiceProtocol {
    
    /// Replace the API of this protocol with an API appropriate to the service you are vending.
    func encrypt(message: String, key: Data) async throws -> Data?
    func decrypt(cipherMessage: Data, key: Data) async throws -> String?
}
