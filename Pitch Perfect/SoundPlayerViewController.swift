//
//  SoundPlayerViewController.swift
//  Pitch Perfect
//
//  Created by Shahbaz Javeed on 4/6/15.
//  Copyright (c) 2015 Shahbaz Javeed. All rights reserved.
//

import UIKit
import AVFoundation

class SoundPlayerViewController: UIViewController {
    
    var audioEngine:AVAudioEngine!
    var pitchEffect:AVAudioUnitTimePitch!
    var audioPlayer:AVAudioPlayerNode!
    var receivedAudio:RecordedAudio!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioEngine = AVAudioEngine()
        audioPlayer = AVAudioPlayerNode()
        pitchEffect = AVAudioUnitTimePitch()

        audioEngine.attachNode(audioPlayer)
        audioEngine.attachNode(pitchEffect)

        audioEngine.connect(audioPlayer, to: pitchEffect, format: nil)
        audioEngine.connect(pitchEffect, to: audioEngine.outputNode, format: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func playAudioAtRate(rate: Float, pitch: Float) {
        if (audioEngine.running) {
            audioEngine.stop()
            audioPlayer.stop()
        }

        pitchEffect.rate = rate
        pitchEffect.pitch = pitch
        
        audioPlayer.scheduleFile(receivedAudio.audioFile(), atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)

        audioPlayer.play()
    }

    @IBAction func playSlowly(sender: UIButton) {
        println("Playing slowly...")
        playAudioAtRate(0.5, pitch: 1.0)
    }
    
    @IBAction func playFast(sender: UIButton) {
        playAudioAtRate(1.5, pitch: 1.0)
    }

    @IBAction func playAsChipmunk(sender: UIButton) {
        playAudioAtRate(1.0, pitch: 1000)
    }

    @IBAction func playAsVader(sender: UIButton) {
        playAudioAtRate(1.0, pitch: -1000)
    }

    @IBAction func stopPlayback(sender: UIButton) {
        audioPlayer.stop()
    }
}
