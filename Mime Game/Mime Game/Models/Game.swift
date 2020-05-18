//
//  Game.swift
//  Mime Game
//
//  Created by Arthur Rodrigues on 23/04/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import Foundation
import UIKit

class Game {
    
    var localPlayer: Player
    var remotePlayers: [Player] = []
    var selectablePlayersWithUid: [UInt] = []
    var uids: [UInt] = []
    var totalTime: Int
    var currentPlayer: Int
    var messages: [Message]
    var totalTurns: Int
    var quantityPlayedWithMimickr = 2   // how many each player will be set as with mimickr
                                        // it will determine how much turns the game will have
    
    init(localPlayer: Player, players: [Player], uids: [UInt], totalTime: Int, currentPlayer: Int, messages:  [Message]) {
        self.localPlayer = localPlayer
        self.remotePlayers = players
        self.uids = uids
        self.totalTime = totalTime
        self.currentPlayer = currentPlayer
        self.messages = messages
        self.totalTurns = self.uids.count * quantityPlayedWithMimickr
    }
}
