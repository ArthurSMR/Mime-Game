//
//  Word.swift
//  Mime Game
//
//  Created by Arthur Rodrigues on 23/04/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import Foundation

enum Theme: String {
    case general = "Geral"
    case animal = "Animal"
    case object = "Objeto"
}

struct Mime {
    var word: String
    var theme: Theme
}
