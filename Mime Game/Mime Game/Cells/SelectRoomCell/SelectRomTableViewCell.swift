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
    
    
    @IBOutlet var userCountBox: [UIImageView]!
    
    //MARK: Variables
    var room: Room?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupRoom(room: Room) {
        
        self.nameLabel.text = room.name
        let numberOfPlayerAsString = String(room.numberOfPlayers)
        self.numberOfPlayerLabel.text = "\(numberOfPlayerAsString)/\(room.totalPlayers)"
        
        for userCount in userCountBox {
            
            if userCount.tag < room.numberOfPlayers {
                userCount.image = UIImage(named: "Pessoa_ON")
            } else {
                userCount.image = UIImage(named: "Pessoa_OFF")
            }
        }
    }
    
}
