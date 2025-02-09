//
//  ViewController.swift
//  cpsc5330_assignment4
//
//  Created by Daniel Dye on 2/7/25.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var remainingLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    var currentDateTime = Date()
    let clockFormat = "EEE, dd MMM yyyy HH:mm:ss"
    var remainingTime = 0.0
    let timeFormat = "HH:mm:ss"
    var countDownTimer = Timer()
    var timerEnded = false
    var audioPlayer : AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.setTitle("Start Timer", for: .normal)
        remainingLabel.text = "Time remaining --:--:--"
        let timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateClock), userInfo: nil, repeats: true)
    }
    
    @IBAction func buttonClick(_ sender: UIButton) {
        if (!timerEnded) {
            countDownTimer.invalidate()
            remainingTime = datePicker.countDownDuration
            countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateRemaingTime), userInfo: nil, repeats: true)
        }
        else {
            startButton.setTitle("Start Timer", for: .normal)
            audioPlayer!.stop()
            timerEnded = false
        }

    }
    
    @objc func updateClock() {
        currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = clockFormat
        clockLabel.text = formatter.string(from: currentDateTime)
    }
    
    @objc func updateRemaingTime() {
        if (remainingTime > 0) {
            remainingLabel.text = "Time Remaining \(timeFormatter(remainingTime))"
            remainingTime -= 1
        }
        else {
            countDownTimer.invalidate()
            remainingLabel.text = "Time Remaining \(timeFormatter(remainingTime))"
            startButton.setTitle("Stop Music", for: .normal)
            timerEnded = true
            playMusic()
        }
    }
    
    func timeFormatter(_ time: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        return formatter.string(from: time) ?? "00:00:00"
    }
    
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
}

