//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Keng Siang Lee on 10/3/15.
//  Copyright (c) 2015 KSL. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    //outlet for UI elements
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    //variables for audio recording
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    //variable for keeping track of paused state
    var paused: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        pauseButton.hidden = true
        recordingInProgress.text = "Tap to record"
        paused = false
    }

    //callback when record button is pressed
    @IBAction func recordAudio(sender: UIButton) {
        
        //update UI
        stopButton.hidden = false
        recordButton.enabled = false
        pauseButton.hidden = false
        pauseButton.enabled = true
        
        //record or resume
        if paused {
            paused = false
        } else {
            //prepare file path
            let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
            let currentDateTime = NSDate()
            let formatter = NSDateFormatter()
            formatter.dateFormat = "ddMMyyyy-HHmmss"
            let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
            let pathArray = [dirPath, recordingName]
            let filePath = NSURL.fileURLWithPathComponents(pathArray)
            println(filePath)
            
            //set audio session category
            var session = AVAudioSession.sharedInstance()
            session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
            
            //create instance
            audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
            audioRecorder.prepareToRecord()
        }
        audioRecorder.record()
        recordingInProgress.text = "Recording..."
        println("Recording...")
    }
    
    //delegate callback when recording has finished
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        
        if flag {
            
            //store model
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            
            //perform segue into next view
            self.performSegueWithIdentifier("stopRecordingSegue", sender: recordedAudio)
            
        } else {
            //handle unsuccessful recording
            println("Recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
            recordingInProgress.text = "Tap to record"
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "stopRecordingSegue" {
            //attach recorded data model to the controller before performing the segue
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.data = data
        }
    }
    
    //callback when pause button is pressed
    @IBAction func pauseAudio(sender: UIButton) {
        
        //update UI
        recordButton.enabled = true
        recordingInProgress.text = "Recording paused\nTap to resume"
        pauseButton.enabled = false
        
        //pause
        audioRecorder.pause()
        paused = true
        println("Paused recording")
    }
    
    //callback when stop button is pressed
    @IBAction func stopAudio(sender: UIButton) {
        
        //update UI
        stopButton.hidden = true
        recordButton.enabled = true
        recordingInProgress.text = "Tap to record"
        pauseButton.hidden = true
        
        //reset paused state
        paused = false
        
        //stop recording audio
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        println("Stopped recording")
    }

}

