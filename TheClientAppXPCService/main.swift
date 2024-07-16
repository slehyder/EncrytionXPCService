//
//  main.swift
//  TheClientAppXPCService
//
//  Created by Slehyder Martinez on 9/04/24.
//

import Foundation

// Create the delegate for the service.
let service = TheClientAppXPCService()

// Set up the one NSXPCListener for this service. It will handle all incoming connections.
let listener = NSXPCListener.service()
listener.delegate = service

// Resuming the serviceListener starts this service. This method does not return.
listener.resume()

dispatchMain()
