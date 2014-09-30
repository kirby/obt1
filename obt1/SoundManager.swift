//
//  SoundManager.swift
//  obt1
//
//  Created by Kirby Shabaga on 8/15/14.
//  Copyright (c) 2014 Kirby Shabaga. All rights reserved.
//

import Foundation
import CoreFoundation
import AVFoundation

var audioPlayers = [AVAudioPlayer]()

class SoundManager {
    
    init() {
        if audioPlayers.count == 0 {
            audioPlayers = setupKeyClickSounds()
        }
    }
    
    // -------------------------------------------------------------------------------------
    
    func setupKeyClickSounds() -> [AVAudioPlayer] {
        let soundFiles = [
            "keyclick1", "keyclick2", "keyclick3", "keyclick4", "keyclick5", "221560__alaskarobotics__laser-shot"
        ]
        
        var avPlayers = [AVAudioPlayer]()
        
        for soundFile in soundFiles {
            var keyClickSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(soundFile, ofType: "wav")!)
            var error : NSError? = nil
            var avPlayer = AVAudioPlayer(contentsOfURL: keyClickSound, error: &error)
            avPlayer.prepareToPlay()
            
            avPlayers.append(avPlayer)
        }
        
        return avPlayers
    }
    
    func playRandomKeylickSound() {
        if (audioPlayers.count == 0) { return }
        
        var r = arc4random_uniform(UInt32(audioPlayers.count))
        var didPlay = audioPlayers[Int(r)].play()
        audioPlayers[Int(r)].prepareToPlay()
    }
    
    func playAlertWithVibration() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
}