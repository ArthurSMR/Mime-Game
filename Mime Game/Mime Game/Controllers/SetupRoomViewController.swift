//
//  ThemesViewController.swift
//  Mime Game
//
//  Created by anthony gianeli on 27/05/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import UIKit

enum TextFieldType: Int, CaseIterable {
    case time
    case theme
    case rounds
}

protocol SetupRoomDelegate: class {
    func didChangeRoomSettings(gameSettings: GameSettings)
}

class SetupRoomViewController: UIViewController {
    
    @IBOutlet weak var timeTxtField: UITextField!
    @IBOutlet weak var themeTxtField: UITextField!
    @IBOutlet weak var roundsTxtField: UITextField!
    
    var pickerView = UIPickerView()
    var selectedTheme: Theme?
    var themes: Themes!
    var textFieldType: TextFieldType?
    var selectedTime: Int?
    var times = [30, 60, 90, 120]
    var selectedRound: Int?
    var rounds = [1, 2, 3, 4, 5]
    var selectedIndexForPicker: [Int] = []
    var delegate: SetupRoomDelegate?
    var gameSettings: GameSettings!
    var validator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    //MARK: - Setups
    
    func setup() {
        
        creatingSelectIndexForPicker()
        
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
        setupPickerView()
    }
    
    /// This method will create the index for all text field type
    private func creatingSelectIndexForPicker() {
        for _ in TextFieldType.allCases {
            selectedIndexForPicker.append(0) // will append 0 for all TextFieldType cases. If we have three types, the array should be like this: [0, 0, 0].
        }
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
    
    @objc func donePicker() {
        self.view.endEditing(true)
    }
    
    //MARK: - Methods
    
    /// This method will check what text field was pressed. Using did begin editing.
    /// - Parameter sender: textField pressed
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
        
        // We select the row that the picker was selected.
        // We know the selected index for the picker at the selectedIndexForPicker array.
        pickerView.selectRow(selectedIndexForPicker[textFieldType?.rawValue ?? 0], inComponent: 0, animated: false)
        
        // Set a value when is first responder
        if sender.isFirstResponder {
            guard let textFieldType = textFieldType else { return }
            sender.text = updateLabelAt(textField: sender, for: textFieldType)
        }
    }
    
    /// This method is called when its the first responder for a textField. It will write the first item at the picker view to the textField Text. So, when I press the empty textField, automatically  it will be filled with the first value of your own picker view.
    /// - Parameters:
    ///   - textField: textField using at the moment
    ///   - type: the TextFieldType, it will use to know what information will be set to the textField
    /// - Returns: returns a string with the first information at your picker view
    private func updateLabelAt(textField: UITextField, for type: TextFieldType) -> String {
        
        switch type {
        case .time:
            self.selectedTime = times[pickerView.selectedRow(inComponent: 0)]
            return String(times[pickerView.selectedRow(inComponent: 0)])
        case .theme:
            self.selectedTheme = themes.themes[pickerView.selectedRow(inComponent: 0)]
            return themes.themes[pickerView.selectedRow(inComponent: 0)].name
        case .rounds:
            self.selectedRound = rounds[pickerView.selectedRow(inComponent: 0)]
            return String(rounds[pickerView.selectedRow(inComponent: 0)])
        }
    }
    
    private func canSetRoom() -> Bool {
        
        self.gameSettings = GameSettings(quantityPlayedWithMimickr: selectedRound ?? 0, totalTurnTime: selectedTime ?? 0, theme: selectedTheme ?? Theme(name: "", words: []))
        
        // Trying to validate game settings
        do {
            if try validator.validateGameSettings(gameSettings: self.gameSettings) {
                return true
            }
        } catch (let error as GameSettingsErrors) { // if returns any error, it will be handled here
            
            switch error {
            case .quantityPlayersWithMimickrOutOfRange:
                print("quantityPlayersWithMimickrOutOfRange")
            case .themeNameIsEmpty:
                print("themeNameIsEmpty")
            case .totalTurnTimeOutOfRange:
                print("totalTurnTimeOutOfRange")
            }
        } catch { // if there is no error to handle, it will print this
            print("Ocorreu algum erro ao confirmar as suas configurações")
        }
        return false
    }
    
    //MARK: - Actions
    
    @IBAction func didConfirmButtonPressed(_ sender: UIButton) {
        
        if canSetRoom() {
            delegate?.didChangeRoomSettings(gameSettings: self.gameSettings)
        }
    }
}

//MARK: - Picker View Delegate

extension SetupRoomViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch textFieldType {
        case .time:
            self.selectedTime = times[row]
            timeTxtField.text = String(times[row])
        case .theme:
            self.selectedTheme = themes.themes[row]
            themeTxtField.text = themes.themes[row].name
        case .rounds:
            self.selectedRound = rounds[row]
            roundsTxtField.text = String(rounds[row])
        default:
            print("text field not found")
        }
        
        // Update the array to know what row did the picker stop
        selectedIndexForPicker[textFieldType?.rawValue ?? 0] = row
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
