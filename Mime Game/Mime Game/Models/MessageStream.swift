//
//  MessageStream.swift
//  Mime Game
//
//  Created by Arthur Rodrigues on 21/05/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import Foundation

enum StreamType: Int, Codable {
    case none = 0
    case chatMessage = 1
    case currentMimeIndex = 2
    case nextMimickrIndex = 3
    case startTurn = 4
    case endGame = 5
    case gameSettings = 6
    case startGame = 7
    case avatar = 8
    
    init (withId id: Int) {
        switch id {
        case 0: self = .none
        case 1: self = .chatMessage
        case 2: self = .currentMimeIndex
        case 3: self = .nextMimickrIndex
        case 4: self = .startTurn
        case 5: self = .endGame
        case 6: self = .gameSettings
        case 7: self = .startGame
        case 8: self = .avatar
        default:
            self = .chatMessage
        }
    }
    
    func getValue() -> Int {
        switch self {
        case .none: return 0
        case .chatMessage: return 1
        case .currentMimeIndex: return 2
        case .nextMimickrIndex:return 3
        case .startTurn: return 4
        case .endGame: return 5
        case .gameSettings: return 6
        case .startGame: return 7
        case .avatar: return 8
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
    
    init() {
        self.data = Data()
        self.streamType = .none
    }
}
