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
    
    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var exitLobby: UIButton!
    @IBOutlet weak var muteBtn: RoundButton!
    
    var isMuted: Bool = false {
        didSet {
            self.changeMuteButtonState()
        }
    }
    
    //MARK: LiveCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    //MARK: Methods
    func setupLayout() {
        changeMuteButtonState()
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
    
    /// This method is responsible for initializing Agora framework
    private func initializateAgoraEngine() {
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: AppID, delegate: self)
        agoraKit.enableWebSdkInteroperability(true)
    }
    
    
    /// This method if for join the channel with some userAccount
    private func joinChannel() {
        agoraKit.setDefaultAudioRouteToSpeakerphone(true)
        
        agoraKit.joinChannel(byUserAccount: "Arthur", token: nil, channelId: "channel1") { (sid, uid, elapsed) in
            self.createLocalPlayer(uid: uid)
            self.prepareTableView()
            self.tableView.reloadData()
        }
    }
    
    /// This method is to change the button image and background color when is muted or not
    func changeMuteButtonState() {
        
        if isMuted {
            muteBtn.setImage(UIImage(systemName: "mic.slash.fill"), for: .normal)
            muteBtn.backgroundColor = .red
        } else {
            muteBtn.setImage(UIImage(systemName: "mic.fill"), for: .normal)
            muteBtn.backgroundColor = .gray
        }
    }
    
    // MARK: Players setup
    
    /// This method is for creating a local player
    /// - Parameter uid: uid from the local player
    private func createLocalPlayer(uid: UInt) {
        self.localAgoraUserInfo.userAccount = "Arthur"
        self.localAgoraUserInfo.uid = uid
        self.localPlayer = Player(agoraUserInfo: self.localAgoraUserInfo, type: .local)
        print("Player \(self.localPlayer.name) with ID: \(self.localPlayer.uid) joined")
    }
    
    /// Creating remote player and setting it to available
    /// - Parameter userInfo: the userAccount and the uid from the player joining
    private func createRemotePlayer(userInfo: AgoraUserInfo) {
        
        let remote = Player(agoraUserInfo: userInfo, type: .available)
        self.remotePlayers.append(remote)
        print("remote \(remote.name) with id \(remote.uid) joined")
        self.tableView.reloadData()
    }
    
    
    /// Set the player type to unavailable  when he leaves
    /// - Parameter uid: player leaving uid
    private func removeRemotePlayer(with uid: UInt) {
        
        for remotePlayer in self.remotePlayers {
            if remotePlayer.uid == uid {
                remotePlayer.type = .unavailable
                self.tableView.reloadData()
                print("\(remotePlayer.name) leave channel ")
            }
        }
    }
    
    /// This method is to uptade the player type if he join the lobby again
    /// - Parameter uid: player uid joining
    private func updateRemotePlayers(uid: UInt) {
        
        for updatedPlayer in self.remotePlayers {
            if uid == updatedPlayer.uid {
                updatedPlayer.type = .available
                print("\(updatedPlayer.name) join again")
                self.tableView.reloadData()
            }
        }
    }
    
    /// This method for leaving the channel
    private func leaveChannel() {
        agoraKit.leaveChannel(nil)
    }
    
    /// This method is for return how many players are on the lobby
    /// - Returns: how many players are on the lobby
    private func getPlayersAtLobby() -> Int {
        
        var players = 1
        for remotePlayer in remotePlayers {
            if remotePlayer.type == .available {
                players += 1
            }
        }
        return players
    }
    
    //MARK: Actions
    @IBAction func didPressExitLobbyBtn(_ sender: UIButton) {
        self.leaveChannel()
    }
    
    @IBAction func muteActionBtn(_ sender: UIButton) {
        isMuted = !isMuted
        agoraKit.muteLocalAudioStream(isMuted)
    }
}

//MARK: TableView
extension LobbyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getPlayersAtLobby()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = LobbyTableViewCell.dequeueCell(from: tableView)
        
        if indexPath.row == 0 {  // set local player
            cell.nameLbl.text = localPlayer.name
            cell.userImg.borderColor = changeColorBorderWhenSpeaking(remotePlayer: localPlayer)
        } else {
            let remotePlayer = self.remotePlayers[indexPath.row - 1] // set remote player
            
            // Verifying if remote player is available
            if remotePlayer.type == .available {
                cell.nameLbl.text = remotePlayer.name
                cell.userImg.borderColor = changeColorBorderWhenSpeaking(remotePlayer: remotePlayer)
            }
        }
        return cell
    }
}

//MARK: Agora
extension LobbyViewController: AgoraRtcEngineDelegate {
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteAudioFrameOfUid uid: UInt, elapsed: Int) {
        updateRemotePlayers(uid: uid)
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didUpdatedUserInfo userInfo: AgoraUserInfo, withUid uid: UInt) {
        self.createRemotePlayer(userInfo: userInfo)
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        self.removeRemotePlayer(with: uid)
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, audioTransportStatsOfUid uid: UInt, delay: UInt, lost: UInt, rxKBitRate: UInt) {
        
        for remotePlayer in remotePlayers {
            if uid == remotePlayer.uid {
                print(rxKBitRate)
                if rxKBitRate > 10 {
                    remotePlayer.isSpeaking = true
                    self.tableView.reloadData()
                } else {
                    remotePlayer.isSpeaking = false
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func changeColorBorderWhenSpeaking(remotePlayer: Player) -> UIColor {
        return remotePlayer.isSpeaking ? .green : .clear
    }

}
