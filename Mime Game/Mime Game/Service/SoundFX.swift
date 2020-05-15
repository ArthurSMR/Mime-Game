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
    
    var audioPlayer: AVAudioPlayer?
    
    func playFX(named: String) {
        
        guard let url = Bundle.main.url(forResource: named, withExtension: "mp3", subdirectory: "SOUNDS_EFFECTS") else { return }
        
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: url)
            self.audioPlayer?.play()
        } catch {
            print("couldn't load file :(")
        }
    }
}
