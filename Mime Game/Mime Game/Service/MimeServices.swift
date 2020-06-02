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
    
//    static func fetchMimes(for category: Theme, completion: @escaping(_ mimes: [Mime], _ error: MimesError?) -> Void) {
//
//        var mimes: [Mime] = []
//
//        switch category {
//        case .general:
//            mimes = MockDatabase.general
//        case .animal:
//            mimes = MockDatabase.animals
//        case .object:
//            mimes = MockDatabase.objects
//        }
//        completion(mimes, nil)
//    }
    
    
    static func fetchMimes(completion: @escaping(_ mimes: [Mime], _ error: MimesError?) -> Void) {

        if let urlPath = Bundle.main.url(forResource: "themesAndWords", withExtension: "json") {

            do {
                let jsonData = try Data(contentsOf: urlPath, options: .mappedIfSafe)
                let allMimes = try JSONDecoder().decode(Themes.self, from: jsonData)
                
                // Word (String) -> Mime
                // Theme.words ([String]) -> [Mime]
                // Themes ([Theme]) -->  Theme -> [mime] --> [Theme] -> [[Mime]] !!
                
                //3
                let wrongMimes = allMimes.themes.map { (theme) -> [Mime] in
                    //1
                    return theme.words.map { (word) -> Mime in
                      //2 -
                        return Mime(name: word, theme: theme.name)
                    }
                }
                
                // Themes dictionary with its name and the words in it
                // [:]
                // [:] + [theme.name: [theme.words]]
                let themes = allMimes.themes.reduce([:]) { (partial, theme) -> [String:[String]] in
                    var newDict = partial
                    newDict[theme.name] = theme.words
                    return newDict
                }
                
                
                let themeNames :[String] = themes.keys.map { $0 }
                let words: [String] = themes["Geral"] ?? []
                
                // mimes with its name and its theme
                // WORD(STRING) -> Mime
                // [String] -> [Mime]
                // [Theme] --> Theme -> [Mime] --> [[Mime]] flatMap --> [Mime]
                // Flat Map  [[1,2],[3,4]]  ==> [1,2,3,4]
                let mimes = allMimes.themes.flatMap { (theme) -> [Mime] in
                    return theme.words.map { (word) -> Mime in
                        return Mime(name: word, theme: theme.name)
                    }
                }
                
                completion(mimes, nil)
                
            }
            catch let jsonError {
                print(jsonError)
                completion([], .canNotProcessData)
            }
        }
    }
    
    static func fetchThemes(completion: @escaping(_ themes: [String:[String]]?, _ error: MimesError?) -> Void) {

        if let urlPath = Bundle.main.url(forResource: "themesAndWords", withExtension: "json") {

            do {
                let jsonData = try Data(contentsOf: urlPath, options: .mappedIfSafe)
                let allThemes = try JSONDecoder().decode(Themes.self, from: jsonData)
                
                let themes = allThemes.themes.reduce([:]) { (partial, theme) -> [String:[String]] in
                    var newDict = partial
                    newDict[theme.name] = theme.words
                    return newDict
                }
                
                completion(themes, nil)
            }
            catch let jsonError {
                print(jsonError)
                completion(nil, .canNotProcessData)
            }
        }
    }
}

