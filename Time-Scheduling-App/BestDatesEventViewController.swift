//
//  BestDatesEventViewController.swift
//  Time-Scheduling-App
//
//  Created by Kristie Huang on 7/17/17.
//  Copyright © 2017 Kristie Huang. All rights reserved.
//

import Foundation
import UIKit

class BestDatesEventViewController: UIViewController {

    
    @IBOutlet weak var bestDatesLabel: UILabel!
    
    @IBAction func backButton1(_ sender: Any) {
    }
    var orderedDict: [Date: Int] = [:]


    override func viewDidLoad() {
        super.viewDidLoad()
        
        bestDatesLabel.text = "\(String(describing: orderedDict))"
    }
//    
//    func formatDict() {
//        for (date, int) in orderedDict {
//            
//        }
//    }
    
    
}
