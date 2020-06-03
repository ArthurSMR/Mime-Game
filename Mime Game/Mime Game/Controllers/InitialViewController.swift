//
//  InitialViewController.swift
//  Mime Game
//
//  Created by Arthur Rodrigues on 03/06/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func didStartGameButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToSelectAvatar", sender: self)
    }
    
}
