//
//  LobbyTableViewCell.swift
//  Mime Game
//
//  Created by anthony gianeli on 22/04/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import UIKit

class LobbyTableViewCell: UITableViewCell {

    @IBOutlet weak var userImg: RoundImage!
    @IBOutlet weak var nameLbl: UILabel!
    
    var isSpeaking: Bool = false {
        didSet {
            if isSpeaking {
                userImg.borderColor = .green
            } else {
                userImg.borderColor = .clear
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        isSpeaking = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
