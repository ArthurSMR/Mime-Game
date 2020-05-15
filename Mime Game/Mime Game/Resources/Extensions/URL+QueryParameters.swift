//
//  URL+QueryParameters.swift
//  Mime Game
//
//  Created by Arthur Rodrigues on 14/05/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import UIKit

extension URL {
    func getQueryStringParameter(url: String, param: String) -> String? {
      guard let url = URLComponents(string: url) else { return nil }
      return url.queryItems?.first(where: { $0.name == param })?.value
    }
}
