//
//  SoundFX.swift
//  Mime Game
//
//  Created by João Vitor Lopes Capi on 15/05/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import UIKit
import AVFoundation

class SoundFX {
    var audioPlayer: AVAudioPlayer
    
    init() {
        self.audioPlayer = AVAudioPlayer()
    }
    
    func playFX(named: String){
        let path = Bundle.main.path(forResource: "\(named).mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.play()
        } catch {
            // couldn't load file :(
        }
    
}
