//
//  UrlScheme.swift
//  Mime Game
//
//  Created by Arthur Rodrigues on 14/05/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import UIKit

class DeepLink {
    
    static var shared = DeepLink()
    var appID: String = ""
    var roomName: String = ""
    var shouldNavigateToLobby = false
    
    init(){}
}
