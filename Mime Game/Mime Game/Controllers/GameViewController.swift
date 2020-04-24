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
    
    //MARK: Outlets
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    
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
        // Setar próprio vídeo
        self.seconds = 10
        runTimer()
    }
    
    //MARK: Methods
    
    
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
        print(currentMime?.word)
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
        game.currentPlayer = 0
    }
    
    private func nextTurn() {
        
        if game.currentPlayer == game.uids.count {
            resetTurn()
        }
        
        if self.game.uids[game.currentPlayer] == game.localPlayer.uid {
            setupLocalVideo()
        } else {
            agoraKit.enableLocalVideo(false)
            setupRemotePlayer()
        }
        
        self.resetTimer()
    }
    
    private func setupRemotePlayer() {
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = game.uids[game.currentPlayer]
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
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didReceive event: AgoraChannelMediaRelayEvent) {
        
    }

}
