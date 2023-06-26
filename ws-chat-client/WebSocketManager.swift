//
//  WebSocketManager.swift
//  ws-chat-client
//
//  Created by Robert J. Sarvis Jr on 6/23/23.
//

import Foundation
import Network

class WebSocketManager: ObservableObject {
    @Published var message: MessageModel?
    @Published var connectionStatus: WebSocketManager.ConnectionStatus = .disconnected
    @Published var connectionError: Swift.Error? = nil
    
    private let connectionString: String
    
    private var connection: NWConnection?
    private var receiveCompletion: ((Data?, NWConnection.ContentContext?, Bool, NWError?) -> Void)?
    
    init(connectionString: String) {
        self.connectionString = connectionString
    }
    
    func establishConnection() throws {
        connectionStatus = .connecting
        
        guard let url = URL(string: connectionString) else {
            connectionStatus = .failed
            connectionError = WebSocketManager.SocketErrors.invalidConnectionString
            throw WebSocketManager.SocketErrors.invalidConnectionString
        }
        
        let tcpOpts = NWProtocolTCP.Options()
            tcpOpts.disableECN         = true
            tcpOpts.enableKeepalive    = true
            tcpOpts.connectionTimeout  = 5
            tcpOpts.connectionDropTime = 5
            tcpOpts.keepaliveCount     = 0
        
        let parameters = NWParameters(tls: nil, tcp: tcpOpts)
        let options = NWProtocolWebSocket.Options()
        options.autoReplyPing = true
        parameters.defaultProtocolStack.applicationProtocols.insert(options, at: 0)

        connection = NWConnection(to: .url(url), using: parameters)
        connection?.stateUpdateHandler = { [weak self] newState in
            switch newState {
            case .ready:
                self?.connectionStatus = .connected
                self?.message = MessageModel(id: UUID(), type: "alert", data: MessageDataModel(message: "Connected Successfully!", client_id: CLIENT_ID))
                self?.receiveData()
            case .waiting(let error):
                self?.connectionStatus = .connecting
                self?.message = MessageModel(id: UUID(), type: "alert", data: MessageDataModel(message: "Connection waiting: \(error)", client_id: CLIENT_ID))
            case .failed(let error):
                self?.connectionStatus = .failed
                self?.connectionError = error
                self?.message = MessageModel(id: UUID(), type: "alert", data: MessageDataModel(message: "Connection failed: \(error)", client_id: CLIENT_ID))
            default:
                break
            
            }
        }
        connection?.start(queue: .main)
        
    }
    
    func receiveData() {
        connection?.receiveMessage { [weak self] data, context, isComplete, error in
            if let data = data {
                let decoder = JSONDecoder()
                self?.message = try? decoder.decode(MessageModel.self, from: data)
            }
            
            if error == nil {
                self?.receiveData()
            } else if let error = error, error.localizedDescription.contains("Operation canceled") {
                return
            } else {
                self?.connectionStatus = .failed
                self?.connectionError = (error ?? WebSocketManager.SocketErrors.connectionFailed)
                self?.message = MessageModel(id: UUID(), type: "alert", data: MessageDataModel(message: "Connection Dropped!", client_id: CLIENT_ID))
            }
        }
    }
    
    func sendMessage(_ message: String) {
        if let data = message.data(using: .utf8) {
            let metadata = NWProtocolWebSocket.Metadata(opcode: .text)
            let context = NWConnection.ContentContext(identifier: "TextMessage", metadata: [metadata])
            connection?.send(content: data, contentContext: context, isComplete: true, completion: .contentProcessed { error in
                if let error = error {
                    self.message = MessageModel(id: UUID(), type: "alert", data: MessageDataModel(message: "Failed to send the message. \(error)", client_id: CLIENT_ID))
                }
            })
        }
    }
    
    func disconnect() {
        connection?.cancel()
        connectionStatus = .disconnected
        message = MessageModel(id: UUID(), type: "alert", data: MessageDataModel(message: "Disconnected", client_id: CLIENT_ID))
    }
    
}

// MARK: WebSocketManager - Enums
extension WebSocketManager {
    enum SocketErrors: Swift.Error {
        case invalidConnectionString
        case connectionFailed
    }
    
    enum ConnectionStatus: String {
        
        case connected = "Connected"
        case disconnected = "Disconnected"
        case connecting = "Connecting"
        case failed = "Failed"
        
        
        func toString() -> String {
            switch self {
            case .connected:
                return "Connected"
            case .disconnected:
                return "Disconnected"
            case .connecting:
                return "Connecting"
            case .failed:
                return "Failed to connect"
            }
        }
    }
    

    
}
