//
//  ContentView.swift
//  ws-chat-client
//
//  Created by Robert J. Sarvis Jr on 6/23/23.
//

import SwiftUI
import Combine

struct ContentView: View {
    var subscriptions = Set<AnyCancellable>()
    @State var messages = [MessageModel]()
    @EnvironmentObject var webSocketManager: WebSocketManager
        
    init() {
       UITableView.appearance().separatorStyle = .none
       UITableView.appearance().tableFooterView = UIView()
    }

    var body: some View {
        VStack {
            Text("WS Shenanigans")
            
            HStack {
                Button("Connect") {
                    do {
                        try webSocketManager.establishConnection()
                    } catch {
                        print("Error: \(error)")
                    }
                
                }
                
                ConnectionIndicator()
                
                Button("Disconnect") {
                    webSocketManager.disconnect()
                }
            }
            
            

            
            List($messages, id: \.id) { message in
                MessageView(message: message)
                    .scaleEffect(x: 1, y: -1, anchor: .center)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
            }.scaleEffect(x: 1, y: -1, anchor: .center)
            
            Spacer()
            
            SendMessageView()
        }
        .onReceive(webSocketManager.$message, perform: { value in
            if let value = value {
                let foundMessage = messages.first { message in
                    message.id == value.id
                }
                
                if foundMessage == nil {
                    messages.insert(value, at: 0)
                }
            }
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let webSocketMaaager = WebSocketManager(connectionString: "ws://localhost:8080/ws")
        return ContentView()
            .environmentObject(webSocketMaaager)
    }
}
