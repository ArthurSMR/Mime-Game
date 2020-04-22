//
//  DateConverter.swift
//
//
//  Created by Rhullian Damião on 21/11/18.
//  Copyright © 2018 Rhullian Damião. All rights reserved.
//

import Foundation

class DateConverter {
    
    static func convertStringToDate(forString string: String) -> Date? {
        let splitted = string.split(separator: ".")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        return dateFormatter.date(from: String(splitted[0]))
    }
    
    func toDate(withFormat format: String)-> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        dateFormatter.calendar = Calendar.current
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: format)
        
        return date
    }
    
    static func convertStringToDateStringAPIFormat(forDate date: String) -> String? {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd/MM/yyyy"
        guard let dateAux = dateformatter.date(from: date) else { return nil }
        dateformatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        
        return dateformatter.string(from: dateAux)
    }
    
    static func convertStringToDateCompact(withMask mask: String? = nil, format: DateFormatter.DateFormats) -> String? {
        let dateformatter = DateFormatter.getFormatter(format: .iso8601)
        let dateformatter2 = DateFormatter.getFormatter(format: format)
        guard let dateAux = dateformatter.date(from: mask ?? "") else { return nil }
        return dateformatter2.string(from: dateAux)
    }
    
    static func convertDateToString(forDate date: Date,
                                    forMask mask: String?) -> String? {
        let maskForDate = mask ?? "yyyy/MM/dd'T'HH:mm:ss"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = maskForDate
        
        return dateFormatter.string(from: date)
    }
}
