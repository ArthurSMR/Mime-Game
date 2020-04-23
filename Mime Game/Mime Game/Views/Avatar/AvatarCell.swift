//
//  AvatarCell.swift
//  Mime Game
//
//  Created by João Vitor Lopes Capi on 22/04/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import UIKit

class AvatarCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var avatar: UIImage? {
        didSet{
            self.updateUI()
        }
    }
    static let identifier = "avatarCellId"
    
    private func updateUI(){
        if let avatar = avatar{
            self.imageView.image = avatar
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = max(self.frame.size.width, self.frame.size.height) / 2
        
        self.layer.shadowRadius = 1
        self.layer.shadowOpacity = 0.8
        self.layer.shadowOffset = CGSize(width: 5, height: 10)
        
        self.clipsToBounds = false
    }
    
}
