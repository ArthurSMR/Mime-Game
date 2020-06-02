//
//  GameSettings.swift
//  Mime Game
//
//  Created by Arthur Rodrigues on 29/05/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import Foundation

class GameSettings: Codable {
    var quantityPlayedWithMimickr: Int
    var totalTurnTime: Int
    var theme: String = "Aleatório"
    
    init(quantityPlayedWithMimickr: Int, totalTurnTime: Int, theme: String) {
        self.quantityPlayedWithMimickr = quantityPlayedWithMimickr
        self.totalTurnTime = totalTurnTime
        self.theme = theme
    }
    
    init(quantityPlayedWithMimickr: Int, totalTurnTime: Int) {
        self.quantityPlayedWithMimickr = quantityPlayedWithMimickr
        self.totalTurnTime = totalTurnTime
    }
}
