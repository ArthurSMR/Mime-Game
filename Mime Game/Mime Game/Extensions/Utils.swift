//
//  Utils.swift
//  Divoem
//
//  Created by anthony gianeli on 06/12/19.
//  Copyright © 2019 Divoem. All rights reserved.
//

import UIKit

class Utils: NSObject {
    
    static func getDeviceId() -> String {
        return UIDevice.current.identifierForVendor?.uuidString ?? ""
    }
    
    class func getFormattedDateddMMyyyy(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "pt_BR_POSIX")
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
    
    class func getFormattedDateddMM(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "dd/MM"
        return dateFormatter.string(from: date)
    }
    
    class func parseDate(date: String?, format: String? = nil) -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "pt_BR_POSIX")
        dateFormatter.dateFormat = format ?? "dd-MM-yyyy HH:mm:ss"
        guard let date = date else { return nil }
        return dateFormatter.date(from: date)
    }
    
    class func getFormattedDateHHmm(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "pt_BR_POSIX")
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
}


