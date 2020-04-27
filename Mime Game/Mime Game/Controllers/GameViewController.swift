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
    @IBOutlet weak var wordCategoryLbl: UILabel!
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
        runTimer()
    }
    
    //MARK: Methods
    func drawPlayerModal() {
        
        guard let alert = DrawPlayer.create() else { return }
        alert.gamerLabel.text = ""
        alert.themeLabel.text = ""
        alert.imageGame.image = UIImage(named: "")
        alert.show(animated: true)
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
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    /// This method is for reseting the timer and increment the turn
    func resetTimer() {
        self.seconds = game.totalTime // Reseting timer
        game.currentPlayer += 1   // Turn next round
        self.turn += 1
        changeMime()
        runTimer()
    }
    
    func changeMime() {
        
        if self.turn == self.mimes.count {
            self.turn = 0
        }
        self.currentMime = self.mimes[self.turn]
        self.wordCategoryLbl.text = "Tema: \(String(describing: self.currentMime?.category))"
        self.wordLbl.text = "\(String(describing: self.currentMime?.category)): \(String(describing: self.currentMime?.word))"
    }
    
    @objc func updateTimer() {
        
        self.seconds -= 1     //This will decrement the seconds.
        if self.seconds == 0 {
            self.timer.invalidate()
            nextTurn()
        }
        self.timerMimickr.text = "\(self.seconds)s"
        self.timerLabel.text = "\(self.seconds)s" //This will update the label.
    }
    
    private func resetTurn() {
        game.currentPlayer = 0
    }
    
    private func nextTurn() {
        
        if game.currentPlayer == game.uids.count {
            resetTurn()
        }
        
        if self.game.uids[game.currentPlayer] == game.localPlayer.uid {
            agoraKit.enableLocalVideo(true)
            self.game.localPlayer.type = .mimickr
            isMimickrView = true
            setupLocalVideo()
        } else {
            agoraKit.enableLocalVideo(false)
            self.game.localPlayer.type = .diviner
            isMimickrView = false
            setupRemotePlayer()
        }
        
        self.resetTimer()
    }
    
    private func changeView(playerType: PlayerType) {
        
        switch playerType {
        case .mimickr:
            self.mimickrView.isHidden = false
            self.divinerView.isHidden = true
        case .diviner:
            self.mimickrView.isHidden = true
            self.divinerView.isHidden = false
        default:
            print("can not load view")
        }
    }
    
    private func setupRemotePlayer() {
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = game.uids[game.currentPlayer]
        videoCanvas.view = self.divinerVideoView
        videoCanvas.renderMode = .fit
        agoraKit.setupRemoteVideo(videoCanvas)
        print("Setup Remote Player")
    }
    
    private func setupLocalVideo() {
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = game.localPlayer.uid
        videoCanvas.view = self.mimickrVideoView //video fica por cima
        videoCanvas.renderMode = .fit
        agoraKit.setupLocalVideo(videoCanvas)
        print("Setup Local Player")
    }
    
    private func setupVideo() {
        
        let configuration = AgoraVideoEncoderConfiguration(size: CGSize(width: self.divinerVideoView.frame.size.width, height: self.divinerVideoView.frame.size.height), frameRate: .fps30, bitrate: AgoraVideoBitrateStandard, orientationMode: .adaptative)
        
        agoraKit.enableVideo()
        agoraKit.setVideoEncoderConfiguration(configuration)
    }
    
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
        return
    }
}
