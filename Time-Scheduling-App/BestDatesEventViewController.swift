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
    
    @IBOutlet weak var eventNameLabel: UILabel!
    

    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var respondantsLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func unwindToBestDates(_ segue: UIStoryboardSegue) {
    }
    
    @IBAction func backButton1(_ sender: Any) {
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
    }
    
    
    var orderedDict: [Date: Int] = [:]
    static var thisEvent : Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let event = EventViewController.event {
            
            BestDatesEventViewController.thisEvent = event
            BestDatesEventViewController.countDates()
            // var dates: [String] = []
            var displayDates = ""
            for (date, _) in orderedDict {
                let dateString = getDateString(date: date)
                //            dates.append(dateString)
                //            print(dates)
                displayDates += "\(dateString)"
            }
            
            eventNameLabel.text = "\(event.name ?? "Untitled Event")"
            noteLabel.text = "Host:  \(event.note)"
            respondantsLabel.text = "number/\(event.invitees.count) respondants"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let eventViewController = segue.destination as? EventViewController {
            let newOrderedDict = eventViewController.newOrderedDict
            print(newOrderedDict)
            orderedDict = newOrderedDict as! [Date : Int]
        }
        if let identifier = segue.identifier {
            if identifier == "editResponse" {
                EditResponseViewController.event = BestDatesEventViewController.thisEvent
                
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
    
    static var sectionNames: [String] = []
    static var rows: [String] = []
    
    var newOrderedDict = NSMutableDictionary()
    
    static var sortedDict: [Int: [Any]] = [:]
    
    static func countDates() {
        
        var counts: [String: Int] = [:]
        var sortedNumber: [Int] = []
        
        
        for date in (BestDatesEventViewController.thisEvent?.dates)! {
            counts[date] = (counts[date] ?? 0) + 1
            counts.updateValue(counts[date]!, forKey: date)
            //int + 1 for every date
            
        }
        //sort array by count value, then display only top three
        print(counts)  // "[BAR: 1, FOOBAR: 1, FOO: 2]"
        let bestDatesEventViewController = BestDatesEventViewController()
        
        for (key, value) in counts {
            print("\(value) of people prefer the \(key) date")
            sortedNumber.append(value)
            //offset
            
            for var num in sortedNumber.sorted() {
                
                num = value
                
                bestDatesEventViewController.newOrderedDict.setValue(num, forKey: key)
            }
            
        }
        
        print(bestDatesEventViewController.newOrderedDict)
        
        
        var keysArray: [Int] = []

        for (date, num) in bestDatesEventViewController.newOrderedDict {
            print(num)
            let typeNum = num as! Int
            
            if !(keysArray.contains(typeNum)) {
                //if typeNum section doesn't exist already, create new section & insert date row
                keysArray.append(typeNum)
                var datesArr: [Any] = []
                sortedDict.updateValue(datesArr, forKey: typeNum)
                print(date)
                datesArr.append(date)
                
                
                BestDatesEventViewController.sectionNames.append("\(num) people")
                //                BestDatesEventViewController.sectionNames" value".append("\(key)")
                
            }
            else {
                //if typeNum section already exists, then just insert date row in section
                print(date)
                var newDates = Array(sortedDict[typeNum]!)
                newDates.append(date)
                sortedDict.updateValue(newDates, forKey: typeNum)

                
            }
            //sorted dict
            //1: [july 1, july4, july5]
            //3: [july 5]

        }
        print("THIS IS NEW ORDERED DICT \(bestDatesEventViewController.newOrderedDict)")
        
    }
    
}

extension BestDatesEventViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionString = Array(BestDatesEventViewController.sortedDict.keys.sorted().reversed())[section]
        return BestDatesEventViewController.sortedDict[sectionString]!.count + 1
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print(BestDatesEventViewController.sectionNames.count)
        return(BestDatesEventViewController.sectionNames.count)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection sectionIndex: Int) -> String? {
        return BestDatesEventViewController.sectionNames.reversed()[sectionIndex]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BestDatesCell")
        cell?.textLabel?.text = "date"
//                cell?.textLabel?.text = BestDatesEventViewController.sortedDict[indexPath.section]
        return cell!
    }
    

}

extension BestDatesEventViewController: UITableViewDelegate {
    
}
