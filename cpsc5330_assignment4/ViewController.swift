//
//  ViewController.swift
//  cpsc5330_assignment4
//
//  Created by Daniel Dye on 2/7/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var remainingLabel: UILabel!
    
    var currentDateTime = Date()
    let clockFormat = "EEE, dd MMM yyyy HH:mm:ss"
    var remainingTime = 0.0
    let timeFormat = "HH:mm:ss"
    var countDownTimer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateClock), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
        
        
        
    }
    
    @IBAction func buttonClick(_ sender: UIButton) {
        countDownTimer.invalidate()
        remainingTime = datePicker.countDownDuration
        countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateRemaingTime), userInfo: nil, repeats: true)
        
    }
    
    @objc func updateClock() {
        currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = clockFormat
        clockLabel.text = formatter.string(from: currentDateTime)
    }
    
    @objc func updateRemaingTime() {
        if (remainingTime > 0) {
            remainingLabel.text = "Time Remaining \(remainingTime)"
            remainingTime -= 1
        }
        else {
            countDownTimer.invalidate()
            remainingLabel.text = "Time Remaining \(remainingTime)"
            print("\(remainingTime)")
        }
    }
    



}

