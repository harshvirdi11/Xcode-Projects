//
//  ViewController.swift
//  video_player
//
//  Created by Harsh Virdi on 06/01/26.
//

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playVideo()
    }
    
    private func playVideo() {
        guard let path = Bundle.main.path(forResource: "test", ofType: "mp4")
        
        else
        {
            debugPrint("test.mp4 not found")
            return
        }
        let player = AVPlayer(url:
            URL(fileURLWithPath: path))
        let playerViewController =
            AVPlayerViewController()
        playerViewController.player = player
        present(playerViewController, animated: true) {
            player.play()
        }
        
    }
 
}



