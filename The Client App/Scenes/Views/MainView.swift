//
//  MainView.swift
//  The Client App
//
//  Created by Slehyder Martinez on 9/04/24.
//

import SwiftUI

struct MainView: View {
    
    @State private var viewModel = MainViewModel()
    @State private var inputText: String = ""
    @State private var showingAlert = false
    @State private var showingAlertRemoveAll = false
    
    var body: some View {
        VStack {
            HStack{
                VStack{
                    Button("Encrypt") {
                        if !inputText.isEmpty {
                            encrypt()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                                inputText = ""
                            })
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("Clear") {
                        if !viewModel.messages.isEmpty {
                            self.showingAlertRemoveAll = true
                        }
                    }
                    .padding()
                    .alert(isPresented: $showingAlertRemoveAll) {
                        Alert(
                            title: Text("Confirm Deletion"),
                            message: Text("Are you sure you want to delete all messages?"),
                            primaryButton: .destructive(Text("Delete")) {
                                viewModel.removeAllMessages()
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
                VStack{
                    TextField("Message", text: $inputText , onCommit: {
                        
                        if !inputText.isEmpty {
                            encrypt()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                                inputText = ""
                            })
                        }
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    List{
                        ForEach(viewModel.messages) { message in
                            
                            ItemView(deleteAction: {
                                self.showingAlert = true
                            }, message: message, viewModel: viewModel)
                            .alert(isPresented: $showingAlert) {
                                Alert(
                                    title: Text("Confirm Deletion"),
                                    message: Text("Are you sure you want to delete this message?"),
                                    primaryButton: .destructive(Text("Delete")) {
                                        viewModel.removeMessage(message)
                                    },
                                    secondaryButton: .cancel()
                                )
                            }
                        }
                    }
                }
            }
            
        }
        .padding()
    }
    private func encrypt(){
        Task {
            await viewModel.encryptMessage(inputText)
        }
    }
}

#Preview {
    MainView()
}
