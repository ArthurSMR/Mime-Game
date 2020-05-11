//
//  MimeServices.swift
//  Mime Game
//
//  Created by Arthur Rodrigues on 23/04/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import UIKit

enum MimesError {
    case noDataAvailable
    case canNotProcessData
}

class MimeServices {
    
    static func fetchMimes(for category: Theme, completion: @escaping(_ mimes: [Mime], _ error: MimesError?) -> Void) {
        
        var mimes: [Mime] = []
        
        switch category {
        case .general:
            mimes = MockDatabase.general
        case .animal:
            mimes = MockDatabase.animals
        case .object:
            mimes = MockDatabase.objects
        }
        completion(mimes, nil)
    }
    
//    static func readLocalJsonFile() {
//
//        if let urlPath = Bundle.main.url(forResource: "themesAndWords", withExtension: "json") {
//
//            do {
//                let jsonData = try Data(contentsOf: urlPath, options: .mappedIfSafe)
//                let currentThemes = try JSONDecoder().decode(Themes.self, from: jsonData)
//                
//            }
//            catch let jsonError {
//                print(jsonError)
//            }
//        }
//    }
}

