//
//  Player.swift
//  Mime Game
//
//  Created by Arthur Rodrigues on 22/04/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import AgoraRtcKit
import UIKit

class Player {
    var uid: UInt
    var name: String
    
    init(agoraUserInfo: AgoraUserInfo) {
        self.uid = agoraUserInfo.uid
        self.name = agoraUserInfo.userAccount ?? "User \(agoraUserInfo.uid)"
    }
}
