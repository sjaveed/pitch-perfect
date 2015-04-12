//
//  SoundRecorderViewController.swift
//  Pitch Perfect
//
//  Created by Shahbaz Javeed on 4/2/15.
//  Copyright (c) 2015 Shahbaz Javeed. All rights reserved.
//

import UIKit
import AVFoundation

class SoundRecorderViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var microphoneButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopRecordingButton: UIButton!

    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    var timer:NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        stopRecordingButton.hidden = true
        microphoneButton.alpha = CGFloat(1.0)
        recordingLabel.text = "Tap mic to record"
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let soundPlayerVC:SoundPlayerViewController = segue.destinationViewController as SoundPlayerViewController
            let data = sender as RecordedAudio
            
            soundPlayerVC.receivedAudio = data
        }
    }
    
    func animateMic() {
        if (audioRecorder != nil && audioRecorder.recording) {
            audioRecorder.updateMeters()
            let audioLevel = audioRecorder.averagePowerForChannel(0)
            let opacity = audioLevel > 0 ? 1.0 : (audioLevel < -80.0 ? 0.5 : 0.5 + (audioLevel + 80.0) / 80.0)

            println(format: "audioLevel: %f, opacity: %f", audioLevel, opacity)
            microphoneButton.alpha = CGFloat(opacity)
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag) {
            recordedAudio = RecordedAudio(title: recorder.url.lastPathComponent!, filePathUrl: recorder.url)
            
            performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            println("Recording failed")
            recordingLabel.text = "Tap mic to record"
            microphoneButton.alpha = CGFloat(1.0)
            microphoneButton.enabled = true
            stopRecordingButton.hidden = true
        }
        
        timer?.invalidate()
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        microphoneButton.enabled = false
        recordingLabel.text = "recording in progress"
        stopRecordingButton.hidden = false

        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"

        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()

        timer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: "animateMic", userInfo: nil, repeats: true)
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        microphoneButton.enabled = true
        recordingLabel.text = "Tap mic to record"
        stopRecordingButton.hidden = true

        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
}

