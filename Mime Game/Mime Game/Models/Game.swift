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
    var uids: [UInt] = []
    var totalTime: Int
    var currentPlayer: Int
    var wordCategory: Theme
    
    init(localPlayer: Player, players: [Player], uids: [UInt], totalTime: Int, currentPlayer: Int, wordCategory: Theme) {
        self.localPlayer = localPlayer
        self.remotePlayers = players
        self.uids = uids
        self.totalTime = totalTime
        self.currentPlayer = currentPlayer
        self.wordCategory = wordCategory
    }
}
