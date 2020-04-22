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
    
    //MARK: Variables
    private var agoraKit: AgoraRtcEngineKit!
    var AppID: String = "e6bf51d4429d49eb9b973a0f9b396efd"
    
    var localAgoraUserInfo = AgoraUserInfo()
    var localPlayer: Player!
    var remotePlayers: [Player] = []
    var removedPlayers: [Player] = []
    
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
        self.stageBtn(isValid: false)
        setupAgora()
    }
    
    func setupAgora() {
        initializateAgoraEngine()
        joinChannel()
    }
    
    func prepareTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        guard let table = tableView else { return }
        LobbyTableViewCell.registerNib(for: table)
    }
    
    private func initializateAgoraEngine() {
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: AppID, delegate: self)
        agoraKit.enableWebSdkInteroperability(true)
    }
    
    private func joinChannel() {
        agoraKit.setDefaultAudioRouteToSpeakerphone(true)
        
        agoraKit.joinChannel(byUserAccount: "Arthur", token: nil, channelId: "channel1") { (sid, uid, elapsed) in
            self.createLocalPlayer(uid: uid)
            self.prepareTableView()
        }
    }
    
    private func createLocalPlayer(uid: UInt) {
        self.localAgoraUserInfo.userAccount = "Arthur"
        self.localAgoraUserInfo.uid = uid
        self.localPlayer = Player(agoraUserInfo: self.localAgoraUserInfo)
        print("Player \(self.localPlayer.name) with ID: \(self.localPlayer.uid) joined")
    }
    
    private func createRemotePlayer(userInfo: AgoraUserInfo) {
        
        let remote = Player(agoraUserInfo: userInfo)
        self.remotePlayers.append(remote)
        print("remote \(remote.name) with id \(remote.uid) joined")
        self.tableView.reloadData()
    }
    
    private func removeRemotePlayer(with uid: UInt) {
        
        for index in 0 ..< self.remotePlayers.count {
            if self.remotePlayers[index].uid == uid {
                print("\(self.remotePlayers[index].name) leave channel ")
                self.removedPlayers.append(self.remotePlayers[index])
                self.remotePlayers.remove(at: index)
                self.tableView.reloadData()
            }
        }
    }
    
    private func updateRemotePlayers(uid: UInt) {
        
        for removedPlayer in removedPlayers {
            if uid == removedPlayer.uid {
                self.remotePlayers.append(removedPlayer)
                self.tableView.reloadData()
                print("\(removedPlayer.name) join again")
            }
        }
    }
    
    private func leaveChannel() {
        agoraKit.leaveChannel(nil)
    }
    
    func stageBtn(isValid valid: Bool) {
        
        muteBtn?.backgroundColor = valid ? .red : .gray
        //        muteBtn?.setTitleColor(valid ? .whiteffffff : .whiteffffff, for: .normal)
    }
    
    //MARK: Actions
    @IBAction func didPressExitLobbyBtn(_ sender: UIButton) {
        self.leaveChannel()
    }
    
    @IBAction func muteActionBtn(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        agoraKit.muteLocalAudioStream(sender.isSelected)
        isMuted = !isMuted
    }
}

//MARK: TableView
extension LobbyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.remotePlayers.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = LobbyTableViewCell.dequeueCell(from: tableView)
        // if is the first row, set local player
        if indexPath.row == 0 {
            cell.nameLbl.text = localPlayer.name
        } else {
            let remotePlayer = self.remotePlayers[indexPath.row - 1]
            cell.nameLbl.text = remotePlayer.name
        }
        
        return cell
    }
}

//MARK: Agora
extension LobbyViewController: AgoraRtcEngineDelegate {
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteAudioFrameOfUid uid: UInt, elapsed: Int) {
        updateRemotePlayers(uid: uid)
        self.tableView.reloadData()
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didUpdatedUserInfo userInfo: AgoraUserInfo, withUid uid: UInt) {
        print("2")
        self.createRemotePlayer(userInfo: userInfo)
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        print("3")
        self.removeRemotePlayer(with: uid)
    }
    
}
