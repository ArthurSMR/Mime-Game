//
//  UIColor+Extension.swift
//  Mime Game
//
//  Created by anthony gianeli on 30/04/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import UIKit

extension UIColor {
    
    static let whiteApp = UIColor(hex: 0xFFFFFF)
    static let darkerBlue = UIColor(hex: 0x1D3A80)
    static let pinkReply = UIColor(hex: 0xEB5390)
    static let mediumBlue = UIColor(hex: 0x2B56A9)
    static let lightBlue = UIColor(hex: 0x8CC6F9)
    static let yellowApp = UIColor(hex: 0xFAE569)
    static let grayApp = UIColor(hex: 0xF3F3F3)
    static let redApp = UIColor(hex: 0xC02A2A)
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
