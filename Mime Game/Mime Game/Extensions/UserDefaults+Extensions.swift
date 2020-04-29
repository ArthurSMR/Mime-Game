//
//  UserDefaults+Extensions.swift
//  
//
//  Created by Rhullian Damião on 21/11/19.
//  Copyright © 2019 MBLabs. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    enum Keys: String, CodingKey {
        
        case token
        case currentUser
        case pushToken
        case firstAccess
        case grantAccess
        
        case currentUserName
        case currentUserAvatar
        
        var description: String {
            return self.rawValue
        }
    }
}
