//
//  TipsViewController.swift
//  Mime Game
//
//  Created by Arthur Rodrigues on 03/06/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import UIKit

class TipsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func dismissButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didReadyButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
