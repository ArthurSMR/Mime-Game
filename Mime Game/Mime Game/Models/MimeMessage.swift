//
//  MimeMessage.swift
//  Mime Game
//
//  Created by Arthur Rodrigues on 12/05/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import UIKit

struct MimeMessage: Codable {
    var newMime: Mime
    var isNewRound: Bool
    var index: Int
}

