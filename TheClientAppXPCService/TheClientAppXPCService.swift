//
//  TheClientAppXPCService.swift
//  TheClientAppXPCService
//
//  Created by Slehyder Martinez on 9/04/24.
//

import Foundation
import CryptoKit

enum DecryptionError: Error {
    case decryptionFailed
    case invalidData
}

class TheClientAppXPCService: NSObject, TheClientAppXPCServiceProtocol, NSXPCListenerDelegate {

            
    func listener(_ listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
        newConnection.exportedInterface = NSXPCInterface(with: TheClientAppXPCServiceProtocol.self)
        newConnection.exportedObject = TheClientAppXPCService()
        newConnection.resume()
        
        return true;
    }
    
    func encrypt(message: String, key: Data) async throws -> Data? {
        let symmetricKey = SymmetricKey(data: key)
        let messageData = Data(message.utf8)
        let sealedBox = try AES.GCM.seal(messageData, using: symmetricKey)
        return sealedBox.combined
    }

    func decrypt(cipherMessage: Data, key: Data) async throws -> String? {
        let symmetricKey = SymmetricKey(data: key)
        let sealedBox = try AES.GCM.SealedBox(combined: cipherMessage)
        let decryptedData = try AES.GCM.open(sealedBox, using: symmetricKey)
        guard let decryptedMessage = String(data: decryptedData, encoding: .utf8) else {
            throw DecryptionError.decryptionFailed
        }
        return decryptedMessage
    }
}


