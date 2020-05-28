//
//  SelectRomTableViewCell.swift
//  Mime Game
//
//  Created by anthony gianeli on 05/05/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import UIKit

class SelectRomTableViewCell: UITableViewCell {
    
    
    //MARK: Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberOfPlayerLabel: UILabel!
    
    /// users
    @IBOutlet weak var userOne: UIImageView!
    @IBOutlet weak var userTwo: UIImageView!
    @IBOutlet weak var userThree: UIImageView!
    @IBOutlet weak var userFour: UIImageView!
    @IBOutlet weak var userFive: UIImageView!
    @IBOutlet weak var userSix: UIImageView!
    @IBOutlet weak var userSeven: UIImageView!
    @IBOutlet weak var userEight: UIImageView!
    @IBOutlet weak var userNine: UIImageView!
    @IBOutlet weak var userTen: UIImageView!
    
    //MARK: Variables
    var roomm: Room?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupRoom(room: Room) {
        if room.numberOfPlayers == 1 {
            self.userOne.image = UIImage(named: "Pessoa_ON")
        }
    }
    
}
