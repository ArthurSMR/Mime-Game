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
    
    func playFX(named: String){
        
        let url = Bundle.main.url(forResource: named, withExtension: "mp3", subdirectory: "SOUNDS_EFFECTS")!
        
        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.play()
        } catch {
            print("couldn't load file :(")
        }
    }
}
