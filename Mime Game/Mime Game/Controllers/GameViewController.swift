//
//  GameViewController.swift
//  Mime Game
//
//  Created by Arthur Rodrigues on 23/04/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import UIKit
import AgoraRtcKit

protocol DrawPlayerDelegate {
    func dismiss()
}

class GameViewController: UIViewController {
    
    //MARK: Variables
    var agoraKit: AgoraRtcEngineKit!
    var delegateModal: DrawPlayerDelegate?
    
    var timer = Timer()
    var seconds = 20
    var turn = -1
    
    var mimes: [Mime] = []
    var currentMime: Mime?
    var game: Game!
    
    //MARK: Outlets Diviner
    @IBOutlet weak var divinerVideoView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var pointLbl: UILabel!
    @IBOutlet weak var reportBtn: UIButton!
    @IBOutlet weak var infoBtn: UIButton!
    @IBOutlet weak var muteBtn: UIButton!
    @IBOutlet weak var textField: RoundTextField!
    @IBOutlet weak var divinerView: UIView!
    
    //MARK: Outlets Mimickr
    @IBOutlet weak var mimickrVideoView: RoundView!
    @IBOutlet weak var mimickrView: UIView!
    @IBOutlet weak var wordThemeLbl: UILabel!
    @IBOutlet weak var wordLbl: UILabel!
    @IBOutlet weak var timerMimickr: UILabel!
    
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
        setupLayout()
        fetchMimes()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startGame()
    }
    
    private func setupLayout() {
        setupVideo()
    }
    
    private func startGame() {
        game.uids = game.uids.sorted()
        self.seconds = 10
        isMimickrView = false
        setupLocalVideo()
        runTimer()
    }
    
    //MARK: Methodss
    func drawPlayerModal() {
        
        guard let alert = DrawPlayer.create() else { return }
        alert.gamerLabel.text = ""
        alert.themeLabel.text = ""
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
    
    /// This method is to start running the timer
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    /// This method is for reseting the timer and increment the turn
    func resetTimer() {
        self.seconds = game.totalTime // Reseting timer
        game.currentPlayer += 1   // Turn next round
        self.turn += 1
        changeMime()
        runTimer()
    }
    
    /// This method is to change the mime and get another mime word
    func changeMime() {
        
        if self.turn == self.mimes.count {
            self.turn = 0
        }
        self.currentMime = self.mimes[self.turn]
        self.wordThemeLbl.text = "Tema: \(self.currentMime?.theme.rawValue ?? "")"
        self.wordLbl.text = "\(self.currentMime?.word ?? "")"
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
    
    
    /// This method is to reset the turns, that is, the players "line" come back to the beginning
    private func resetTurn() {
        game.currentPlayer = 0
    }
    
    
    /// This method will set the next mimickr and check if all players did some mime
    private func nextTurn() {
        
        drawPlayerModal()
        
        // if the current player reached the last uid element, it can reset the turn
        if self.game.currentPlayer == self.game.uids.count {
            self.resetTurn()
        }
        
        // if the current player is the mimickr, it can set the local video
        if self.game.uids[self.game.currentPlayer] == self.game.localPlayer.uid {
            self.agoraKit.enableLocalVideo(true)
            self.game.localPlayer.type = .mimickr
            
            //self.modalTip()
            
            self.isMimickrView = true
            self.setupLocalVideo()
        } else {
            self.agoraKit.enableLocalVideo(false)
            self.game.localPlayer.type = .diviner
            self.isMimickrView = false
            self.setupRemotePlayer()
        }
        
        self.resetTimer()
        
    }
    
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
        print("Setup Remote Player")
    }
    
    
    /// This method is to setup the local video to the mimickr video view
    private func setupLocalVideo() {
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = game.localPlayer.uid
        videoCanvas.view = self.mimickrVideoView //video fica por cima
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
}

//MARK: Agora Delegate
extension GameViewController: AgoraRtcEngineDelegate {
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didReceive event: AgoraChannelMediaRelayEvent) {
        
    }
}

extension GameViewController: ModalTipDelegate {
    func okayBtn() {
        self.delegateModal?.dismiss()
    }
}
