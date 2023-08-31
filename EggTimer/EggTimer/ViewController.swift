//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var hardness: String = ""
    var seconds = 0
    var totalSeconds = 60
    let eggTimes = ["Soft": 5, "Medium": 420, "Hard": 720]
    var timer = Timer()
    var player: AVAudioPlayer!
    
    @IBOutlet weak var labelEggs: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressBar.progress = 0
        stopButton.isHidden = true
    }

    @objc func handleTimerExecution() {
        
        seconds += 1
        
        if seconds < totalSeconds {
            print("\(seconds) seconds.")
            
            let percent = Float(seconds) / Float(totalSeconds)
            
            print("\(percent) percent.")
            
            // Update progress bar
            progressBar.progress = percent
           
            // Show remaining time
            let remaining = totalSeconds - seconds
            labelEggs.text = String(remaining)
            
        }
        else if seconds == totalSeconds {
            playAlarm()
            stopTimer()
            labelEggs.text = "Done!"
        }
        else {
            timer.invalidate()
            seconds = 0
            print("Error")
        }
    }
    
    @IBAction func eggButtonPress(_ sender: UIButton) {
        
        if sender.currentTitle != nil {
            self.hardness = sender.currentTitle!
            stopButton.isHidden = false
            
            self.totalSeconds = eggTimes[hardness]!
            
            labelEggs.text = String(totalSeconds)
            
            timer.invalidate()
            
            timer = Timer.scheduledTimer(timeInterval: 1,
                                 target: self,
                                 selector: #selector(handleTimerExecution),
                                 userInfo: nil,
                                 repeats: true)
        }

    }
    
    
    @IBAction func stopButtonPress(_ sender: UIButton) {
        stopTimer()
        stopButton.isHidden = true
        labelEggs.text = "Timer stopped."
        
        
        let secondsToDelay = 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
            self.labelEggs.text = "How do you like your eggs?"
        }
        
    }
    
    func stopTimer()
    {
        timer.invalidate()
        progressBar.progress = 1
        seconds = 0
        print("Timer stopped.")

    }
    
    func playAlarm() {
        let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3")
        player = try! AVAudioPlayer(contentsOf: url!)
        player.play()
        
    }
    
}
