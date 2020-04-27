//
//  ModalTip.swift
//  Mime Game
//
//  Created by anthony gianeli on 27/04/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import UIKit

protocol ModalTipDelegate {
    func okayBtn()
}

class ModalTip: UIView, Modal {

    
    var backgroundView: UIView!
    var dialogView: UIView!
    var delegate: ModalTipDelegate?
    
    // MARK: - OUTLETS
    @IBOutlet weak var dialogIBView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet var backgroundIBView: UIView!
    @IBOutlet weak var okayButton: UIButton!
    
    // MARK: - METHODS
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func dismissModal() {
        self.dismiss(animated: true)
    }
    
    // MARK: - ACTIONS
    @IBAction func okPressed(_ sender: UIButton) {
        delegate?.okayBtn()
        dismissModal()
    }
}

extension ModalTip {
    class func create() -> ModalTip? {
        let nib = UINib(nibName: "ModalTip", bundle: nil)
        let view = nib.instantiate(withOwner: nil, options: nil).first as? ModalTip
        view?.frame = UIScreen.main.bounds
        view?.backgroundView = view?.backgroundIBView
        view?.dialogView = view?.dialogIBView
        return view
    }
}
