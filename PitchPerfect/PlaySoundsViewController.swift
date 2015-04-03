//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Keng Siang Lee on 12/3/15.
//  Copyright (c) 2015 KSL. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    //variable for user-recorded audio
    var data:RecordedAudio!
    
    //variables for audio-playing instances
    var audioPlayer:AVAudioPlayer!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //create audio player instance
        audioPlayer = AVAudioPlayer(contentsOfURL: data.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        //create audio engine instance
        audioEngine = AVAudioEngine()
        
        //create audio file instance
        audioFile = AVAudioFile(forReading: data.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //plays audio at given speed
    func playAudio(speed: Float, sender: UIButton) {
        
        //stop and reset
        stopAudio(sender)
        
        //set speed
        audioPlayer.rate = speed
        
        //play
        audioPlayer.play()
        println("Playing audio at \(speed) speed")
    }
    
    //callback when slow button is pressed
    @IBAction func playAudioSlow(sender: UIButton) {
        playAudio(0.5, sender: sender)
    }

    //callback when fast button is pressed
    @IBAction func playAudioFast(sender: UIButton) {
        playAudio(2.0, sender: sender)
    }
    
    //plays audio with given pitch
    func playAudioWithVariablePitch(pitch: Float, sender: UIButton) {
        
        //stop and reset
        stopAudio(sender)
        
        //create and attach audio player node instance
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        //create and attach unit time pitch instance
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        //connect the added nodes
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        //init
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        //play
        audioPlayerNode.play()
        println("Playing audio at \(pitch) pitch")
    }
    
    //callback when chipmunk button is pressed
    @IBAction func playAudioChipmunk(sender: UIButton) {
        playAudioWithVariablePitch(1000, sender: sender)
    }
    
    //callback when darth vader button is pressed
    @IBAction func playAudioDarthVader(sender: UIButton) {
        playAudioWithVariablePitch(-1000, sender: sender)
    }
    
    //callback when echo button is pressed
    @IBAction func playAudioEcho(sender: UIButton) {
        
        //stop and reset
        stopAudio(sender)
        
        //create and attach audio player node instance
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        //create and attach unit delay instance
        let echoEffect = AVAudioUnitDelay()
        echoEffect.delayTime = 0.5
        echoEffect.feedback = 25
        echoEffect.lowPassCutoff = 2000
        echoEffect.wetDryMix = 50
        audioEngine.attachNode(echoEffect)
        
        //connect the added nodes
        audioEngine.connect(audioPlayerNode, to: echoEffect, format: nil)
        audioEngine.connect(echoEffect, to: audioEngine.outputNode, format: nil)
        
        //init
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        //play
        audioPlayerNode.play()
        println("Playing audio with echo")
    }
    
    //callback when reverb button is pressed
    @IBAction func playAudioReverb(sender: UIButton) {
        
        //stop and reset
        stopAudio(sender)
        
        //create and attach audio player node instance
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        //create and attach unit reverb instance
        let reverbEffect = AVAudioUnitReverb()
        reverbEffect.wetDryMix = 50
        audioEngine.attachNode(reverbEffect)
        
        //connect the added nodes
        audioEngine.connect(audioPlayerNode, to: reverbEffect, format: nil)
        audioEngine.connect(reverbEffect, to: audioEngine.outputNode, format: nil)
        
        //init
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        //play
        audioPlayerNode.play()
        println("Playing audio with reverb")
    }
    
    //callback when stop button is pressed
    @IBAction func stopAudio(sender: UIButton) {
        
        //stop and reset audio player
        audioPlayer.stop()
        audioPlayer.volume = 1.0
        audioPlayer.currentTime = 0.0
        
        //stop and reset audio engine
        audioEngine.stop()
        audioEngine.reset()
        
        println("Stopped playing audio")
    }

}
