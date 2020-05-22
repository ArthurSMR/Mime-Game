//
//  MessageStream.swift
//  Mime Game
//
//  Created by Arthur Rodrigues on 21/05/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import Foundation

enum StreamType: Int, Codable {
    case chatMessage = 1
    case currentMimeIndex = 2
    case nextMimickrIndex = 3
    case startTurn = 4
    case endGame = 5
    
    init (withId id: Int) {
        switch id {
        case 1: self = .chatMessage
        case 2: self = .currentMimeIndex
        case 3: self = .nextMimickrIndex
        case 4: self = .startTurn
        case 5: self = .endGame
        default:
            self = .chatMessage
        }
    }
    
    func getValue() -> Int {
        switch self {
        case .chatMessage:
            return 1
        case .currentMimeIndex:
            return 2
        case .nextMimickrIndex:
            return 3
        case .startTurn:
            return 4
        case .endGame:
            return 5
        }
    }
}

class MessageStream: Codable {
    var data: Data
    var streamType: StreamType
    
    init(data: Data, streamType: StreamType) {
        self.data = data
        self.streamType = streamType
    }
}
