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
        
        //        let videoView = UIView(frame: CGRect(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.width, self.view.bounds.height))
        
        let path = Bundle.main.path(forResource: "tutorial2", ofType: "mp4")
        let pathURL = URL(fileURLWithPath: path!)
        let player = AVPlayer(url: pathURL)
        
        //        let playerLayer = AVPlayerLayer(player: player)
        //        playerLayer.frame = view.bounds
        //        self.view.layer.addSublayer(playerLayer)
        //        player.play()
        
        let playerController = AVPlayerViewController()
        
        playerController.player = player
        self.addChildViewController(playerController)
        self.view.addSubview(playerController.view)
        playerController.view.frame = self.view.frame
        
        player.play()
        
        //
        
        
        //
        //        player.accessibilityFrame = videoView.bounds
        //        player.play()
        //        //            player.scalingMode = .aspectFill
        //        let playerLayer = AVPlayerLayer(player: player)
        //        videoView.layer.addSublayer(playerLayer)
        //
        //        
        //        self.view.addSubview(videoView)
        
        
        
    }
    
}
