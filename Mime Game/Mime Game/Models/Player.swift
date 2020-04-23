//
//  Player.swift
//  Mime Game
//
//  Created by Arthur Rodrigues on 22/04/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import AgoraRtcKit
import UIKit

enum PlayerType {
    case local
    case available
    case unavailable
}

class Player {
    var type: PlayerType
    var uid: UInt
    var name: String
    
    init(agoraUserInfo: AgoraUserInfo, type: PlayerType) {
        self.type = type
        self.uid = agoraUserInfo.uid
        self.name = agoraUserInfo.userAccount ?? "User \(agoraUserInfo.uid)"
    }
}
