//
//  Player.swift
//  Mime Game
//
//  Created by Arthur Rodrigues on 22/04/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import AgoraRtcKit
import UIKit

/// ThIis enum set the player type
enum PlayerType {
    
    /// If is a local player
    case local
    
    /// If a remote player is available
    case available
    
    ///If a remote player is unavailable
    case unavailable
    
    /// If the player is the mimickr
    case mimickr
    
    /// If the player is the diviner
    case diviner
}

class Player {
    var type: PlayerType
    var uid: UInt
    var name: String
    var isSpeaking: Bool = false
    
    init(agoraUserInfo: AgoraUserInfo, type: PlayerType) {
        self.type = type
        self.uid = agoraUserInfo.uid
        self.name = agoraUserInfo.userAccount ?? "User \(agoraUserInfo.uid)"
    }
}
