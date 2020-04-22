//
//  DataFormatter+Extensions.swift
//
//
//  Created by Rhullian Damião on 21/11/19.
//  Copyright © 2019 MBLabs. All rights reserved.
//

import Foundation

extension DateFormatter {
    enum DateFormats {
        case iso8601Full
        case iso8601
        case iso8601Compact
        case utc
    }
    
    static func getFormatter(format: DateFormats) -> DateFormatter {
        switch format {
        case .iso8601Full:
            return getIso8601FullFormat()
        case .iso8601:
            return getIso8601Format()
        case .iso8601Compact:
            return getIso8601CompactFormat()
        case .utc:
            return getUtcFormatter()
        }
    }
    
     private static func getIso8601FullFormat() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        return formatter
    }
    
    private static func getIso8601Format() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        return formatter
    }
    
    private static func getIso8601CompactFormat() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }
    
    
    private static func getUtcFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ+00:00"
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        return formatter
    }
}

extension Date {
    static func getCurrentDate(withMask mask: String?) -> Date? {
        let date = Date()
        let current = Calendar.current
        let day = current.component(.day, from: date)
        let month = current.component(.month, from: date)
        let year = current.component(.year, from: date)
        let currentDate = "\(day)/\(month)/\(year)"
        
        let formatter = DateFormatter()
        formatter.dateFormat = mask
        let dateConverted = currentDate.convertStringToDate(withMask: mask ?? "dd/MM/yyyy")
        
        return dateConverted
    }

    static func getAge(withDate date: Date?) -> Int {
        let now = Date()
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: date ?? now, to: now)
        guard let age = ageComponents.year else { return 0}
        return age
    }
}


