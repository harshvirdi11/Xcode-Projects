//
//  ViewController.swift
//  Menu Bars
//
//  Created by Harsh Virdi on 15/01/26.
//

import UIKit

class ViewController: UIViewController {
    
    var timer = Timer()
    var time = 210
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @objc func decreaseTimer() {
        if (time>0){
            time -= 1
            timerLabel.text = "\(time)"
        }
        else{
            timer.invalidate()
            print("timer stopped")
            timerLabel.text = "Eggs ready asshole"
        }
    }
    
    @IBAction func pausePressed(_ sender: Any) {
        timer.invalidate()
        print("timer stopped")
    }
    
    @IBAction func playPressed(_ sender: Any) {
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.decreaseTimer), userInfo: nil, repeats: true)
        print("timer started")
        
    }
    
    @IBAction func plusTen(_ sender: Any) {
        time += 10
        timerLabel.text = "\(time)"
    }
    
    @IBAction func minusTen(_ sender: Any) {
        if(time > 10){
            time -= 10
            timerLabel.text = "\(time)"
        }
    }
    
    @IBAction func resetTimer(_ sender: Any) {
        time = 210
        timerLabel.text = "\(time)"
    }
    
    @objc func processTimer() {
        print("A second has passed!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
    }


}

