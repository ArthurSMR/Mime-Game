//
//  Room.swift
//  Mime Game
//
//  Created by João Vitor Lopes Capi on 05/05/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import Foundation

class Room {
    var name: String
//    var numberOfPlayers: Int
//    var theme: Theme
    
    var appId: String
    
    init(appId: String, name: String) {
        self.appId = appId
        
//        self.theme = theme
        self.name = name
//        self.numberOfPlayers = numberOfPlayers
    }
    
}
