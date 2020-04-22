//
//  LobbyViewController.swift
//  Mime Game
//
//  Created by anthony gianeli on 22/04/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import UIKit
import AgoraRtcKit

class LobbyViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var exitLobby: UIButton!
    @IBOutlet weak var muteBtn: RoundButton!
    
    var isMuted: Bool = false {
        didSet {
            self.stageBtn(isValid: isMuted)
        }
    }
    
    //MARK: LiveCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    //MARK: Methods
    func setupLayout() {
        prepareTableView()
        self.stageBtn(isValid: false)
    }
    
    func prepareTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        guard let table = tableView else { return }
        LobbyTableViewCell.registerNib(for: table)
        
    }
    
    func stageBtn(isValid valid: Bool) {
       
        muteBtn?.backgroundColor = valid ? .red : .gray
//        muteBtn?.setTitleColor(valid ? .whiteffffff : .whiteffffff, for: .normal)
    }
    
    //MARK: Actions
    @IBAction func didPressExitLobbyBtn(_ sender: UIButton) {
    }
    
    @IBAction func muteActionBtn(_ sender: UIButton) {
        if !isMuted {
            !sender.isSelected
        }
        sender.isSelected = !sender.isSelected
        isMuted = !isMuted
    }
}

//MARK: TableView
extension LobbyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = LobbyTableViewCell.dequeueCell(from: tableView)
        return cell
    }
}

//MARK: Agora
extension LobbyViewController: AgoraRtcEngineDelegate {
}
