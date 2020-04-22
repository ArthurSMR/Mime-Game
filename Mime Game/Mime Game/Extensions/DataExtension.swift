//
//  DataExtension.swift
//
//
//  Created by Rhullian Damião on 21/11/19.
//  Copyright © 2019 MBLabs. All rights reserved.
//

import Foundation

extension Data {
    static func getDataFromUrl(url: String) -> Data? {
        guard let dataUrl = URL(string: url),
            let data = try? Data(contentsOf: dataUrl) else { return nil }
        return data
    }
}
