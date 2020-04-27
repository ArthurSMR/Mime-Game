//
//  DrawPlayer.swift
//  Mime Game
//
//  Created by anthony gianeli on 27/04/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import UIKit

protocol DrawPlayerDelegate {
    func resetTimerPrimary()
}

class DrawPlayer: UIView, Modal {

    var backgroundView: UIView!
    var dialogView: UIView!
    var timer = Timer()
    var seconds = 5
    var delegate: DrawPlayerDelegate?
    
    // MARK: - OUTLETS
    @IBOutlet weak var dialogIBView: UIView!
    @IBOutlet var backgroundIBView: UIView!
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var gamerLabel: UILabel!
    @IBOutlet weak var imageGame: RoundImage!
    
    // MARK: - METHODS
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func dismissModal() {
        
        self.seconds -= 1
        if self.seconds == 0 {
            self.timer.invalidate()
            self.dismiss(animated: true)
            delegate?.resetTimerPrimary()
        }
    }
    
    /// This method is to start running the timer
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(dismissModal)), userInfo: nil, repeats: true)
    }
    
    // MARK: - ACTIONS
}

extension DrawPlayer {
    class func create() -> DrawPlayer? {
        let nib = UINib(nibName: "DrawPlayer", bundle: nil)
        let view = nib.instantiate(withOwner: nil, options: nil).first as? DrawPlayer
        view?.frame = UIScreen.main.bounds
        view?.backgroundView = view?.backgroundIBView
        view?.dialogView = view?.dialogIBView
        return view
    }
}
