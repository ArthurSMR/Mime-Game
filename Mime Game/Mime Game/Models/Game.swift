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
    var players: [Player] = []
    var uids: [UInt] = []
    var totalTime: Int
    var turn: Int
    
    init(localPlayer: Player, players: [Player], uids: [UInt], totalTime: Int, turn: Int) {
        self.localPlayer = localPlayer
        self.players = players
        self.uids = uids
        self.totalTime = totalTime
        self.turn = turn
    }
}
