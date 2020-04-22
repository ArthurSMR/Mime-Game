//
//  Validation.swift
//
//
//  Created by Rhullian Damião on 21/11/19.
//  Copyright © 2019 MBLabs. All rights reserved.
//
import CommonCrypto
import Foundation
import UIKit

extension String {
    
    func validateEmail() -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }
    
// MARK: - HASH MD5
    func md5() -> String! {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str, strLen, result)
        let hash = NSMutableString()
        for index in 0..<digestLen {
            hash.appendFormat("%02x", result[index])
        }
        return String(format: hash as String)
    }
    
    func getFirstName() -> String {
        let splited = self.split(separator: " ")
        return String(splited[0])
    }
    
    func getOnlyHexOfColor() -> UIColor {
        var cString:String = self.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if (cString.count) != 6 {
            return UIColor.gray
        }

        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func convertStringToDate(withMask mask: String?) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = mask ?? "dd-MM-yyyy HH:mm:ss"
        let date = dateFormatter.date(from: self)
        return date
    }
    
    func replace(target: String, withString: String) -> String {
        return self.replacingOccurrences(of: target,
                                         with: withString,
                                         options: NSString.CompareOptions.literal,
                                         range: nil)
    }
    
    func toInt() -> Int? {
        return Int(self)
    }
}
