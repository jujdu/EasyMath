//
//  ViewController.swift
//  mathExercises2
//
//  Created by Michael Sidoruk on 04/09/2018.
//  Copyright © 2018 Michael Sidoruk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var goal: UILabel!
    @IBOutlet weak var yourDecision: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startResultButton: UIButton!
    @IBOutlet weak var levelControlerSegment: UISegmentedControl!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var timerSeconds = 0
    var defaultTimerSeconds = SwitchLevel.easy.rawValue
    var timer = Timer()
    var isTimeRunning = false
    var valueForRandomzer = 20
    var score = 0
    var strick = 0
    
    var first = 0
    var second = 0
    var sum = 0
    
    enum SwitchLevel: Int {
        case easy = 10
        case normal = 8
        case hard = 6
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        timerSeconds -= 1     //This will decrement(count down)the seconds.
        timerLabel.text = "\(timerSeconds)" //This will update the label.
        if timerSeconds == 0 {
            showAlert(message: "You are late")
        }
    }
    
    func mathGoal(value: Int) {
        first = Int(arc4random_uniform(UInt32(value)) + 1)
        second = Int(arc4random_uniform(UInt32(value)) + 1)
        self.sum = first + second
    }
    func newRound() {
        yourDecision.isHidden = false
        goal.isHidden = false
        mathGoal(value: valueForRandomzer)
        startResultButton.setTitle("Check", for: .normal)
        startResultButton.backgroundColor = #colorLiteral(red: 0, green: 0.6784313725, blue: 0.7098039216, alpha: 1)
        startResultButton.setTitleColor(#colorLiteral(red: 0.9332413673, green: 0.9333977103, blue: 0.9332208037, alpha: 1), for: .normal)
        goal.text = "\(first)+\(second)"
        yourDecision.setTitle("", for: .normal)
        timerSeconds = defaultTimerSeconds
        timerLabel.text = "\(defaultTimerSeconds)"
        runTimer()
        changeButtonsActivity(true)
    }
    func changeButtonsActivity(_ isEnable: Bool) {
        for buttonTag in 1...10 {
            let button = self.view.viewWithTag(buttonTag) as! UIButton
            if isEnable == false {
                button.layer.backgroundColor = #colorLiteral(red: 0.2235294118, green: 0.2431372549, blue: 0.2745098039, alpha: 0.3592947346)
                button.titleLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.3564854452)
            } else {
                button.layer.backgroundColor = #colorLiteral(red: 0.282281518, green: 0.3065041304, blue: 0.3480320573, alpha: 1)
                button.titleLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7426423373)
            }
            button.isEnabled = isEnable
            button.layer.cornerRadius = 42
            button.layer.masksToBounds = true
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timerLabel.text = "\(defaultTimerSeconds)"
        setStatusStartResetButton()
        yourDecision.setTitle("", for: .normal)
        yourDecision.layer.cornerRadius = 10
        yourDecision.layer.masksToBounds = true
        goal.isHidden = true
        changeButtonsActivity(false)
        view.backgroundColor = #colorLiteral(red: 0.1333333333, green: 0.1568627451, blue: 0.1921568627, alpha: 1)
        let font = UIFont.systemFont(ofSize: 20)
        segmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: font],
                                                for: .normal)
    }
    
    func setStatusStartResetButton() {
        startResultButton.setTitle("Start", for: .normal)
        startResultButton.backgroundColor = #colorLiteral(red: 0.9332413673, green: 0.9333977103, blue: 0.9332208037, alpha: 1)
        startResultButton.setTitleColor(#colorLiteral(red: 0, green: 0.6784313725, blue: 0.7098039216, alpha: 1), for: .normal)
    }
    
    @IBAction func setDecision(_ sender: UIButton) {
        yourDecision.imageView?.stopAnimating()
        if yourDecision.currentTitle!.count != 4 {
            yourDecision.setTitle(yourDecision.currentTitle! + sender.titleLabel!.text!, for: .normal)
            yourDecision.isHidden = false
            changeButtonsActivity(true)
            if yourDecision.currentTitle!.count == 4 {
                changeButtonsActivity(false)
            }
        }
    }
    
    @IBAction func cleanValue(_ sender: UIButton) {
        if yourDecision.currentTitle != "" {
        yourDecision.setTitle(String(yourDecision.titleLabel!.text!.dropLast()), for: .normal)
        changeButtonsActivity(true)
        }
    }
    func showAlert(message: String) {
   
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
        let action = UIAlertAction(title: "A next example", style: .default, handler: {
        action in
        self.addScore()
        self.newRound()
        })
        
        timer.invalidate()
        
        alert.addAction(action)
    
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func changeComplexity(_ sender: UISegmentedControl) {
        setStatusStartResetButton()
        timer.invalidate()
        timerLabel.text = "\(defaultTimerSeconds)"
    }
    
    @IBAction func checkResult(_ sender: UIButton) {
        if startResultButton.titleLabel?.text == "Start" {
            newRound()
        } else {
        Int(yourDecision.currentTitle!) == sum ?
            showAlert(message: "You are right!") :
            showAlert(message: "You are not right, try again!")
        }
    }
    func addScore () {
        if Int(yourDecision.currentTitle!) == sum && timerSeconds != 0 {
            self.strick += 1
            self.score += (2 + timerSeconds * strick) / 3
            scoreLabel.text = String(score)
        } else {
            self.strick = 0
            self.score -= 10
            scoreLabel.text = String(score)
        }
    }
    
    @IBAction func switchLevelAction(_ sender: UISegmentedControl) {
        changeButtonsActivity(false)
        goal.isHidden = true
        self.score = 0
        scoreLabel.text = String(score)
        yourDecision.setTitle("", for: .normal)
        switch sender.selectedSegmentIndex {
        case 0:
            self.defaultTimerSeconds = SwitchLevel.easy.rawValue
            self.valueForRandomzer = 20
            timerLabel.text = "\(defaultTimerSeconds)"
        case 1:
            self.defaultTimerSeconds = SwitchLevel.normal.rawValue
            self.valueForRandomzer = 100
            timerLabel.text = "\(defaultTimerSeconds)"
        case 2:
            self.defaultTimerSeconds = SwitchLevel.hard.rawValue
            self.valueForRandomzer = 500
            timerLabel.text = "\(defaultTimerSeconds)"
        default:
            break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

