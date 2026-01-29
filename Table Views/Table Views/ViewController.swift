//
//  ViewController.swift
//  Table Views
//
//  Created by Harsh Virdi on 15/01/26.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var table: UITableView!

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return 50
        
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = String(Int((slider.value * 20)) * (indexPath.row + 1))
        
        return cell
        
    }
    
    
    @IBAction func sliderChanged(_ sender: Any) {
        print(slider.value)
        table.reloadData()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

