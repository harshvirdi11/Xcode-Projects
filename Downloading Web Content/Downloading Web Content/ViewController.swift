//
//  ViewController.swift
//  Downloading Web Content
//
//  Created by Harsh Virdi on 19/01/26.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    @IBOutlet weak var webview: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        /*
        let url = URL(string: "https://www.apple.com")!
        let request = URLRequest(url: url)
        webview.load(request)
        */
        
        if let url = URL(string: "https://stackoverflow.com"){
            
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request)
            { (data, response, error) in
                if error != nil{
                    print(error!)
                }
                else {
                    if let unwrappedData = data, let dataString = String(data: unwrappedData, encoding: .utf8){
                        print(dataString)
                    }
                    else {
                        print("No data")
                        DispatchQueue.main.async {
                            //UI update
                        }
                    }
                }
                
            }
            task.resume()
            
        }
        
        print("hello main thread")
    }


}

