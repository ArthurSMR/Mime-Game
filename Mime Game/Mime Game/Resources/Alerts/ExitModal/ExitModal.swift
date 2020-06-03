//
//  ExitModal.swift
//  Mime Game
//
//  Created by anthony gianeli on 03/06/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import UIKit

protocol ExitModalDelegate {
    func okBtn()
    func cancelBtn()
}

class ExitModal: UIView, Modal {
    
    var backgroundView: UIView!
    var dialogView: UIView!
    var delegate: ExitModalDelegate?
    
    //MARK: - Outlet
    @IBOutlet var backgroundIBView: UIView!
    @IBOutlet weak var dialogIBView: UIView!
    @IBOutlet weak var okButton: UIButton!
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
    
    @IBAction func okActionButton(_ sender: UIButton) {
        dismissModal()
        delegate?.okBtn()
    }
    
    @IBAction func cancelActionButon(_ sender: UIButton) {
        dismissModal()
        delegate?.cancelBtn()
    }
}

extension ExitModal {
    class func create() -> ExitModal? {
        let nib = UINib(nibName: "ExitModal", bundle: nil)
        let view = nib.instantiate(withOwner: nil, options: nil).first as? ExitModal
        view?.frame = UIScreen.main.bounds
        view?.backgroundView = view?.backgroundIBView
        view?.dialogView = view?.dialogIBView
        return view
    }
}
