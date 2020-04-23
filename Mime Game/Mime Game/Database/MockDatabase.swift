//
//  MockDatabase.swift
//  Mime Game
//
//  Created by Arthur Rodrigues on 23/04/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import Foundation
import UIKit

class MockDatabase {
    
    static var general: [Mime] {
        
        var array: [Mime] = []
        array.append(contentsOf: self.objects)
        
        array.append(contentsOf: self.animals)
        
        return array
    }
    
    //MARK: Objects
    static var objects: [Mime] {
        
        var array: [Mime] = []
        
        let pen = Mime(word: "Caneta", category: .object)
        array.append(pen)
        
        let book = Mime(word: "Livro", category: .object)
        array.append(book)
        
        let vase = Mime(word: "Vaso", category: .object)
        array.append(vase)
        
        return array
    }
    
    
    //MARK: Animals
    static var animals: [Mime] {
        
        var array: [Mime] = []
        
        let horse = Mime(word: "Cavalo", category: .animal)
        array.append(horse)
        
        let chicken = Mime(word: "Galinha", category: .animal)
        array.append(chicken)
        
        let duck = Mime(word: "Pato", category: .animal)
        array.append(duck)
        
        return array
    }
}
