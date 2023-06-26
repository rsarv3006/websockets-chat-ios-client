//
//  SendMessageView.swift
//  ws-chat-client
//
//  Created by Robert J. Sarvis Jr on 6/24/23.
//

import SwiftUI

struct SendMessageView: View {
    @EnvironmentObject var webSocketManager: WebSocketManager
    @State private var message = ""
    
    var body: some View {
        HStack {
            TextField("Send Message", text: $message)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            Button(action: {
                webSocketManager.sendMessage(message)
                message = ""
            }) {
                Image(systemName: "paperplane")
                    .font(.system(size: 20))
                    .foregroundColor(message.isEmpty || webSocketManager.connectionStatus != .connected ? .gray : .blue)
            }
            .disabled(message.isEmpty || webSocketManager.connectionStatus != .connected)
        }
        .padding()
        
    
    }
}

struct SendMessageView_Previews: PreviewProvider {
    static var previews: some View {
        let webSocketMaaager = WebSocketManager(connectionString: "ws://localhost:8080/ws")
        return SendMessageView()
            .environmentObject(webSocketMaaager)
    }
}
