//
//  ViewController.swift
//  Permanent Data Storage
//
//  Created by Harsh Virdi on 16/01/26.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var numberField: UITextField!
    
    @IBAction func save(_ sender: Any) {
        
        UserDefaults.standard.set(numberField.text, forKey: "number")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        
        let numberObject = UserDefaults.standard.string(forKey: "number")
        
        if let number = numberObject as? String{
            
            numberField.text = number
        }
        
        }
    }




