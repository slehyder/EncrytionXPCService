//
//  The_Client_AppTests.swift
//  The Client AppTests
//
//  Created by Slehyder Martinez on 8/04/24.
//

import XCTest
@testable import The_Client_App

final class The_Client_AppTests: XCTestCase {
    
    var viewModel: MainViewModel!
    var xpcService: MockedXPCService!
    var keychainService : MockedKeychainService!
    var datasource: MockedMessageDataSource!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        xpcService = MockedXPCService()
        keychainService = MockedKeychainService()
        datasource = MockedMessageDataSource()
        viewModel = MainViewModel(xpcService: xpcService, datasource: datasource , keyChainService: keychainService)
        xpcService.encryptionResult = .success(Data())
        xpcService.decryptionResult = .success("message_decrypted")
    }
    
    
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
        xpcService = nil
        keychainService = nil
        datasource = nil
        try super.tearDownWithError()
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testRemoveMessage() throws {
        let message = Message(content: "Test message".data(using: .utf8)!, keyEncrypt: "ABC123")
       
        viewModel.saveMessage(message)
        XCTAssertEqual(viewModel.messages.count, 1)
        
        viewModel.removeMessage(message)
        XCTAssertEqual(viewModel.messages.count, 0)
        XCTAssertEqual(datasource.messages.count, 0)
    }
    
    func testSaveMessage() throws {
        let message = Message(content: "Test message".data(using: .utf8)!, keyEncrypt: "ABC123")
        
        viewModel.saveMessage(message)
        
        XCTAssertEqual(viewModel.messages.count, 1)
  
    }
    
    func testRemoveAllMessages() async throws {
  
        await viewModel.encryptMessage("message")
        await viewModel.encryptMessage("secondMessage")
        viewModel.removeAllMessages()
        
        XCTAssertEqual(viewModel.messages.count, 0)
        XCTAssertEqual(datasource.messages.count, 0)
    }
    
    func testGetAllMessages() async throws {
        for _ in 1...3 {
            await viewModel.encryptMessage("message")
        }
        
        XCTAssertEqual(viewModel.getMessages().count, 3)
    }
    
    func testEncryptMessage() async throws {
       
        let messageToEncrypt = "Hello, world!"
        
        await viewModel.encryptMessage(messageToEncrypt)

        XCTAssertEqual(datasource.messages.count, 1)
        XCTAssertEqual(viewModel.messages.count, 1)

    }
    
    func testEncryptMessageWithError() async throws {
        
        let messageToEncrypt = "Hello, world!"
      
        xpcService.encryptionResult  = .failure(NSError(domain: "TestDomain", code: 500, userInfo: nil))
        await viewModel.encryptMessage(messageToEncrypt)

        XCTAssertEqual(viewModel.messages.count, 0)
        XCTAssertTrue(viewModel.showError)
    }
    
    func testDecryptMessage() async throws {
        
        let mockKey = Data("keyEncrypt".utf8)
        
        keychainService.key = mockKey
    
        let message = Message(content: Data("message_decrypted".utf8), keyEncrypt: "keyEncrypt")
        
        do {
            let decryptedMessage = try await viewModel.decryptMessage(message: message)
            
            XCTAssertEqual(decryptedMessage, "message_decrypted")
        } catch {
            XCTFail("Error: \(error)")
        }
        
    }
    
    func testDecryptMessageWithErrorKeyIsNull() async throws {
        
        let message = Message(content: Data("mesage_decrypted".utf8), keyEncrypt: "keyEncrypt")
        
        keychainService.key = nil
        do {
            _ = try await viewModel.decryptMessage(message: message)
            
            XCTFail("Dont throw error")
        } catch {
            XCTAssertTrue(error is KeychainError)
        }
        
    }
    
    func testDecryptMessageWithError() async throws {
        
        let error = NSError(domain: "TestDomain", code: 123, userInfo: [NSLocalizedDescriptionKey: "Some error"])
        xpcService.decryptionResult = .failure(error)
        let mockKey = Data("keyEncrypt".utf8)
        keychainService.key = mockKey
        
        let message = Message(content: Data("message_decrypted".utf8), keyEncrypt: "keyEncrypt")
        
        do {
            _ = try await viewModel.decryptMessage(message: message)
            XCTFail("Dont throw error")
        } catch {
            XCTAssertEqual((error as NSError).domain, "TestDomain")
            XCTAssertEqual((error as NSError).code, 123)
        }
        
    }
    
}
