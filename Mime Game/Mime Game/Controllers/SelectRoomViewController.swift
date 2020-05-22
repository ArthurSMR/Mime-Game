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
    var roomsAppIds: [String] = AppIDs.shared.ids
    
    var rooms: [Room] = [Room]()
    
    var incomingName: String?
    var incomingAvatar: UIImage?
    var currentAvatarIndex: Int = 0
    
    var selectedRoom: Room?
    
    var soundFXManager = SoundFX()
    
    var indicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        loadRoomFromCloud()
        
        // Do any additional setup after loading the view.
    }
    
    func setupLayout() {
        prepareTableView()
        setupActivityIndicator()
        indicator.startAnimating()
    }
    
    fileprivate func loadRoomFromCloud() {
        RoomServices.loadRooms(completionHandler: { (rooms, error) in
            if let error = error{
                let failedFetchAlert = UIAlertController(title: "Fetch failed", message: "There was a problem fetching the list of whistles; please try again: \(error.localizedDescription)", preferredStyle: .alert)
                failedFetchAlert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(failedFetchAlert, animated: true)
            }
            else if let rooms = rooms {
                self.rooms = rooms
                OperationQueue.main.addOperation {
                    self.indicator.stopAnimating()
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    func prepareTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        guard let table = tableView else { return }
        SelectRomTableViewCell.registerNib(for: table)
    }
    
    func setupActivityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
    
    @IBAction func exitSelectRoomAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "toLobby":
            if let destinationVC = segue.destination as? LobbyViewController {
                guard let selectedRoom = self.selectedRoom else { return }
                destinationVC.incomingName = self.incomingName
                destinationVC.incomingAvatar = self.incomingAvatar
                destinationVC.currentAvatarIndex = self.currentAvatarIndex
                destinationVC.roomNameStr = selectedRoom.name
                destinationVC.AppID = selectedRoom.appId
            }
        default:
            print("No segue found")
        }
    }
}

extension SelectRoomViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = SelectRomTableViewCell.dequeueCell(from: tableView)
        
        cell.room = rooms[indexPath.row]
        cell.nameLabel.text = cell.room?.name
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard (tableView.cellForRow(at: indexPath) != nil) else { return }
        
        if let selectedCell = tableView.cellForRow(at: indexPath) as? SelectRomTableViewCell {
            self.selectedRoom = selectedCell.room
        }
        
        soundFXManager.playFX(named: "Lobby")
        performSegue(withIdentifier: "toLobby", sender: self)
    }
}
