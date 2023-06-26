//
//  MessageModel.swift
//  ws-chat-client
//
//  Created by Robert J. Sarvis Jr on 6/23/23.
//

import Foundation

struct MessageModel: Codable {
    static func == (lhs: MessageModel, rhs: MessageModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: UUID
    let type: String
    let data: MessageDataModel
}

struct MessageDataModel: Codable {
    let message: String
    let client_id: Int
}

