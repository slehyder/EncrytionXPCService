//
//  XPCServiceClient.swift
//  The Client App
//
//  Created by Slehyder Martinez on 9/04/24.
//
import Foundation

protocol XPCServiceProtocol {
    func encrypt(message: String, key: Data) async throws -> Data?
    func decrypt(cipherMessage: Data, key: Data) async throws -> String?
}


class XPCService: XPCServiceProtocol {
    
    static let shared = XPCService()
    private var connection: NSXPCConnection
    private var service: TheClientAppXPCServiceProtocol
    
    init() {
        connection = NSXPCConnection(serviceName: TheClientAppServiceName)
        connection.remoteObjectInterface = NSXPCInterface(with: TheClientAppXPCServiceProtocol.self)
        connection.resume()
        
        service = connection.remoteObjectProxyWithErrorHandler { error in
            print("Error during remote connection: ", error)
        } as! TheClientAppXPCServiceProtocol
        
    }
    
    deinit {
        connection.invalidate()
    }
    
    
    func encrypt(message: String, key: Data) async throws -> Data? {
        return try await service.encrypt(message: message, key: key)
    }
    
    func decrypt(cipherMessage: Data, key: Data) async throws -> String? {
        return try await service.decrypt(cipherMessage: cipherMessage, key: key)
    }
}

