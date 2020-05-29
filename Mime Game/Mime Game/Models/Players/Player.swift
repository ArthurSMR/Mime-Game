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
enum PlayerType{
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

class Player: Codable {
    var type: PlayerType
    var uid: UInt
    var name: String
    var avatar: UIImage?
    var avatarImagePath: String?
    var isHost: Bool = false
//    var hostIndicator: String?
    
    var isSpeaking: Bool = false
    
    var points: Int = 0
    
    convenience init(agoraUserInfo: AgoraUserInfo, type: PlayerType) {
        self.init()
        self.type = type
        self.uid = agoraUserInfo.uid
        self.name = agoraUserInfo.userAccount ?? "User \(agoraUserInfo.uid)"
        
        let avatarImageNamesArray = LobbyViewController.getAvatarImagesNames()
        let avatarDefaultImageName = avatarImageNamesArray.first
        self.avatar = UIImage(named: avatarDefaultImageName!)
    }
    
    convenience init(agoraUserInfo: AgoraUserInfo, type: PlayerType, avatar: UIImage) {
        self.init()
        self.type = type
        self.uid = agoraUserInfo.uid
        self.name = agoraUserInfo.userAccount ?? "User \(agoraUserInfo.uid)"
        self.avatar = avatar
    }

    init() {
        self.type = .unavailable
        self.uid = UInt()
        self.name = ""
        self.isSpeaking = false
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: UserDefaults.Keys.self)
        let currentUser = try values.decode(Player.self, forKey: .currentUser)

        self.name = currentUser.name
        self.avatar = currentUser.avatar
        self.isSpeaking = currentUser.isSpeaking
        self.uid = currentUser.uid
        self.type = currentUser.type
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: UserDefaults.Keys.self)
        try container.encode(self, forKey: .currentUser)
    }



}
