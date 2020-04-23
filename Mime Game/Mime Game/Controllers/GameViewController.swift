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
    var seconds = 10
    var turn = -1
    
    //MARK: Outlets
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.UIDs = drawPlayers()
        startGame()
    }
    
    private func setupLayout() {
        setupVideo()
    }
    
    private func startGame() {
        setupLocalVideo()
        print(self.UIDs)
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
            agoraKit.enableLocalVideo(false)
            setupRemotePlayer()
        }
        
        seconds = 10
        print(turn)
        turn += 1
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
        
        let configuration = AgoraVideoEncoderConfiguration(size: AgoraVideoDimension640x360, frameRate: .fps30, bitrate: AgoraVideoBitrateStandard, orientationMode: .adaptative)
        
        agoraKit.enableVideo()
        agoraKit.setVideoEncoderConfiguration(configuration)
    }
}

//MARK: Agora Delegate
extension GameViewController: AgoraRtcEngineDelegate {
    
}
