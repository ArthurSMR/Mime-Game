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
    //var UIDs: [UInt] = []
    
    var timer = Timer()
    var seconds = 20
    //    var turn =
    
    var game: Game!
    
    //MARK: Outlets
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startGame()
    }
    
    private func setupLayout() {
        setupVideo()
    }
    
    private func startGame() {
        game.uids = game.uids.sorted()
        // Setar próprio vídeo
        self.seconds = 10
        runTimer()
    }
    
    //MARK: Methods
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    func resetTimer() {
        self.seconds = game.totalTime // Reseting timer
        game.turn += 1   // Turn next round
        runTimer()
    }
    
    @objc func updateTimer() {
        
        self.seconds -= 1     //This will decrement the seconds.
        if self.seconds == 0 {
            self.timer.invalidate()
            nextTurn()
        }
        self.timerLabel.text = "\(self.seconds)s" //This will update the label.
    }
    
    private func resetTurn() {
        game.turn = 0
    }
    
    private func nextTurn() {
        
        if game.turn == game.uids.count {
            resetTurn()
        }
        
        if self.game.uids[game.turn] == game.localPlayer.uid {
            setupLocalVideo()
        } else {
            agoraKit.enableLocalVideo(false)
            setupRemotePlayer()
        }
        
        self.resetTimer()
    }
    
    private func setupRemotePlayer() {
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = game.uids[game.turn]
        videoCanvas.view = self.videoView
        videoCanvas.renderMode = .fit
        agoraKit.setupRemoteVideo(videoCanvas)
        print("Setup Remote Player")
    }
    
    private func setupLocalVideo() {
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = game.localPlayer.uid
        videoCanvas.view = self.videoView //video fica por cima
        videoCanvas.renderMode = .fit
        agoraKit.setupLocalVideo(videoCanvas)
        print("Setup Local Player")
    }
    
    private func setupVideo() {
        
        let configuration = AgoraVideoEncoderConfiguration(size: CGSize(width: self.videoView.frame.size.width, height: self.videoView.frame.size.height), frameRate: .fps30, bitrate: AgoraVideoBitrateStandard, orientationMode: .adaptative)
        
        agoraKit.enableVideo()
        agoraKit.setVideoEncoderConfiguration(configuration)
    }
}

//MARK: Agora Delegate
extension GameViewController: AgoraRtcEngineDelegate {
    
}
