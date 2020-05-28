//
//  ThemesViewController.swift
//  Mime Game
//
//  Created by anthony gianeli on 27/05/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import UIKit

enum TextFieldType {
    case time
    case theme
    case rounds
}

class ThemesViewController: UIViewController {
    
    @IBOutlet weak var timeTxtField: UITextField!
    @IBOutlet weak var themeTxtField: UITextField!
    @IBOutlet weak var roundsTxtField: UITextField!
    
    var pickerView = UIPickerView()
    var themes: Themes!
    var textFieldType: TextFieldType?
    var times = [30, 60, 90, 120]
    var rounds = [1, 2, 3, 4, 5]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        
        MimeServices.fetchThemes { (themes, error) in
            if let error = error {
                print(error)
            } else {
                self.themes = themes
                self.setupLayout()
            }
        }
    }
    
    func setupLayout() {
        setupKeyboard()
        setupPickerView()
    }
    
    func setupPickerView() {
        pickerView.dataSource = self
        pickerView.delegate = self
        
        //creating a toolbar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        //creating a flexible space to put the done button on the toolbar's right side
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        //creating done button
        let doneButton = UIBarButtonItem(title: "Concluido", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
        
        //putting the flexible space and the done button into the toolbar
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
    }
    
    func setupKeyboard() {
        //keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func donePicker() {
        self.view.endEditing(true)
    }
    
    //Scroll when keyboard activates
    @objc func keyboardWillShow(notification:NSNotification){
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height/3
            }
        }
    }
    
    //scrolls back when keyboard is dismissed
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @IBAction func assignPickerViewToTextField(_ sender: UITextField) {
        
        switch sender {
        case timeTxtField:
            textFieldType = .time
        case themeTxtField:
            textFieldType = .theme
        case roundsTxtField:
            textFieldType = .rounds
        default:
            print("text field not found")
        }
        sender.inputView = pickerView
        pickerView.reloadAllComponents()
    }
}

extension ThemesViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch textFieldType {
        case .time:
            return times.count
        case .theme:
            return themes.themes.count
        case .rounds:
            return rounds.count
        default:
            print("text field not found")
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch textFieldType {
        case .time:
            return String(times[row])
        case .theme:
            return themes.themes[row].name
        case .rounds:
            return String(rounds[row])
        default:
            print("text field not found")
            return ""
        }
        
    }
}
