//
//  FirstAccess.swift
//  Divoem
//
//  Created by anthony gianeli on 10/01/20.
//  Copyright © 2020 Divoem. All rights reserved.
//

import UIKit

protocol FirstAccessAlertDelegate {
    func okayButton()
    func closeButton()
}

class FirstAccessAlert: UIView, Modal {

    var backgroundView: UIView!
    var dialogView: UIView!
    var delegate: FirstAccessAlertDelegate?
    
    // MARK: - OUTLETS
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var dialogIBView: UIView!
    @IBOutlet weak var labelMessageTwo: UILabel!
    @IBOutlet weak var labelMessageThree: UILabel!
    @IBOutlet var backgroundIBView: UIView!
    @IBOutlet weak var okayButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    
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
        delegate?.okayButton()
        dismissModal()
    }
    
    @IBAction func closePressed(_ sender: UIButton) {
        delegate?.closeButton()
        dismissModal()
    }
}

extension FirstAccessAlert {
    class func create() -> FirstAccessAlert? {
        let nib = UINib(nibName: "FirstAccessAlert", bundle: nil)
        let view = nib.instantiate(withOwner: nil, options: nil).first as? FirstAccessAlert
        view?.frame = UIScreen.main.bounds
        view?.backgroundView = view?.backgroundIBView
        view?.dialogView = view?.dialogIBView
        return view
    }
}
