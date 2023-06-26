//
//  MessageView.swift
//  ws-chat-client
//
//  Created by Robert J. Sarvis Jr on 6/24/23.
//

import SwiftUI

struct MessageView: View {
    @Binding var message: MessageModel
    
    var body: some View {
        if message.data.client_id == CLIENT_ID {
            HStack {
                Spacer()
                Text(message.data.message)
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        } else {
            HStack {
                VStack(alignment: .leading) {
                    Text(message.data.client_id.description)
                        .foregroundColor(.gray)
                        .font(.footnote)
                    Text(message.data.message)
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Spacer()

            }

        }
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView(message: .constant(MessageModel(id: UUID(), type: "text", data: MessageDataModel(message: "Once more unto the breach", client_id: 4))))
    }
}
