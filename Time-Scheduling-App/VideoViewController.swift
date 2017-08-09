//
//  TutorialViewController.swift
//  Time-Scheduling-App
//
//  Created by Kristie Huang on 8/2/17.
//  Copyright © 2017 Kristie Huang. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer
import AVKit
import AVFoundation

class VideoViewController: UIViewController {
    
    var moviePlayer: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playVideo()
    }
    
    func playVideo() {

        let path = Bundle.main.path(forResource: "tutorial2", ofType: "mp4")
        let pathURL = URL(fileURLWithPath: path!)
        let player = AVPlayer(url: pathURL)
        let playerController = AVPlayerViewController()
        
        playerController.player = player
        self.addChildViewController(playerController)
        self.view.addSubview(playerController.view)
        playerController.view.frame = self.view.frame
        
        player.play()
        

        
    }
    
}
