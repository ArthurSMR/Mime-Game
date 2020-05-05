//
//  Room.swift
//  Mime Game
//
//  Created by João Vitor Lopes Capi on 05/05/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import Foundation

class Room {
    var host: Player
    
    var name: String
    var theme: Theme
    
    var appId: String
    
    init(host: Player, appId: String, theme: Theme, roomName: String) {
        
        self.host = host
        self.theme = theme
        self.appId = appId
        self.name = roomName
    }
    
}
