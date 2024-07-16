//
//  MainViewModel.swift
//  The Client App
//
//  Created by Slehyder Martinez on 9/04/24.
//

import Foundation
import SwiftUI
import Combine
import SwiftData
import CryptoKit

@Observable
class MainViewModel  {
    
    @ObservationIgnored
    private let xpcService: XPCServiceProtocol
    
    @ObservationIgnored
    private let dataSource: MessageDataSourceProtocol
    
    @ObservationIgnored
    let keychainService: KeyChainServiceProtocol
    
    var showError: Bool = false
    var encryptionKey: EncryptionKey?
    var messages: [Message] = []
    
    
    init(xpcService: XPCServiceProtocol = XPCService.shared, datasource: MessageDataSourceProtocol =  MessageDataSource.shared , keyChainService: KeyChainServiceProtocol = KeychainService.shared )
    {
        self.xpcService = xpcService
        self.dataSource = datasource
        self.keychainService = keyChainService
        messages = getMessages()
        encryptionKey = initKey()
        saveEncryptionKey(key: encryptionKey)
        
    }
    
    func initKey() -> EncryptionKey{
        return EncryptionKey(data: EncryptionUtils.generateNewKey())
    }
    
    private func saveEncryptionKey(key: EncryptionKey?){
        guard let encryptionKeyToSaved = key else {return}
        do {
            try  keychainService.storeKey(value: encryptionKeyToSaved.data, key: encryptionKeyToSaved.id)
        } catch let error as KeychainError {
            print(error)
            self.showError = true
        } catch {
            print(error)
        }
    }
    
    func encryptMessage(_ message: String) async {
        if let key = encryptionKey {
            do {
                let result = try await xpcService.encrypt(message: message, key: key.data)
                if let content = result {
                    let message = Message(content: content, keyEncrypt: key.id)
                    self.dataSource.appendItem(item: message)
                    self.saveMessage(message)
                }
            } catch {
                print(error)
                self.showError = true
            }
        }
        
    }
    
    func decryptMessage(message: Message) async throws -> String {
        let keyEncrypt = try keychainService.loadKeyFor(key: message.keyEncrypt)
        return try await xpcService.decrypt(cipherMessage: message.content, key: keyEncrypt) ?? ""
    }
    
    func getMessages() -> [Message]{
        return dataSource.fetchItems()
    }
    
    func saveMessage(_ message: Message) {
        messages.append(message)
    }
    
    func removeMessage(_ message: Message) {
        
        if let index = messages.firstIndex(where: { $0.id == message.id }) {
            dataSource.removeItem(messages[index])
            messages.remove(at: index)
        }
    }
    
    func removeAllMessages(){
        dataSource.removeAll()
        messages.removeAll()
    }
    
}
