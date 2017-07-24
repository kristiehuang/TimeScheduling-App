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
    
    @IBAction func unwindToBestDatesEventViewController(_ segue: UIStoryboardSegue) {
    }
    
    @IBAction func backButton1(_ sender: Any) {
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
    }
    
    
    var orderedDict: [Date: Int] = [:]
    var thisEvent : Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let event = EventViewController.event {
            
            thisEvent = event
            
            // var dates: [String] = []
            var displayDates = ""
            for (date, _) in orderedDict {
                let dateString = getDateString(date: date)
                //            dates.append(dateString)
                //            print(dates)
                displayDates += "\(dateString)"
            }
            bestDatesLabel.text = "\(displayDates))"
            eventNameLabel.text = "\(event.name ?? "Untitled Event")"
            invitedAsLabel.text = "Invited as: \(User.current.name)"
            
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let eventViewController = segue.destination as? EventViewController {
            let newOrderedDict = eventViewController.newOrderedDict
            print(newOrderedDict)
            orderedDict = newOrderedDict as! [Date : Int]
        }
        if let identifier = segue.identifier {
            if identifier == "editResponse" {
                EditResponseViewController.event = thisEvent
                
            }
        }
        
    }
    
    func getDateString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: date)
    }
    
    func countDates() {
        var counts: [Date: Int] = [:]
        var array: [Int] = []
        for date in EditResponseViewController.datesChosen {
            counts[date] = (counts[date] ?? 0) + 1
        }
        //sort array by count value, then display only top three
        print(counts)  // "[BAR: 1, FOOBAR: 1, FOO: 2]"
        
        for (key, value) in counts {
            print("\(value) of people prefer the \(key) date")
            array.append(value)
            //value is int
            
            for var item in array.sorted() {
                let editResponseViewController = EditResponseViewController()
                item = value
                editResponseViewController.newOrderedDict[key] = item
                print("THIS IS NEW ORDERED DICT \(editResponseViewController.newOrderedDict)")
            }
        }
        
    }
    
}
