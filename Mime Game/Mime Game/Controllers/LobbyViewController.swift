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
    var remotePlayers: [Player]!
    
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
        agoraKit.setChannelProfile(.communication)
    }
    
    private func joinChannel() {
        agoraKit.setDefaultAudioRouteToSpeakerphone(true)
        
        agoraKit.joinChannel(byUserAccount: "Arthur", token: nil, channelId: "channel1") { (sid, uid, elapsed) in
            self.createLocalPlayer(uid: uid)
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
        self.remotePlayers?.append(remote)
        
        print("remote \(remote.name) with id \(remote.uid) joined")
        print(remotePlayers!)
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
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didMicrophoneEnabled enabled: Bool) {
        print("microphone is \(enabled)")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteAudioFrameOfUid uid: UInt, elapsed: Int) {
        
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didUpdatedUserInfo userInfo: AgoraUserInfo, withUid uid: UInt) {
        
        let remote =  Player(agoraUserInfo: userInfo)
        self.remotePlayers?.append(remote)
        print(remote.name)
    }
}
