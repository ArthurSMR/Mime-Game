//
//  DataServices.swift
//  Mime Game
//
//  Created by Arthur Rodrigues on 22/05/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import Foundation

class DataServices {
    
    //    MARK: - Encoders
    
    
    /// This method will encode can start game and create a MessageStream  object
    /// - Parameter canStartGame: can start game boolean
    /// - Returns: MessageStream object with the message saying to start the game
    static func encode(canStartGame: Bool) -> Data {
        
        let encoder = JSONEncoder()
        
        guard let canStartGameData = try? JSONEncoder().encode(canStartGame) else { return Data()}
        
        guard let data = try? encoder.encode(MessageStream(data: canStartGameData, streamType: .startTurn)) else { return Data()}
        
        return data
    }
    
    
    /// This method will encode the string with the end game segue identifier
    /// - Parameter segueToRankingFinalData: segue to go to the final ranking
    /// - Returns:MessageStream object with the end game segue identifier
    static func encode(segueToRankingFinalData: Data) -> Data {
        
        let encoder = JSONEncoder()
        
        guard let data = try? encoder.encode(MessageStream(data: segueToRankingFinalData, streamType: .endGame)) else { return Data()}
        
        return data
    }
    
    /// This method will encode the mime message object and create a MessageStream object
    /// - Parameter mimeMessage: The new mime that the mimickr chosen
    /// - Returns: MessageStream object with the new mime
    static func encode(mimeMessage: MimeMessage) -> Data {
        
        let encoder = JSONEncoder()
        
        guard let mimeMessageData = try? encoder.encode(mimeMessage) else { return Data()}
        
        guard let data = try? encoder.encode(MessageStream(data: mimeMessageData, streamType: .currentMimeIndex)) else { return Data()}
        
        return data
    }
    
    /// This method will encode the next mimickr index and create a MessageStream object
    /// - Parameter nextMimickrIndex: next mimickr index chosen by the current mimickr
    /// - Returns: MessageStream object with the next mimickr index
    static func encode(nextMimickrIndex: Int) -> Data {
        
        var nextMimickrIndex = nextMimickrIndex
        
        let encoder = JSONEncoder()
        
        let nextMimickrIndexData = Data(bytes: &nextMimickrIndex, count: MemoryLayout.size(ofValue: nextMimickrIndex))
        
        guard let data = try? encoder.encode(MessageStream(data: nextMimickrIndexData, streamType: .nextMimickrIndex)) else { return Data()}
        
        return data
        
    }
    
    /// This method will encode the text written and create a MessageStream object
    /// - Parameters:
    ///   - sendChatMessage: text written at chat text field
    /// - Returns: MessageStream object with the send message
    static func encode(sendChatMessage: String) -> Data {
        
        let encoder = JSONEncoder()
        
        let sendMessegeData = Data(sendChatMessage.utf8)
        
        guard let data = try? encoder.encode(MessageStream(data: sendMessegeData, streamType: .chatMessage)) else { return Data()}
        
        return data
    }
    
    
    // MARK: - Decoders
    
    
    /// This method will decode data to Message Stream
    /// - Parameter messageStreamData: message stream data received through message
    /// - Returns: returns a MessageStream
    static func decode(messageStreamData: Data) -> MessageStream {
        
        let decoder = JSONDecoder()
        
       guard let messageStream = try? decoder.decode(MessageStream.self, from: messageStreamData) else { return MessageStream()}
        
        return messageStream
    }
    
    
    
    /// This method will decode a chat message
    /// - Parameter chatMessage: chat message as data
    /// - Returns: return the string that was encoded
    static func decode(chatMessage: Data) -> String {
        
        let decodedChatMessage = String(decoding: chatMessage, as: UTF8.self)
        
        return decodedChatMessage
    }
    
    
    /// This method will decode the new mime received
    /// - Parameter mimeMessage: new mime received
    /// - Returns: return a MimeMessage
    static func decode(mimeMessage: Data) -> MimeMessage {
        let decoder = JSONDecoder()
        
        guard let mime = try? decoder.decode(MimeMessage.self, from: mimeMessage) else { return MimeMessage(newMime: Mime(name: "", theme: ""), isNewRound: false, index: -1)}
        
        return mime
    }
    
    /// This method will decode the next mimickr index
    /// - Parameter nextMimickrIndex: nextMimickrIndex as data
    /// - Returns: returns a Int that was encoded
    static func decode(nextMimickrIndex: Data) -> Int {
        
        let selectedNextPlayerIndex = nextMimickrIndex.withUnsafeBytes {
            $0.load(as: Int.self)
        }
        
        return selectedNextPlayerIndex
    }
    
}
