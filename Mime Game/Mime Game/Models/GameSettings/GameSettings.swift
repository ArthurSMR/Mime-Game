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
    var theme: Theme
    
    init(quantityPlayedWithMimickr: Int, totalTurnTime: Int, theme: Theme) {
        self.quantityPlayedWithMimickr = quantityPlayedWithMimickr
        self.totalTurnTime = totalTurnTime
        self.theme = theme
    }
}
