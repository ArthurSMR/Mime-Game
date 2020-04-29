//
//  UITableView+ScrollBottom.swift
//  Mime Game
//
//  Created by Arthur Rodrigues on 29/04/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import UIKit

extension UITableView {
    
    func scrollToBottom(){
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections-1) - 1,
                section: self.numberOfSections - 1)
            self.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}
