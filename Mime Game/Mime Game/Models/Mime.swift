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

//// MARK: - Themes
//struct Themes: Codable {
//    let themes: [Theme]
//}
//
//// MARK: - Theme
//struct Theme: Codable {
//    let theme: String
//    let words: [String]
//}
//
//extension Decodable {
//    static func fromJSON<T:Decodable>(_ fileName: String, fileExtension: String="json", bundle: Bundle = .main) throws -> T {
//        guard let url = bundle.url(forResource: fileName, withExtension: fileExtension) else {
//            throw NSError(domain: NSURLErrorDomain, code: NSURLErrorResourceUnavailable)
//        }
//
//        let data = try Data(contentsOf: url)
//
//        return try JSONDecoder().decode(T.self, from: data)
//    }
//}
