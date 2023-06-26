//
//  ws_chat_clientApp.swift
//  ws-chat-client
//
//  Created by Robert J. Sarvis Jr on 6/23/23.
//

import SwiftUI

// random int
let CLIENT_ID = Int.random(in: 10000..<99999)


@main
struct ws_chat_clientApp: App {
    @StateObject var websocketManager = WebSocketManager(connectionString: "ws://localhost:8000/ws/\(CLIENT_ID)")
    
    var body: some Scene {
        
        WindowGroup {
            ContentView()
                .environmentObject(websocketManager)
        }
    }
}
