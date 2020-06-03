//
//  Modal.swift
//  Mime Game
//
//  Created by anthony gianeli on 30/04/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import Foundation
import UIKit

protocol Modal {
    func show(animated: Bool)
    func dismiss(animated: Bool)
    
    var backgroundView: UIView! { get }
    var dialogView: UIView! { get set }
}

extension Modal where Self: UIView {
    
    func show(animated: Bool) {
        self.backgroundView.alpha = 0
        self.dialogView.center = CGPoint(x: self.center.x, y: self.frame.height + self.dialogView.frame.height / 2)
        UIApplication.shared.keyWindow?.addSubview(self)
        UIApplication.shared.keyWindow?.bringSubviewToFront(self)
        if animated {
            UIView.animate(withDuration: 0.33, animations: {
                self.backgroundView.alpha = 1
            })
            UIView.animate(withDuration: 0.33,
                           delay: 0,
                           usingSpringWithDamping: 0.7,
                           initialSpringVelocity: 10,
                           options: UIView.AnimationOptions(rawValue: 0),
                           animations: { self.dialogView.center = self.center },
                           completion: { (completed) in
                                
            })
        } else {
            self.backgroundView.alpha = 1
            self.dialogView.center = self.center
        }
    }
    
    func dismiss(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.33,
                           animations: {
                            self.backgroundView.alpha = 0
            }, completion: { (completed) in
                
            })
            UIView.animate(withDuration: 0.33,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 10,
                           options: UIView.AnimationOptions(rawValue: 0),
                           animations: {
                            self.dialogView.center = CGPoint(x: self.center.x,
                                                             y: self.frame.height +
                                                                self.dialogView.frame.height / 2)
            }, completion: { (completed) in
                
                self.removeFromSuperview()
            })
        } else {
            self.removeFromSuperview()
        }
    }
    
    func showToPosition(animated: Bool) {
        self.backgroundView.alpha = 0
        let currentPosition = self.dialogView.center
        self.dialogView.center = CGPoint(x: self.center.x, y: self.frame.height + self.dialogView.frame.height / 2)
        UIApplication.shared.keyWindow?.rootViewController?.presentedViewController?.view.addSubview(self)
        if animated {
            UIView.animate(withDuration: 0.33, animations: {
                self.backgroundView.alpha = 1
            })
            UIView.animate(withDuration: 0.33,
                           delay: 0,
                           usingSpringWithDamping: 0.7,
                           initialSpringVelocity: 10,
                           options: UIView.AnimationOptions(rawValue: 0),
                           animations: { self.dialogView.center = currentPosition },
                           completion: { (completed) in
                            
            })
        } else {
            self.backgroundView.alpha = 1
            self.dialogView.center = self.center
        }
    }
}

