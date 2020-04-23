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
    
    static func fetchMimes(for category: WordCategory, completion: @escaping(_ mimes: [Mime], _ error: MimesError?) -> Void) {
        
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
}

