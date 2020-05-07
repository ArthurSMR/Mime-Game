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
    
    //MARK: Variables
    var agoraKit: AgoraRtcEngineKit!
    
    var timer = Timer()
    var seconds = 20
    var turn = -1
    
    var mimes: [Mime] = []
    var selectableMimes: [Mime] = []
    var currentMime: Mime?

    var game: Game!
    var engine: GameEngine?
    var chatStreamId = 3
    var indexStreamId = 4
    var playerIndexStreamId = 5
    
    var messages: [Message] = [] {
        didSet {
            divinerTableView.reloadData()
            divinerTableView.scrollToBottom()
            mimickrTableView.reloadData()
            mimickrTableView.scrollToBottom()
        }
    }
    
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
        engine?.delegate = self
        setupAgora()
        setupLayout()
        engine?.fetchMimes {
            
        }
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
        MessageSystemGameTableViewCell.registerNib(for: divinerTable)
        
        // Setting up mimickr tableView
        mimickrTableView.delegate = self
        mimickrTableView.dataSource = self
        guard let mimickrTable = mimickrTableView else { return }
        ChatTableViewCell.registerNib(for: mimickrTable)
        MessageSystemGameTableViewCell.registerNib(for: mimickrTable)
    }
    
    private func startGame() {
        engine?.startGame()
    }
    
    //MARK: Draw Modals
    func drawPlayerModal() {
        
//        let currentPlayer = getCurrentPlayer()
        
        guard let alert = DrawPlayer.create() else { return }
        alert.delegate = self
        alert.gamerLabel.text = engine?.currentMimickr?.name
        alert.themeLabel.text = self.currentMime?.theme.rawValue
        alert.imageGame.image = engine?.currentMimickr?.avatar
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
    
    // MARK: - Agora settings
    func setupAgora() {
        
        agoraKit.delegate = self
        let numberPointer = UnsafeMutablePointer<Int>(&chatStreamId)
        agoraKit.createDataStream(numberPointer ,
                                  reliable: true,
                                  ordered: true)
        
        let indexNumberPointer = UnsafeMutablePointer<Int>(&indexStreamId)
        agoraKit.createDataStream(indexNumberPointer,
                                  reliable: true,
                                  ordered: true)
        
        let indexPlayerNumberPointer = UnsafeMutablePointer<Int>(&playerIndexStreamId)
        agoraKit.createDataStream(indexPlayerNumberPointer,
                                  reliable: true,
                                  ordered: true)
    }
    
    // MARK: - Timer settings
    /// This method is to start running the timer
    func runTimer() {
        
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: (#selector(updateTimer)),
                                     userInfo: nil, repeats: true)
    }
    
    /// This method is for reseting the timer and increment the turn
    func resetTimer() {
        self.timer.invalidate()
        self.seconds = game.totalTime // Reseting timer
        runTimer()
    }
    
    /// This method is to update the timer and validate if the timer has reached zero
    @objc func updateTimer() {
        
        self.seconds -= 1     //This will decrement the seconds.
        if self.seconds == 0 {
            self.timer.invalidate()
            textField.resignFirstResponder()
            engine?.turnRound()
        }
        self.timerMimickr.text = "\(self.seconds)s"
        self.timerLabel.text = "\(self.seconds)s" //This will update the label.
    }
    
    // MARK: - Refactoring
    
    private func divinerTurn() {
        self.agoraKit.enableLocalVideo(false)
        self.game.localPlayer.type = .diviner
        self.isMimickrView = false
        self.setupRemotePlayer()
    }
    
    private func getPlayer(with index: Int) -> Player {
        
        let playerUid = game.selectablePlayersWithUid[index]
        let player = getPlayer(with: playerUid)
        return player
    }
    

    
    // MARK: Game Methods
    /// This method is to change the mime and get another mime word
    func changeMime() {
                
        self.turn += 1
                
        if self.turn == self.mimes.count {
            self.turn = 0
        }
        var selectedMimeIndex = Int(arc4random()) % self.selectableMimes.count
        let dataSelectedMimeIndex = Data(bytes: &selectedMimeIndex, count: MemoryLayout.size(ofValue: selectedMimeIndex))
        agoraKit.sendStreamMessage(indexStreamId, data: dataSelectedMimeIndex)
        
        self.currentMime = self.selectableMimes[selectedMimeIndex]
        
        OperationQueue.main.addOperation {
            self.wordThemeLbl.text = "Tema: \(self.currentMime?.theme.rawValue ?? "")"
            self.wordLbl.text = "\(self.currentMime?.word ?? "")"
        }

        self.selectableMimes.remove(at: selectedMimeIndex)
    }
    
    /// This method is to reset the turns, that is, the players "line" come back to the beginning
    private func resetTurn() {
        
        game.currentPlayer = 0
    }
    
    /// This method will set the next mimickr and check if all players did some mime
    ///
    /// This method has the logic to turn the round, if the player is available to play and which player will play the next roud
//    private func nextTurn() {
//
//        // if the current player reached the last uid element, it can reset the turn
//        if self.game.currentPlayer >= self.game.uids.count {
//
//            self.resetTurn()
//        }
//
//        // if the current player is the mimickr, it can set the local video
//        if self.game.uids[self.game.currentPlayer] == self.game.localPlayer.uid {
//            self.currentMimickr = self.game.localPlayer
//            self.game.localPlayer.type = .mimickr
//            self.isMimickrView = true
//            self.changeMime()
//            self.setupLocalVideo()
//            self.drawPlayerModal()
//        } else {
//
//            // Used this for to validate if the user is available or not
//            for remotePlayer in game.remotePlayers {
//
//                if remotePlayer.uid == self.game.uids[self.game.currentPlayer] {
//
//                    if remotePlayer.type == .unavailable { // Get the next player
//                        game.currentPlayer += 1
//                        nextTurn()
//                    } else { // if is available, it can set the remote player
//                        self.agoraKit.enableLocalVideo(false)
//                        self.game.localPlayer.type = .diviner
//                        self.isMimickrView = false
//                        self.setupRemotePlayer()
//                    }
//                }
//            }
//        }
//        game.currentPlayer += 1   // Turn next round
//    }
    
    
    /// This method check is the message is correct comparing in a uppercased way
    /// - Parameter word: the received word that will be checked with the right word
    /// - Returns: return a boolean (true if is correct and false if is wrong)
    private func isSentMessageCorrect(word: String) -> Bool {
        return word.uppercased() == self.currentMime?.word.uppercased() ? true : false
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
        
        guard let currentMimickrUid = engine?.currentMimickr?.uid else { return }
        videoCanvas.uid = currentMimickrUid
        videoCanvas.view = self.divinerVideoView
        videoCanvas.renderMode = .fit
        agoraKit.setupRemoteVideo(videoCanvas)
    }
    
    /// This method is to setup the local video to the mimickr video view
    private func setupLocalVideo() {
        
        guard let localPlayer = self.engine?.game.localPlayer else { return }
        self.agoraKit.enableLocalVideo(true)
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = localPlayer.uid
        
        if isMimickrView {
            videoCanvas.view = self.mimickrVideoView
        } else {
            videoCanvas.view = self.divinerVideoView // for the first call of setup video
        }
        videoCanvas.renderMode = .fit
        agoraKit.setupLocalVideo(videoCanvas)
    }
    
    private func setupVideo() {
        
        let configuration = AgoraVideoEncoderConfiguration(size: CGSize(width: self.mimickrVideoView.frame.size.width,
                                                                        height: self.mimickrVideoView.frame.size.height + 40),
                                                           frameRate: .fps30,
                                                           bitrate: AgoraVideoBitrateStandard,
                                                           orientationMode: .adaptative)
        
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
        let isCorrect = isSentMessageCorrect(word: text)
        let message = Message(word: text, player: game.localPlayer, isCorrect: isCorrect)
        self.messages.append(message)
        divinerTableView.reloadData()
        textField.text = ""
    }
    
    // MARK: - Player settings
    /// Get the current player
    /// - Returns: return the current player
    private func getCurrentPlayer() -> Player {
        
        if isMimickrView {
            return game.localPlayer
        } else {
            for player in game.remotePlayers {
                if game.uids[game.currentPlayer] == player.uid {
                    return player
                }
            }
        }
        return Player()
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
        
        if uid == self.game.localPlayer.uid {
            return self.game.localPlayer
        }
        
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
        
        let message = messages[indexPath.row]
        
        if message.isCorrect {
            let cell = MessageSystemGameTableViewCell.dequeueCell(from: tableView)
            cell.messageLbl.text = "\(message.player.name) acertou! \(message.word.uppercased())"
            return cell
            
        } else {
            let cell = ChatTableViewCell.dequeueCell(from: tableView)
            cell.playerName.text = message.player.name
            cell.playerImage.image = message.player.avatar
            cell.word.text = message.word
            return cell
        }
    }
}

//MARK: Agora Delegate
extension GameViewController: AgoraRtcEngineDelegate {
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, receiveStreamMessageFromUid uid: UInt, streamId: Int, data: Data) {
        
        // checking if is the receive stream id is the chat stream ID
        if streamId == self.chatStreamId {
            let decodedMessage = String(decoding: data, as: UTF8.self)
            
            let isCorrect = isSentMessageCorrect(word: decodedMessage)
            
            let message = Message(word: decodedMessage, player: getPlayer(with: uid), isCorrect: isCorrect)

            messages.append(message)
        } else if streamId == self.indexStreamId {
            
            divinerTurn()
            
            let selectedMimeIndex = data.withUnsafeBytes {
                $0.load(as: Int.self)
            }
            self.currentMime = self.selectableMimes[selectedMimeIndex]
            self.engine?.currentMimickr = getPlayer(with: uid)
            OperationQueue.main.addOperation {
                self.drawPlayerModal()
            }
            
            self.selectableMimes.remove(at: selectedMimeIndex)
        } else if streamId == self.playerIndexStreamId {
            
            let selectedPlayerIndex = data.withUnsafeBytes {
                $0.load(as: Int.self)
            }
            self.engine?.currentMimickr = getPlayer(with: selectedPlayerIndex)
            
            if self.engine?.currentMimickr?.uid == self.game.localPlayer.uid {
                //setToMimickr()
            }
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

extension GameViewController : GameEngineDelegate {
    
    func setupNextMime(with index: Int, currentMime: Mime) {
        
        var index = index
        self.currentMime = currentMime
        self.wordThemeLbl.text = "Tema: \(self.currentMime?.theme.rawValue ?? "")"
        self.wordLbl.text = "\(self.currentMime?.word ?? "")"
        let dataSelectedMimeIndex = Data(bytes: &index, count: MemoryLayout.size(ofValue: index))
        agoraKit.sendStreamMessage(indexStreamId, data: dataSelectedMimeIndex)
    }
    
    func setupToMimickr() {
        self.isMimickrView = true
        self.setupLocalVideo()
        self.drawPlayerModal()
    }
    
    func setupNextMimickr(nextMimickrIndex: Data) {
        agoraKit.sendStreamMessage(playerIndexStreamId, data: nextMimickrIndex)
    }
    
    func setupStartGame() {
        self.seconds = 5
        setupLocalVideo()
        isMimickrView = false
        runTimer()
    }
}
