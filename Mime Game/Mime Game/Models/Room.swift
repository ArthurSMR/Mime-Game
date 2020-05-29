//
//  Room.swift
//  Mime Game
//
//  Created by João Vitor Lopes Capi on 05/05/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import UIKit
import CloudKit

class Room: NSObject {
    var name: String
    var numberOfPlayers: Int
    var totalPlayers: Int = 10
    var appId: String
    var themeName: String?
    var recordID: CKRecord.ID!
    
    init(appId: String, name: String, numberOfPlayers: Int) {
        self.appId = appId
        self.name = name
        self.numberOfPlayers = numberOfPlayers
    }
}
