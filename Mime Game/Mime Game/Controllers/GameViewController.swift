//
//  GameViewController.swift
//  Mime Game
//
//  Created by Arthur Rodrigues on 23/04/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import UIKit
import AgoraRtcKit

class GameViewController: UIViewController {
    
    //MARK: Variables
    var agoraKit: AgoraRtcEngineKit!
    
    var timer = Timer()
    var seconds = 20
    var turn = -1
    
    var mimes: [Mime] = []
    var currentMime: Mime?
    var game: Game!
    var chatStreamId = 2
    
    var messages: [Message] = [] {
        didSet {
            divinerTableView.reloadData()
            divinerTableView.scrollToBottom()
            mimickrTableView.reloadData()
            mimickrTableView.scrollToBottom()
        }
    }
    
    //MARK: Outlets Diviner
    @IBOutlet weak var divinerVideoView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var pointLbl: UILabel!
    @IBOutlet weak var reportBtn: UIButton!
    @IBOutlet weak var infoBtn: UIButton!
    @IBOutlet weak var muteBtn: UIButton!
    @IBOutlet weak var textField: RoundTextField!
    @IBOutlet weak var divinerView: UIView!
    @IBOutlet weak var divinerTableView: UITableView!
    
    //MARK: Outlets Mimickr
    @IBOutlet weak var mimickrVideoView: RoundView!
    @IBOutlet weak var mimickrView: UIView!
    @IBOutlet weak var wordThemeLbl: UILabel!
    @IBOutlet weak var wordLbl: UILabel!
    @IBOutlet weak var timerMimickr: UILabel!
    @IBOutlet weak var mimickrTableView: UITableView!
    
    
    var isMimickrView: Bool = false {
        didSet {
            if isMimickrView == false {
                self.changeView(playerType: .diviner)
            } else {
                self.changeView(playerType: .mimickr)
            }
        }
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAgora()
        setupLayout()
        fetchMimes()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startGame()
    }
    
    private func setupLayout() {
        self.navigationController?.isNavigationBarHidden = true
        setupVideo()
        setupTableView()
    }
    
    private func setupTableView() {
        
        // Setting up diviner tableView
        divinerTableView.delegate = self
        divinerTableView.dataSource = self
        guard let divinerTable = divinerTableView else { return }
        ChatTableViewCell.registerNib(for: divinerTable)
        
        // Setting up mimickr tableView
        mimickrTableView.delegate = self
        mimickrTableView.dataSource = self
        guard let mimickrTable = mimickrTableView else { return }
        ChatTableViewCell.registerNib(for: mimickrTable)
    }
    
    private func startGame() {
        game.uids = game.uids.sorted()
        self.seconds = 10
        self.game.localPlayer.type = .diviner
        setupLocalVideo()
        isMimickrView = false
        runTimer()
    }
    
    //MARK: Draw Modals
    func drawPlayerModal() {
        
        guard let alert = DrawPlayer.create() else { return }
        alert.delegate = self
        alert.gamerLabel.text = getCurrentPlayerName()
        alert.themeLabel.text = self.currentMime?.theme.rawValue
        //alert.imageGame.image = UIImage(named: "")
        alert.show(animated: true)
        alert.runTimer()
    }
    
    func modalTip() {
        
        guard let alert = ModalTip.create() else { return }
        alert.delegate = self
        alert.messageLabel.text = ""
        alert.titleLabel.text = ""
        alert.show(animated: true)
    }
    
    // MARK: - Fetches
    
    /// This method is for fetching mimes from the databse
    func fetchMimes() {
        MimeServices.fetchMimes(for: game.wordCategory, completion: { (mimes, error) in
            if let error = error {
                print(error)
            } else {
                self.mimes = mimes
                self.mimes.shuffle()
            }
        })
    }
    
    // MARK: - Agora settings
    func setupAgora() {
        agoraKit.delegate = self
        let numberPointer = UnsafeMutablePointer<Int>(&chatStreamId)
        agoraKit.createDataStream(numberPointer , reliable: true, ordered: true)
    }
    
    // MARK: - Timer settings
    
    /// This method is to start running the timer
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    /// This method is for reseting the timer and increment the turn
    func resetTimer() {
        self.seconds = game.totalTime // Reseting timer
        runTimer()
    }
    
    /// This method is to update the timer and validate if the timer has reached zero
    @objc func updateTimer() {
        
        self.seconds -= 1     //This will decrement the seconds.
        if self.seconds == 0 {
            self.timer.invalidate()
            nextTurn()
        }
        self.timerMimickr.text = "\(self.seconds)s"
        self.timerLabel.text = "\(self.seconds)s" //This will update the label.
    }
    
    // MARK: Game Methods
    
    /// This method is to change the mime and get another mime word
    func changeMime() {
        
        if self.turn == self.mimes.count {
            self.turn = 0
        }
        self.currentMime = self.mimes[self.turn]
        self.wordThemeLbl.text = "Tema: \(self.currentMime?.theme.rawValue ?? "")"
        self.wordLbl.text = "\(self.currentMime?.word ?? "")"
    }
    
    /// This method is to reset the turns, that is, the players "line" come back to the beginning
    private func resetTurn() {
        game.currentPlayer = 0
    }
    
    /// This method will set the next mimickr and check if all players did some mime
    ///
    /// This method has the logic to turn the round, if the player is available to play and which player will play the next roud
    private func nextTurn() {
        
        print(game.currentPlayer)
        // if the current player reached the last uid element, it can reset the turn
        if self.game.currentPlayer >= self.game.uids.count {
            self.resetTurn()
        }
        
        // if the current player is the mimickr, it can set the local video
        if self.game.uids[self.game.currentPlayer] == self.game.localPlayer.uid {
            self.game.localPlayer.type = .mimickr
            self.isMimickrView = true
            //self.modalTip()
            
            self.setupLocalVideo()
        } else {
            
            // Used this for to validate if the user is available or not
            for remotePlayer in game.remotePlayers {
                if remotePlayer.uid == self.game.uids[self.game.currentPlayer] {
                    if remotePlayer.type == .unavailable { // Get the next player
                        game.currentPlayer += 1
                        nextTurn()
                    } else { // if is available, it can set the remote player
                        self.agoraKit.enableLocalVideo(false)
                        self.game.localPlayer.type = .diviner
                        self.isMimickrView = false
                        self.setupRemotePlayer()
                    }
                }
            }
        }
        // Turning the round
        self.turn += 1
        changeMime()
        drawPlayerModal()
        game.currentPlayer += 1   // Turn next round
    }
    
    // MARK: - View/Videos Settings
    
    /// This method is to change the mimickr and the diviver view
    /// - Parameter playerType: it can be mimickr or diviner
    private func changeView(playerType: PlayerType) {
        
        switch playerType {
        case .mimickr:
            self.mimickrView.isHidden = false
            self.divinerView.isHidden = true
        case .diviner:
            self.mimickrView.isHidden = true
            self.divinerView.isHidden = false
        default:
            print("can not load view to player with type \(playerType), just to mimickr and diviner")
        }
    }
    
    /// This method is to setup remotePlayer to the diviner video view
    private func setupRemotePlayer() {
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = game.uids[game.currentPlayer]
        videoCanvas.view = self.divinerVideoView
        videoCanvas.renderMode = .fit
        agoraKit.setupRemoteVideo(videoCanvas)
        print("Setup Remote Player with name \(getCurrentPlayerName())")
    }
    
    /// This method is to setup the local video to the mimickr video view
    private func setupLocalVideo() {
        self.agoraKit.enableLocalVideo(true)
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = game.localPlayer.uid
        
        if isMimickrView {
            videoCanvas.view = self.mimickrVideoView
        } else {
            videoCanvas.view = self.divinerVideoView // for the first call of setup video
        }
        videoCanvas.renderMode = .fit
        agoraKit.setupLocalVideo(videoCanvas)
        print("Setup Local Player")
    }
    
    private func setupVideo() {
        
        let configuration = AgoraVideoEncoderConfiguration(size: CGSize(width: self.mimickrVideoView.frame.size.width * 1.1, height: self.mimickrVideoView.frame.size.height * 1.1), frameRate: .fps30, bitrate: AgoraVideoBitrateStandard, orientationMode: .adaptative)
        
        agoraKit.enableVideo()
        agoraKit.setVideoEncoderConfiguration(configuration)
    }
    
    //MARK: Actions
    
    @IBAction func muteActionBtn(_ sender: UIButton) {
    }
    
    @IBAction func infoActionBtn(_ sender: UIButton) {
    }
    
    @IBAction func reportBtn(_ sender: UIButton) {
    }
    
    /// This method is called when the button did pressed, it will get the text on the text on text field and send stream
    /// messege to all player that are on the game.
    /// - Parameter sender: send messege button
    @IBAction func sendMsgBtnDidPressed(_ sender: UIButton) {
        
        guard let text = textField.text else { return }
        let sendMessege = Data(text.utf8)
        agoraKit.sendStreamMessage(self.chatStreamId, data: sendMessege)
        let message = Message(word: text, player: game.localPlayer)
        self.messages.append(message)
        divinerTableView.reloadData()
        textField.text = ""
    }
    
    // MARK: - Player settings
    
    /// Get the current player name, describing a string
    /// - Returns: return the current player name as string
    private func getCurrentPlayerName() -> String{
        
        if isMimickrView {
            return game.localPlayer.name
        } else {
            for player in game.remotePlayers {
                if game.uids[game.currentPlayer] == player.uid {
                    return player.name
                }
            }
        }
        
        return ""
    }
    
    /// Set the player type to unavailable  when he leaves
    /// - Parameter uid: player leaving uid
    private func removeRemotePlayer(with uid: UInt) {
        
        for remotePlayer in game.remotePlayers {
            if remotePlayer.uid == uid {
                remotePlayer.type = .unavailable
                print("\(remotePlayer.name) leave channel ")
            }
        }
    }
    
    private func getPlayer(with uid: UInt) -> Player {
        
        for remotePlayer in game.remotePlayers {
            if remotePlayer.uid == uid {
                return remotePlayer
            }
        }
        return Player()
    }
}

//MARK: TableView Delegate
extension GameViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = ChatTableViewCell.dequeueCell(from: tableView)
        let message = messages[indexPath.row]
        cell.playerName.text = message.player.name
        cell.word.text = message.word
        
        return cell
    }
}

//MARK: Agora Delegate
extension GameViewController: AgoraRtcEngineDelegate {
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, receiveStreamMessageFromUid uid: UInt, streamId: Int, data: Data) {
        
        if streamId == self.chatStreamId {
            let decodedMessage = String(decoding: data, as: UTF8.self)
            print("received from \(uid) message: \(decodedMessage)")
            let message = Message(word: decodedMessage, player: getPlayer(with: uid))
            messages.append(message)
        }
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        self.removeRemotePlayer(with: uid)
    }
}

extension GameViewController: ModalTipDelegate {
    func okayBtn() {
        return
    }
}

extension GameViewController: DrawPlayerDelegate {
    
    func resetTimerPrimary() {
        self.resetTimer()
    }
}


