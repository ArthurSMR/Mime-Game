//
//  LobbyViewController.swift
//  Mime Game
//
//  Created by anthony gianeli on 22/04/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import UIKit
import AgoraRtcKit
import Lottie

class LobbyViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var exitLobby: UIButton!
    @IBOutlet weak var muteBtn: RoundButton!
    @IBOutlet weak var lobbyView: AnimationView!
    @IBOutlet weak var roomName: UILabel!
    @IBOutlet weak var playersQuantityLbl: UILabel!
    @IBOutlet weak var startGameBtn: UIButton!
    
    //MARK: Variables
    var incomingName: String?
    var incomingAvatar: UIImage?
    var currentAvatarIndex: Int = 0
    var roomNameStr: String?
    var totalPlayers = 10
    let message = "Venha jogar Mimiqueiros comigo 🎭"
    
    private var agoraKit: AgoraRtcEngineKit!
    var room: Room?
    var AppID: String = ""
    
    var localAgoraUserInfo = AgoraUserInfo()
    var localPlayer: Player!
    var remotePlayers: [Player] = []
    var startGame = Data("startGame".utf8)
    var startGameStreamId = 1
    var avatarStreamId = 2
    var gameSettings: GameSettings?
    
    var localIsRoomHost = false
    
    var isMuted: Bool = false {
        didSet {
            self.changeMuteButtonState()
        }
    }
    
    ///This variable list all UIDs that are on the lobby
    var UIDs: [UInt] = []
    
    //MARK: LiveCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        let app = UIApplication.shared.delegate as! AppDelegate
        app.requestCameraPermisson()
        app.requestMicrophonePermission()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViewAnimation()
        RoomServices.userEntered(room: self.room!) { error in
            print(error)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        RoomServices.userLeft(room: self.room!){ error in
            if self.localPlayer.isHost {
                if self.remotePlayers.count != 0{
                    self.remotePlayers[0].isHost = true
                }
            }
        }
    }
    
    //MARK: Methods
    func setupLayout() {
        self.navigationController?.isNavigationBarHidden = true
        self.roomName.text = self.roomNameStr
        changeMuteButtonState()
        setupAgora()
        
    }
    
    func setupViewAnimation() {
        
        let animation = Animation.named("Lobby")
        lobbyView.animation = animation
        lobbyView.loopMode = .loop
        lobbyView.play()
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
        
//        let firstIndexPath = IndexPath(row: 0, section: 0)
//        let firstCell = tableView.cellForRow(at: firstIndexPath) as! LobbyTableViewCell as LobbyTableViewCell
//
        
        
    }
    
    
    /// Auxiliary method.
    /// - Returns: The file names for all avatars avaliable.
    static func getAvatarImagesNames() -> [String] {

        var n: Int = 1
        var avatarAssetName = "Avatar\(n)"
        
        var avatarNames: [String] = []
        
        while UIImage(named: avatarAssetName) != nil{
            
            avatarNames.append(avatarAssetName)
            
            avatarAssetName = "Avatar\(n+1)"
            n += 1
        }
        return avatarNames
    }
    
    
    /// Sends local player avatar image to be displayed to all remote players
    func sendAvatarThroughMessageStream() {
        let avatarNames = LobbyViewController.getAvatarImagesNames()
        let avatarChosenName = avatarNames[self.currentAvatarIndex]
        let dataAvatarName = Data(avatarChosenName.utf8)
        
        self.agoraKit.sendStreamMessage(self.avatarStreamId, data: dataAvatarName)
    }
    
    /// This method is responsible for initializing Agora framework
    private func initializateAgoraEngine() {
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: AppID, delegate: self)
        agoraKit.enableWebSdkInteroperability(true)
    }
    
//    private func validateHost() {
//        if remotePlayers.count == 0 {
//            localPlayer.isHost = true
//            self.startGameBtn.isHidden = false
//        }
//    }
    
    /// This method if for join the channel with some userAccount
    private func joinChannel() {
        
        agoraKit.setDefaultAudioRouteToSpeakerphone(true)
        
        guard let name = incomingName else { return }
        
        agoraKit.joinChannel(byUserAccount: name,
                             token: nil,
                             channelId: self.AppID) { (sid, uid, elapsed) in
                                
            self.createLocalPlayer(uid: uid)
            self.prepareTableView()
            self.tableView.reloadData()
        }
        
        
    }
    
    /// This method is to change the button image and background color when is muted or not
    func changeMuteButtonState() {
        
        if isMuted {
            muteBtn.setImage(UIImage(named: "MuteLobbyOff"), for: .normal)
        } else {
            muteBtn.setImage(UIImage(named: "MuteLobbyOn"), for: .normal)
        }
    }
    
    
    /// ThIs method will update the players quantity label
    private func updatePlayersQuantity() {
        
        var playerQuantity = 1 // it starts with 1 counting the local player
        
        for player in self.remotePlayers {
            if player.type != .unavailable { // it will not count the unavailable players
                playerQuantity += 1
            }
        }
        
        RoomServices.updateNumberOfPlayersTo(number: playerQuantity, room: self.room!)
        
        self.playersQuantityLbl.text = "\(playerQuantity)/\(self.totalPlayers)"
    }
    
    /// This method will create a message  and a link to share with activityController
    func shareLink() {
        
        guard let roomName = self.roomNameStr else { return }
        
        //Enconding room name as url and with query allowed
        guard let roomNameAsURL = roomName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        // Link example:
        // mime://invite-mime-game?appID=973c32ecfb4e497a9024240f3126d67f&roomName=Sala-1
        let openAppPath = "mime://invite-mime-game?appID=\(self.AppID)&roomName=\(roomNameAsURL)"
        
        guard let appURL = URL(string: openAppPath) else { return }
        
        let shareContent: [Any] = [self.message, appURL]
        let activityController = UIActivityViewController(activityItems: shareContent,
                                                          applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)
    }
    
    // MARK: Players setup
    /// This method is for creating a local player
    /// - Parameter uid: uid from the local player
    private func createLocalPlayer(uid: UInt) {
        
        self.localAgoraUserInfo.userAccount = incomingName
        self.localAgoraUserInfo.uid = uid
        self.UIDs.append(uid)
        self.localPlayer = Player(agoraUserInfo: self.localAgoraUserInfo,
                                  type: .local,
                                  avatar: incomingAvatar!)
        
        if self.localIsRoomHost == true{
            self.localPlayer.isHost = true
        }
        
        
        print("Player \(self.localPlayer.name) with ID: \(self.localPlayer.uid) joined")
               
        let startGamePointer = UnsafeMutablePointer<Int>(&startGameStreamId)
        agoraKit.createDataStream(startGamePointer, reliable: true, ordered: true)
        
        let avatarPointer = UnsafeMutablePointer<Int>(&avatarStreamId)
        agoraKit.createDataStream(avatarPointer , reliable: true, ordered: true)
        self.updatePlayersQuantity()
    }
    
    /// Creating remote player and setting it to available
    /// - Parameter userInfo: the userAccount and the uid from the player joining
    private func createRemotePlayer(userInfo: AgoraUserInfo) {
        
        let remote = Player(agoraUserInfo: userInfo, type: .available)
        self.remotePlayers.append(remote)
        self.UIDs.append(remote.uid)
        print("remote \(remote.name) with id \(remote.uid) joined")
        self.tableView.reloadData()
        self.updatePlayersQuantity()
    }
    
    private func setHost(){
        
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
        self.updatePlayersQuantity()
    }
    
    /// This method for leaving the channel
    private func leaveChannel() {
        guard let room = self.room else { print("No room passed on segue"); return }
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
    
    /// mechanism to give a dismiss in a navegation
    /// - Parameter animated: dismiss navigation
    func pop(animated: Bool) {
        self.navigationController?.popViewController(animated: animated)
    }
    
    func checkReceivedAvatarForRemotePlayer(with uid: UInt, with name: String) {
        
        let avatarAssetsNames = LobbyViewController.getAvatarImagesNames()
        
        for avatarName in avatarAssetsNames{
            if avatarName == name {
                for remotePlayer in remotePlayers {
                    if uid == remotePlayer.uid {
                        remotePlayer.avatar = UIImage(named: avatarName)
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    //MARK: Actions
    @IBAction func didPressExitLobbyBtn(_ sender: UIButton) {
        self.leaveChannel()
        DeepLink.shared.shouldNavigateToLobby = false
        pop(animated: true)
    }
    
    @IBAction func didPressShareRoom(_ sender: UIButton) {
        shareLink()
    }
    
    @IBAction func startButtonDidPressed(_ sender: UIButton) {
        agoraKit.sendStreamMessage(self.startGameStreamId, data: startGame)
        self.performSegue(withIdentifier: "startGame", sender: self)
    }
    
    @IBAction func muteActionBtn(_ sender: UIButton) {
        isMuted = !isMuted
        agoraKit.muteLocalAudioStream(isMuted)
    }
    
    //Unwind action
    @IBAction func backToLobby(_segue: UIStoryboardSegue){
        
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "startGame" {
            if let gameVC = segue.destination as? GameViewController {
                let gameEngine = GameEngine(localPlayer: self.localPlayer, remotePlayers: self.remotePlayers)
                gameVC.agoraKit = agoraKit
                gameVC.engine = gameEngine
                gameVC.isMuted = isMuted
            }
        }
        
        else if segue.identifier == "setupRoom" {
            if let setupVC = segue.destination as? SetupRoomViewController {
                setupVC.delegate = self
            }
        }
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
            cell.userImg.image = incomingAvatar
            cell.userImg.borderColor = changeColorBorderWhenSpeaking(remotePlayer: localPlayer)
        } else {
            let remotePlayer = self.remotePlayers[indexPath.row - 1] // set remote player
            
            // Verifying if remote player is available
            if remotePlayer.type == .available {
                cell.nameLbl.text = remotePlayer.name
                cell.userImg.image = remotePlayer.avatar
                cell.userImg.borderColor = changeColorBorderWhenSpeaking(remotePlayer: remotePlayer)
            }
        }
        return cell
    }
}

//MARK: Agora
extension LobbyViewController: AgoraRtcEngineDelegate {
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteAudioFrameOfUid uid: UInt, elapsed: Int) {
        self.sendAvatarThroughMessageStream()
        updateRemotePlayers(uid: uid)
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didUpdatedUserInfo userInfo: AgoraUserInfo, withUid uid: UInt) {
        self.sendAvatarThroughMessageStream()
        self.createRemotePlayer(userInfo: userInfo)
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        self.removeRemotePlayer(with: uid)
        self.updatePlayersQuantity()
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, audioTransportStatsOfUid uid: UInt, delay: UInt, lost: UInt, rxKBitRate: UInt) {
        
        for remotePlayer in remotePlayers {
            if uid == remotePlayer.uid {
                if rxKBitRate > 7 { //This value is to know if a person is speaking
                    remotePlayer.isSpeaking = true
                    self.tableView.reloadData()
                } else {
                    remotePlayer.isSpeaking = false
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    /// This method change the border color when a remote player is speaking
    /// - Parameter remotePlayer: remotePlayer that is speaking
    /// - Returns: returns a green or clear color
    func changeColorBorderWhenSpeaking(remotePlayer: Player) -> UIColor {
        return remotePlayer.isSpeaking ? .green : .clear
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, receiveStreamMessageFromUid uid: UInt, streamId: Int, data: Data) {
        
        if streamId == startGameStreamId {
            let startGameSegue = String(decoding: data, as: UTF8.self)
            if startGameSegue == "startGame" {
                self.performSegue(withIdentifier: startGameSegue, sender: self)
            }
        }
        else if streamId == avatarStreamId {
            let str = String(decoding: data, as: UTF8.self)
            checkReceivedAvatarForRemotePlayer(with: uid, with: str)
        }
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit,
                   didOccurStreamMessageErrorFromUid uid: UInt,
                   streamId: Int,
                   error: Int,
                   missed: Int,
                   cached: Int) {
        
        print("received from \(uid), streamID: \(streamId), error: \(error), missed \(missed), cached \(cached)")
    }
}

// MARK: - SetupRoomDelegate

extension LobbyViewController : SetupRoomDelegate {
    
    func didChangeRoomSettings(gameSettings: GameSettings) {
        self.gameSettings = gameSettings
    }
}
