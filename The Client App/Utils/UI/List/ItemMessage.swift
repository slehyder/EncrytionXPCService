//
//  ItemMessage.swift
//  The Client App
//
//  Created by Slehyder Martinez on 9/04/24.
//

import Foundation
import SwiftUI

struct ItemView: View {
    
    var deleteAction: () -> Void
    var message: Message
    var viewModel: MainViewModel
    @State private var originalMessage = ""
    
    var body: some View {
        HStack{
            Text(originalMessage)
            Spacer()
            Button(action: {
                deleteAction()
            }) {
                Image(systemName: "trash")
                    .imageScale(.large)
                    .foregroundStyle(.red)
            }
        }
        .onAppear{
            Task{
                originalMessage = try await viewModel.decryptMessage(message: message)
            }
        }
        .padding()
    }
}

#Preview {
    ItemView(deleteAction: {}, message: Message(content: "tesT".data(using: .utf8)!, keyEncrypt: "test"), viewModel: MainViewModel())
}


