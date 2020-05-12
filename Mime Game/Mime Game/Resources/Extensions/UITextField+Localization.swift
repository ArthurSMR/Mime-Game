//
//  UITextField+Localization.swift
//  Mime Game
//
//  Created by anthony gianeli on 30/04/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    /// Function to be called inside the shouldChangeCharacters
    func checkIfAchieveTheLimitDefault() -> Bool {
        if (text?.count == 60) {
            return false
        }
        return true
    }
    
    func checkIfAchieveTheLimitName() -> Bool {
        if (text?.count == 20) {
            return false
        }
        return true
    }
    
    func checkIfAchieveTheLimitEmail() -> Bool {
        if (text?.count == 200) {
            return false
        }
        return true
    }
    
    func checkIfAchieveTheLimitPassword() -> Bool {
        if (text?.count == 20) {
            return false
        }
        return true
    }
    
    func checkIfAchieveTheLimitCellphone() -> Bool {
        if (text?.count == 11) {
            return false
        }
        return true
    }
    
    func checkIfAchieveTheLimitDate() -> Bool {
        if (text?.count == 10) {
            return false
        }
        return true
    }
    
    func checkIfAchieveTheLimitCode() -> Bool {
        if (text?.count == 6) {
            return false
        }
        return true
    }
}
