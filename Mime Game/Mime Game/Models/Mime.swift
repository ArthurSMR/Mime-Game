//
//  Word.swift
//  Mime Game
//
//  Created by Arthur Rodrigues on 23/04/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import Foundation

enum WordCategory {
    case general
    case animal
    case object
}

struct Mime {
    var word: String
    var category: WordCategory
}
