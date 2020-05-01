//
//  UserDefaults+Extensions.swift
//  Mime Game
//
//  Created by anthony gianeli on 30/04/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    enum Keys: String, CodingKey {
        
        case currentUser
        case currentUserName
        case currentUserAvatar
        
        var description: String {
            return self.rawValue
        }
    }
}
