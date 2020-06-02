//
//  Validator.swift
//  Mime Game
//
//  Created by Arthur Rodrigues on 29/05/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import UIKit

enum GameSettingsErrors: Error {
    case quantityPlayersWithMimickrOutOfRange
    case themeNameIsEmpty
    case totalTurnTimeOutOfRange
}

class Validator {
    
    func validateGameSettings(gameSettings: GameSettings) throws -> Bool {
        
        guard 30...120 ~= gameSettings.totalTurnTime else { throw GameSettingsErrors.totalTurnTimeOutOfRange }
        
        guard !(gameSettings.theme.isEmpty) else { throw GameSettingsErrors.themeNameIsEmpty }

        guard 1...5 ~=  gameSettings.quantityPlayedWithMimickr else { throw GameSettingsErrors.quantityPlayersWithMimickrOutOfRange }
        
        return true
    }
    
}
