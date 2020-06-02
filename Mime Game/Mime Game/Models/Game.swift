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
    var totalTurnTime: Int
    var currentPlayer: Int
    var messages: [Message]
    var totalTurns: Int
    var quantityPlayedWithMimickr : Int   // how many each player will be set as with mimickr
                                        // it will determine how much turns the game will have
    
    init(localPlayer: Player, players: [Player], uids: [UInt], totalTurnTime: Int, currentPlayer: Int, messages:  [Message], quantityPlayedWithMimickr: Int) {
        self.localPlayer = localPlayer
        self.remotePlayers = players
        self.uids = uids
        self.totalTurnTime = totalTurnTime
        self.currentPlayer = currentPlayer
        self.messages = messages
        self.quantityPlayedWithMimickr = quantityPlayedWithMimickr
        self.totalTurns = self.uids.count * quantityPlayedWithMimickr
    }
}
