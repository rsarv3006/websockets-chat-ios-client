//
//  ConnectionIndicator.swift
//  ws-chat-client
//
//  Created by Robert J. Sarvis Jr on 6/25/23.
//

import SwiftUI

struct ConnectionIndicator: View {
    @EnvironmentObject var webSocketManager: WebSocketManager
    
    var body: some View {
        if webSocketManager.connectionStatus == .connected {
         Circle()
            .frame(width: 10, height: 10)
            .foregroundColor(.green)
        } else if webSocketManager.connectionStatus == .connecting {
            Circle()
               .frame(width: 10, height: 10)
               .foregroundColor(.orange)
        } else if webSocketManager.connectionStatus == .disconnected {
            Circle()
                .frame(width: 10, height: 10)
                .foregroundColor(.gray)
        
        } else {
            Circle()
                .frame(width: 10, height: 10)
                .foregroundColor(.red)
        
        }
        
        
        
    }
}

struct ConnectionIndicator_Previews: PreviewProvider {
    static var previews: some View {
        let webSocketMaaager = WebSocketManager(connectionString: "ws://localhost:8080/ws")
        return ConnectionIndicator()
            .environmentObject(webSocketMaaager)
    }
}
