//
//  UserServices.swift
//  Mime Game
//
//  Created by João Vitor Lopes Capi on 28/04/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import UIKit

class UserServices {
    
    static func saveCurrentUser(user: NoRegisteredPlayerCodable) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: UserDefaults.Keys.currentUser.description)
        }
    }
    
    static func retrieveCurrentUser() -> NoRegisteredPlayerCodable? {
        if let currentUserData = UserDefaults.standard.object(forKey: UserDefaults.Keys.currentUser.description) as? Data {
            let decoder = JSONDecoder()
            if let currentUser = try? decoder.decode(NoRegisteredPlayerCodable.self, from: currentUserData) {
                return currentUser
            }
        }
        return nil
    }
    

    
}
