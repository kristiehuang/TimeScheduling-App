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

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let eventViewController = segue.destination as? EventViewController {
//            let newOrderedDict = eventViewController.newOrderedDict
//            print(newOrderedDict)
//            orderedDict = newOrderedDict as! [Date : Int]
//        }
//
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        var dates: [String] = []
        var displayDates = ""
        for (date, int) in orderedDict {
            let dateString = getDateString(date: date)
//            dates.append(dateString)
//            print(dates)
            displayDates += "\(dateString)"
        }
        bestDatesLabel.text = "\(displayDates))"
        eventNameLabel.text = "Event: \(String(describing: EventViewController.event?.name))"
        invitedAsLabel.text = "Invited as: \(User.current.name)"
    }

    func getDateString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: date)
    }
    
}
