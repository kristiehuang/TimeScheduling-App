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
    @IBOutlet weak var eventNameLabel: UILabel!
    
    @IBOutlet weak var invitedAsLabel: UILabel!
    
    
    @IBAction func backButton1(_ sender: Any) {
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {        
    }
    
    var orderedDict: [Date: Int] = [:]


    override func viewDidLoad() {
        super.viewDidLoad()
        
        var dates: [Date] = []
        for (date, int) in orderedDict {
            dates.append(date)
        }
        bestDatesLabel.text = "\(String(describing: dates))"
        eventNameLabel.text = "\(String(describing: EventViewController.event?.name ?? "Untitled Event"))"
        invitedAsLabel.text = "Invited as: \(User.current.name)"
    }


    
}
