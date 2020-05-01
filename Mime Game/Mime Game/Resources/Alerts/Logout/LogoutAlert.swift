//
//  LogoutAlert.swift
//  Divoem
//
//  Created by MBLabs Mini1 on 13/02/20.
//  Copyright © 2020 Divoem. All rights reserved.
//

import UIKit
protocol LogoutAlertDelegate {
    func logoutOkayButton()
    func logoutCloseButton()
}

class LogoutAlert: UIView, Modal {

    var backgroundView: UIView!
    var dialogView: UIView!
    var delegate: LogoutAlertDelegate?
    
    // MARK: - OUTLETS
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var dialogIBView: UIView!
    @IBOutlet weak var backgroundIBView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
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
    @IBAction func logoutOkBtn(_ sender: Any) {
        delegate?.logoutOkayButton()
        print("Quero sair")
        dismissModal()
    }
    
    @IBAction func logoutCancelBtn(_ sender: Any) {
        delegate?.logoutCloseButton()
        dismissModal()
    }
    
} 

extension LogoutAlert {
    class func create() -> LogoutAlert? {
        let nib = UINib(nibName: "LogoutAlert", bundle: nil)
        let view = nib.instantiate(withOwner: nil, options: nil).first as? LogoutAlert
        view?.frame = UIScreen.main.bounds
        view?.backgroundView = view?.backgroundIBView
        view?.dialogView = view?.dialogIBView
        return view
    }
}
