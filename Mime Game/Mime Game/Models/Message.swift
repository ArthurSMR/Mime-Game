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
    var isCorrect: Bool
    var showCorrectMime: Bool
    
    init(word: String, player: Player, isCorrect: Bool) {
        self.word = word
        self.player = player
        self.isCorrect = isCorrect
        self.showCorrectMime = false
    }
    
    init(word: String, player: Player, isCorrect: Bool, showCorrectMime: Bool) {
        self.word = word
        self.player = player
        self.isCorrect = isCorrect
        self.showCorrectMime = showCorrectMime
    }
    
}
