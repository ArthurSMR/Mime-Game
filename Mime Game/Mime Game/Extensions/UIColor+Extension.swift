//
//  UIColor+Extension.swift
//  Divoem
//
//  Created by AnthonyGianeli on 02/12/19.
//  Copyright © 2019 Divoem. All rights reserved.
//

import UIKit

extension UIColor {
    
    static let appWhite = UIColor.white
    static let orangeEF692E = UIColor(hex: 0xEF692E)
    static let grayBBBBBB = UIColor(hex: 0xBBBBBB)
    static let gray939393 = UIColor(hex: 0x939393)
    static let blue172A42 = UIColor(hex: 0x172A42)
    static let green3BCB5B = UIColor(hex: 0x3BCB5B)
    static let redF84B49 = UIColor(hex: 0xF84B49)
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex: Int) {
        self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
    }
}
