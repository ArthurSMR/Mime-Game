//
//  Message.swift
//  Mime Game
//
//  Created by Arthur Rodrigues on 29/04/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import Foundation

class Message {
    var word: String
    var player: Player
    
    init(word: String, player: Player) {
        self.word = word
        self.player = player
    }
    
}
