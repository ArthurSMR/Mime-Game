//
//  GameViewController.swift
//  Mime Game
//
//  Created by Arthur Rodrigues on 23/04/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import UIKit
import AgoraRtcKit
import Lottie

class GameViewController: UIViewController {
    
    //MARK: Outlets Diviner
    @IBOutlet weak var rightMimeView: AnimationView!
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
    var currentMime: Mime?
    var engine: GameEngine?
    var chatStreamId = 3
    var currentMimeIndexStreamId = 4
    var nextMimickrStreamId = 5
    
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
        engine?.startGame()
    }
    
    private func setupLayout() {
        self.navigationController?.isNavigationBarHidden = true
        setupVideo()
        setupTableView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toDetail" {
            if let destination = segue.destination as? MatchDetailsViewController {
                guard let sortedPlayers = self.engine?.sortPlayers() else { return }
                destination.sortedPlayers = sortedPlayers
            }
            
        }
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
    
    //MARK: Draw Modals
    
    
    /// This method will draw a modal showing what is the next player and the next mime theme
    func drawPlayerModal() {
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
    
    
    /// This method will show the right mime animation
    func setupRightMimeAnimation() {
        textField.resignFirstResponder()
        let animation = Animation.named("acerto_palavra")
        rightMimeView.animation = animation
        rightMimeView.loopMode = .playOnce
        rightMimeView.play()
    }
    
    // MARK: - Agora settings
    func setupAgora() {
        agoraKit.delegate = self
        let numberPointer = UnsafeMutablePointer<Int>(&chatStreamId)
        agoraKit.createDataStream(numberPointer ,
                                  reliable: true,
                                  ordered: true)
        
        let indexNumberPointer = UnsafeMutablePointer<Int>(&currentMimeIndexStreamId)
        agoraKit.createDataStream(indexNumberPointer,
                                  reliable: true,
                                  ordered: true)
        
        let indexPlayerNumberPointer = UnsafeMutablePointer<Int>(&nextMimickrStreamId)
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
        guard let totalTurnTime = self.engine?.totalTurnTime else { return }
        self.seconds = totalTurnTime // Reseting timer
        runTimer()
    }
    
    /// This method is to update the timer and validate if the timer has reached zero
    @objc func updateTimer() {
        
        self.seconds -= 1     //This will decrement the seconds.
        if self.seconds == 0 {
            self.timer.invalidate()
            textField.resignFirstResponder()
            engine?.startTurn()
        }
        self.timerMimickr.text = "\(self.seconds)s"
        self.timerLabel.text = "\(self.seconds)s" //This will update the label.
    }
    
    // MARK: - Update labels
    
    private func updatePointsLabel() {
        guard let selfPoints = self.engine?.game.localPlayer.points else { return }
        self.pointLbl.text = String(selfPoints)
    }
    
    private func updateMimeLabel(currentMime: Mime) {
        self.currentMime = currentMime
        self.wordThemeLbl.text = "Tema: \(self.currentMime?.theme.rawValue ?? "")"
        self.wordLbl.text = "\(self.currentMime?.word ?? "")"
    }
    
    /// This method is to reload and scroll to bottom the diviner and mimickr tableView
    private func updateChatMessage() {
        self.divinerTableView.reloadData()
        self.divinerTableView.scrollToBottom()
        self.mimickrTableView.reloadData()
        self.mimickrTableView.scrollToBottom()
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
    
    /// Set a configuration to video and enable video
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
        self.performSegue(withIdentifier: "toDetail", sender: self)
    }
    
    @IBAction func reportBtn(_ sender: UIButton) {
    }
    
    /// This method is called when the button did pressed, it will get the text on the text on text field and send stream
    /// messege to all player that are on the game.
    /// - Parameter sender: send messege button
    @IBAction func sendMsgBtnDidPressed(_ sender: UIButton) {
        
        guard let textWritten = textField.text else { return }
        guard let currentMimeWord = self.currentMime?.word else { return }
        
        let sendMessege = Data(textWritten.utf8)
        agoraKit.sendStreamMessage(self.chatStreamId, data: sendMessege)
        
        self.engine?.setSentMessage(sentMessage: textWritten, currentMimeWord: currentMimeWord)
    }
}

//MARK: TableView Delegate
extension GameViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.engine?.messages.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let message = self.engine?.messages[indexPath.row] else { return UITableViewCell() }
        
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
            
            guard let currentMimeWord = self.currentMime?.word else { return }
            
            self.engine?.setReceivedMessage(receivedMessage: decodedMessage, currentMimeWord: currentMimeWord, receivedMessegeFrom: uid)
            
        } else if streamId == self.currentMimeIndexStreamId { // Receive mime index
            
            do {
                let decoder = JSONDecoder()
                let mime = try decoder.decode(MimeMessage.self, from: data)
                self.updateMimeLabel(currentMime: mime.newMime)
                self.engine?.removeSelectableMime(with: mime.index)
                
                if mime.isNewRound {
                    OperationQueue.main.addOperation {
                        self.engine?.setCurrentMimickr(player: uid)
                        self.drawPlayerModal()
                    }
                }
            } catch {
                print("error decoding current mime")
            }
        } else if streamId == self.nextMimickrStreamId { // Receive the next mimickr
            
            let selectedNextPlayerIndex = data.withUnsafeBytes {
                $0.load(as: Int.self)
            }
            self.engine?.setNextMimickr(selectedNextPlayerIndex: selectedNextPlayerIndex)
        }
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        self.engine?.removeRemotePlayer(with: uid)
    }
}

//MARK: - ModalTipDelegate
extension GameViewController: ModalTipDelegate {
    
    func okayBtn() {
        return
    }
}

//MARK: - DrawPlayerDelegate
extension GameViewController: DrawPlayerDelegate {
    
    func resetTimerPrimary() {
        self.resetTimer()
    }
}

//MARK: - GameEngineDelegate
extension GameViewController : GameEngineDelegate {
    
    func endGame() {
        // perform segue to ranking final
    }
    
    func didReceiveMessage() {
        self.updateChatMessage()
    }
    
    func didSendMessage() {
        self.updatePointsLabel()
        self.updateChatMessage()
        self.textField.text = ""
    }
    
    func setupToDiviner() {
        self.agoraKit.enableLocalVideo(false)
        self.isMimickrView = false
        self.setupRemotePlayer()
    }
    
    func setupChooseCurrentMime(currentMime: Mime, isNewTurn: Bool, mimeIndex: Int) {

        updateMimeLabel(currentMime: currentMime)
        
        do {
            // encoding mimeMessege object to send as a message the new mime
            guard let currentMime = self.currentMime else { return }
            let encoder = JSONEncoder()
            let data = try encoder.encode(MimeMessage(newMime: currentMime, isNewRound: isNewTurn, index: mimeIndex))
            agoraKit.sendStreamMessage(currentMimeIndexStreamId, data: data)
        } catch {
            print("error trying to encode mime message")
        }
        
        // if it's not the new turn, the local player wrote the correct mime
        // then, it shows the animation
        if !isNewTurn {
            setupRightMimeAnimation()
        }
    }
    
    func setupToMimickr() {
        self.isMimickrView = true
        self.setupLocalVideo()
        self.drawPlayerModal()
    }
    
    func setupNextMimickr(nextMimickrIndex: Data) {
        agoraKit.sendStreamMessage(nextMimickrStreamId, data: nextMimickrIndex)
    }
    
    func setupStartGame() {
        self.seconds = 5
        setupLocalVideo()
        isMimickrView = false
        runTimer()
    }
}
