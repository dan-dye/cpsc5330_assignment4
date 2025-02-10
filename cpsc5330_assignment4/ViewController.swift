//
//  ViewController.swift
//  cpsc5330_assignment4
//
//  Created by Daniel Dye on 2/7/25.
//

import UIKit
import AVFoundation //For audio player

class ViewController: UIViewController {

    //UI outlets
    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var remainingLabel: UILabel!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    
    //Tracks clock time
    var currentDateTime = Date()
    
    //Date/time formats
    let clockFormat = "EEE, dd MMM yyyy HH:mm:ss"
    let amPMFormat = "a"
    let timeFormat = "HH:mm:ss"
    
    //Misc variables
    var remainingTime = 0.0
    var countDownTimer = Timer()
    var audioPlayer : AVAudioPlayer?
    
    //Flag that indicates music should play
    var timerEnded : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Initializing settings
        startButton.setTitle("Start Timer", for: .normal)
        remainingLabel.text = "Time remaining --:--:--"
        //Creates the timer that will track the realtime clock
        let timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateClock), userInfo: nil, repeats: true)
    }
    
    //Start timer/Stop music button
    @IBAction func buttonClick(_ sender: UIButton) {
        //If timer has not just ended, start new countdown
        if (!timerEnded) {
            countDownTimer.invalidate()
            remainingTime = datePicker.countDownDuration
            countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateRemaingTime), userInfo: nil, repeats: true)
        }
        //Else stop music and reset for new timer
        else {
            startButton.setTitle("Start Timer", for: .normal)
            audioPlayer!.stop()
            timerEnded = false
        }
    }
    
    //Updates realtime clock and background depending on current time and AM/PM status
    @objc func updateClock() {
        currentDateTime = Date()
        let formatter = DateFormatter()
        let amPMFormatter = DateFormatter()
        formatter.dateFormat = clockFormat
        amPMFormatter.dateFormat = amPMFormat
        clockLabel.text = formatter.string(from: currentDateTime)
        let amPMString = amPMFormatter.string(from: currentDateTime)
        if (amPMString == "AM") {
            amOrPM(am: true)
        } else {
            amOrPM(am: false)
        }
    }
    
    //Updates the remaining time label with the time remaining on the current countdown
    @objc func updateRemaingTime() {
        //If time left, keep counting down
        if (remainingTime > 0) {
            remainingLabel.text = "Time Remaining \(timeFormatter(remainingTime))"
            remainingTime -= 1
        }
        //Else play music
        else {
            countDownTimer.invalidate()
            remainingLabel.text = "Time Remaining \(timeFormatter(remainingTime))"
            startButton.setTitle("Stop Music", for: .normal)
            timerEnded = true
            playMusic()
        }
    }
    
    //Formats the countdown timer to "HH:mm:ss" format
    func timeFormatter(_ time: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        return formatter.string(from: time) ?? "00:00:00"
    }
    
    //Plays song.mp3 from Bundle
    func playMusic() {
        let path = Bundle.main.path(forResource: "song", ofType: "mp3")
        let url = URL(fileURLWithPath: path!)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer!.play()
        } catch {
            print("Song.mp3 not found")
        }
        
    }
    
    //Changes to light mode if AM or dark mode if PM
    func amOrPM(am: Bool) {
        if(am) {
            background.image = UIImage(named: "day")
            startButton.backgroundColor = UIColor.black
            clockLabel.textColor = UIColor.black
            remainingLabel.textColor = UIColor.black
            datePicker.backgroundColor = UIColor.clear
        } else {
            background.image = UIImage(named: "night")
            startButton.backgroundColor = UIColor.gray
            clockLabel.textColor = UIColor.white
            remainingLabel.textColor = UIColor.white
            datePicker.backgroundColor = UIColor.white
        }
    }
}

