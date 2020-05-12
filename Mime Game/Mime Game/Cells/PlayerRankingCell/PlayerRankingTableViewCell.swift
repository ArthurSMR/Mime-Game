//
//  PlayerRankingTableViewCell.swift
//  Mime Game
//
//  Created by Arthur Rodrigues on 11/05/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import UIKit

class PlayerRankingTableViewCell: UITableViewCell {

    @IBOutlet weak var ranking: UILabel!
    @IBOutlet weak var playerAvatar: UIImageView!
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var playerPoints: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
