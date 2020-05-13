//
//  selectRoomViewController.swift
//  Mime Game
//
//  Created by anthony gianeli on 05/05/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import UIKit

class SelectRoomViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Variables
    var roomsAppIds: [String] = ["973c32ecfb4e497a9024240f3126d67f",
                                 "8bc5c63598e44fb4b1d225e428d989b1",
                                 "4e590bda48e241eaae94e5bbe82c24f5",
                                 "2e17ed61f4304738900d390f1822570d",
                                 "c319e187413e4d95804246e3afb30612",
                                 "82211513b49b434cb90b63ba7001c407"]
    
    var incomingName: String?
    var incomingAvatar: UIImage?
    var currentAvatarIndex: Int = 0
    
    var selectedRoomAppId: String?
    var selectedRoomName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        // Do any additional setup after loading the view.
    }
    
    func setupLayout() {
        prepareTableView()
    }
    
    func prepareTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        guard let table = tableView else { return }
        SelectRomTableViewCell.registerNib(for: table)
    }
    
    @IBAction func exitSelectRoomAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "toLobby":
            if let destinationVC = segue.destination as? LobbyViewController {
                destinationVC.incomingName = self.incomingName
                destinationVC.incomingAvatar = self.incomingAvatar
                destinationVC.currentAvatarIndex = self.currentAvatarIndex
                destinationVC.roomNameStr = self.selectedRoomName
                destinationVC.AppID = selectedRoomAppId!
            }
        default:
            print("No segue found")
        }
    }
}

extension SelectRoomViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return roomsAppIds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellRoomName = "Sala \(indexPath.row + 1)"
        
        let cell = SelectRomTableViewCell.dequeueCell(from: tableView)
        
        cell.room = Room(appId: roomsAppIds[indexPath.row], name: cellRoomName)
        cell.nameLabel.text = cell.room?.name
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard (tableView.cellForRow(at: indexPath) != nil) else { return }
        
        // Tente nao dar force pois pode vir nil qualquer hora e o app crashar
        let selectedCell = tableView.cellForRow(at: indexPath) as! SelectRomTableViewCell
        
        self.selectedRoomAppId = selectedCell.room?.appId
        self.selectedRoomName = selectedCell.nameLabel.text
        performSegue(withIdentifier: "toLobby", sender: self)
        
        
    }
}
