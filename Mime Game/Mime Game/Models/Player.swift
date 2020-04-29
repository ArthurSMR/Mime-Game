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
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: )
//        
//    }
    
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
    var isSpeaking: Bool = false
    
    init(agoraUserInfo: AgoraUserInfo, type: PlayerType) {
        self.type = type
        self.uid = agoraUserInfo.uid
        self.name = agoraUserInfo.userAccount ?? "User \(agoraUserInfo.uid)"
        
        let avatarImageURLArray = Bundle.main.urls(forResourcesWithExtension: "png", subdirectory: "test-no-register-avatars")! as [NSURL]
        let avatarDefaultImageURL = avatarImageURLArray.first
        self.avatar = UIImage(contentsOfFile: (avatarDefaultImageURL?.path)!)
    }
    
    init(agoraUserInfo: AgoraUserInfo, type: PlayerType, avatar: UIImage) {
        self.type = type
        self.uid = agoraUserInfo.uid
        self.name = agoraUserInfo.userAccount ?? "User \(agoraUserInfo.uid)"
        self.avatar = avatar
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
