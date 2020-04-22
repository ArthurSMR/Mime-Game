//
//  DoubleExtension.swift
//
//
//  Created by Rhullian Damião on 21/11/19.
//  Copyright © 2019 MBLabs. All rights reserved.
//

import Foundation

extension Double {
    
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    func getFormattedValue() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt_br")
        let string = formatter.string(from: self as NSNumber)
        
        return string ?? ""
    }
}
