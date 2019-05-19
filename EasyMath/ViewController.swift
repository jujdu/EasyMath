//
//  ViewController.swift
//  Easy math
//
//  Created by Michael Sidoruk on 04/09/2018.
//  Copyright © 2018 Michael Sidoruk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var decisionLabel: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startCheckButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var levelSegmentedControl: UISegmentedControl!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent // white color of status bar
    }
    
    var secondsOfTimer = 0
    var statedSecondsOfTimer = SwitchLevel.easy.rawValue
    var timer = Timer()
    var isTimeRunning = false
    var valueForRandomzer = 20
    var score = 0
    var strick = 0
    
    var firstNumber = 0
    var secondNumber = 0
    var sumOfNumbers = 0
    
    enum SwitchLevel: Int {
        case easy = 6
        case normal = 7
        case hard = 8
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timerLabel.text = "\(statedSecondsOfTimer)"
        resetStatusStartCheckButton()
        
        decisionLabel.setTitle("", for: .normal)
        decisionLabel.layer.cornerRadius = 7
        decisionLabel.layer.masksToBounds = true
        taskLabel.isHidden = true
        enableZeroToNineButtons(false)
        view.backgroundColor = #colorLiteral(red: 0.1333333333, green: 0.1568627451, blue: 0.1921568627, alpha: 1)
        
        let font = UIFont.systemFont(ofSize: 20)
        levelSegmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: font],
                                                     for: .normal)
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        secondsOfTimer -= 1     //decrement (count down) the seconds
        timerLabel.text = "\(secondsOfTimer)" //update the label
        if secondsOfTimer == 0 {
            showAlert(message: "You are late")
        }
    }
    
    func mathTask(value: Int) {
        firstNumber = Int(arc4random_uniform(UInt32(value)) + 1)
        secondNumber = Int(arc4random_uniform(UInt32(value)) + 1)
        self.sumOfNumbers = firstNumber + secondNumber
    }
    
    func newRound() {
        decisionLabel.isHidden = false
        taskLabel.isHidden = false
        
        mathTask(value: valueForRandomzer)
        
        startCheckButton.setTitle("Check", for: .normal)
        startCheckButton.backgroundColor = #colorLiteral(red: 0, green: 0.6784313725, blue: 0.7098039216, alpha: 1)
        startCheckButton.setTitleColor(#colorLiteral(red: 0.9332413673, green: 0.9333977103, blue: 0.9332208037, alpha: 1), for: .normal)
        taskLabel.text = "\(firstNumber)+\(secondNumber)"
        decisionLabel.setTitle("", for: .normal)
        secondsOfTimer = statedSecondsOfTimer
        timerLabel.text = "\(statedSecondsOfTimer)"
        
        runTimer()
        enableZeroToNineButtons(true)
    }
    
    func enableZeroToNineButtons(_ isEnable: Bool) {
        for buttonTag in 1...10 {
            let button = self.view.viewWithTag(buttonTag) as! UIButton
            button.isEnabled = isEnable
            switch button.isEnabled {
            case true:
                button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7426423373), for: .disabled)
                button.layer.backgroundColor = #colorLiteral(red: 0.282281518, green: 0.3065041304, blue: 0.3480320573, alpha: 1)
            case false:
                button.layer.backgroundColor = #colorLiteral(red: 0.2235294118, green: 0.2431372549, blue: 0.2745098039, alpha: 0.3592947346)
                button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.3564854452), for: .disabled)
            }
            button.layer.cornerRadius = button.layer.frame.size.width / 2
            button.layer.masksToBounds = true
        }
    }
    
    func resetStatusStartCheckButton() {
        startCheckButton.setTitle("Start", for: .normal)
        startCheckButton.backgroundColor = #colorLiteral(red: 0.9332413673, green: 0.9333977103, blue: 0.9332208037, alpha: 1)
        startCheckButton.setTitleColor(#colorLiteral(red: 0, green: 0.6784313725, blue: 0.7098039216, alpha: 1), for: .normal)
    }
    
    func showAlert(message: String) {
   
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
        let action = UIAlertAction(title: "Next", style: .default, handler: {
        action in
        self.addScore()
        self.newRound()
        })
        
        timer.invalidate() // stop timer
        
        alert.addAction(action)
    
        present(alert, animated: true, completion: nil)
    }
    
    
    func addScore () {
        if Int(decisionLabel.currentTitle!) == sumOfNumbers && secondsOfTimer != 0 {
            self.strick += 1
            self.score += (2 + secondsOfTimer * strick) / 3
            scoreLabel.text = String(score)
        } else {
            self.strick = 0
            self.score -= Int.random(in: 9...23)
            scoreLabel.text = String(score)
        }
    }
    
    @IBAction func setDecisionAction(_ sender: UIButton) {
        if decisionLabel.currentTitle!.count != 4 {
            guard let titleLabel = sender.titleLabel!.text else {  //check for unrap, just example
                print("titleLabel - nil")
                return
            }
            decisionLabel.setTitle(decisionLabel.currentTitle! + titleLabel, for: .normal)
            decisionLabel.isHidden = false
            enableZeroToNineButtons(true)
            if decisionLabel.currentTitle!.count == 4 {
                enableZeroToNineButtons(false)
            }
        }
    }
    
    @IBAction func checkResultOfTaskAction(_ sender: UIButton) {
        if startCheckButton.titleLabel?.text == "Start" {
            newRound()
        } else {
            Int(decisionLabel.currentTitle!) == sumOfNumbers ?
                showAlert(message: "You are right!") :
                showAlert(message: "You are not right, try again!")
        }
    }
    
    @IBAction func cleanValueAction(_ sender: UIButton) {
        if decisionLabel.currentTitle != "" {
            decisionLabel.setTitle(String(decisionLabel.titleLabel!.text!.dropLast()), for: .normal)
            enableZeroToNineButtons(true)
        }
    }
    
    @IBAction func switchLevelAction(_ sender: UISegmentedControl) {
        resetStatusStartCheckButton()
        timer.invalidate() // stop timer
        timerLabel.text = "\(statedSecondsOfTimer)"
        enableZeroToNineButtons(false)
        taskLabel.isHidden = true
        
        self.score = 0
        scoreLabel.text = String(score)
        decisionLabel.setTitle("", for: .normal)
        
        switch sender.selectedSegmentIndex {
        case 0:
            self.statedSecondsOfTimer = SwitchLevel.easy.rawValue
            self.valueForRandomzer = 20
            timerLabel.text = "\(statedSecondsOfTimer)"
        case 1:
            self.statedSecondsOfTimer = SwitchLevel.normal.rawValue
            self.valueForRandomzer = 100
            timerLabel.text = "\(statedSecondsOfTimer)"
        case 2:
            self.statedSecondsOfTimer = SwitchLevel.hard.rawValue
            self.valueForRandomzer = 500
            timerLabel.text = "\(statedSecondsOfTimer)"
        default:
            break
        }
    }
}

