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
    var localPlayer: Player!
    var players: [Player] = []
    var agoraKit: AgoraRtcEngineKit!
    var UIDs: [UInt] = []
    
    var timer = Timer()
    
    var totalTime = 20
    var seconds = 20
    
    var _turn = -1
    var turn: Int {
        get {
            print(_turn)
            return _turn
        }
        set {
            if newValue >= self.UIDs.count {
                _turn = -1
            } else {
                _turn = newValue
            }
        }
    }
    
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
        self.UIDs = self.UIDs.sorted()
        runTimer()
        turn += 1
    }
    
    //MARK: Methods
    
    func runTimer() {
         timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        
        self.seconds -= 1     //This will decrement the seconds.
        if self.seconds == 0 {
            self.timer.invalidate()
            nextTurn()
        }
        self.timerLabel.text = "\(self.seconds)s" //This will update the label.
    }
    
    private func nextTurn() {
        
        if self.UIDs[turn] == localPlayer.uid {
            setupLocalVideo()
        } else {
            setupRemotePlayer()
        }
        
        seconds = totalTime // Reseting timer
        turn += 1   // Turn next round
        runTimer()
    }
    
    private func setupRemotePlayer() {
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = self.UIDs[turn]
        videoCanvas.view = self.videoView
        videoCanvas.renderMode = .fit
        agoraKit.setupRemoteVideo(videoCanvas)
        print("Setup Remote Player")
    }
    
    private func setupLocalVideo() {
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = self.localPlayer.uid
        videoCanvas.view = self.videoView //video fica por cima
        videoCanvas.renderMode = .fit
        agoraKit.setupLocalVideo(videoCanvas)
        print("Setup Local Player")
    }
    
    private func drawPlayers() -> [UInt] {
        return self.UIDs.shuffled()
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
