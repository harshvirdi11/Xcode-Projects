//
//  ViewController.swift
//  Whats the Weather
//
//  Created by Harsh Virdi on 19/01/26.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var result: UILabel!
    
    @IBAction func getWeather(_ sender: Any) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let url = URL(string: "https://www.accuweather.com/en/in/asansol/191570/weather-today/191570") {
            
            let request = URLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                if error != nil {
                    print(error!)
                }
                
                else {
                    if let unwrappedData = data {
                        let dataString = String(data: unwrappedData, encoding: .utf8) ?? "No data"
                        print(dataString)
                    }
                }
                
            }
            
            task.resume()
        
        }
        
    }
    
    
}



