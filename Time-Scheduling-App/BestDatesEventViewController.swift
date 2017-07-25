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
    
    @IBOutlet weak var invitedAsLabel: UILabel!
    
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
        //SORTING INCORRECTLY BUT SECTIONNAME APPENDING IS WORKING
        var i = 1
        var maxVal = sortedNumber.sorted()[sortedNumber.count - 1]
        print(maxVal)
        
        //go through counts key one by one
        /*while i <= maxVal {
            for (key, num) in bestDatesEventViewController.newOrderedDict {
                print(key)
                print(num)
                
                while (num as! Int != i){
                    i += 1
                }
 
                if (num as! Int == i) {
                    BestDatesEventViewController.sectionNames.append("\(num) people")
                        //                BestDatesEventViewController.sectionNames" value".append("\(key)")
                    //append key to new/existing section "value"
                }


            }
        }*/
        
        print(bestDatesEventViewController.newOrderedDict)
        
        
        var sortedDict: [Int: [Any]] = [:]
        var keysArray: [Int] = []
        
        for (date, num) in bestDatesEventViewController.newOrderedDict {
            print(num)
            let typeNum = num as! Int

            if !(keysArray.contains(typeNum)) {
                //if typeNum section doesn't exist already, create new section & insert date row
                keysArray.append(typeNum)
//                var datesArr = sortedDict[typeNum]
//                datesArr!.append(typeKey)
                
                
                BestDatesEventViewController.sectionNames.append("\(num) people")
                //                BestDatesEventViewController.sectionNames" value".append("\(key)")

            }
            else {
                //if typeNum section already exists, then just insert date row in section
                
                
//                var datesArr = sortedDict[typeNum]
//                datesArr!.append(typeKey)
                
                //                BestDatesEventViewController.sectionNames" value".append("\(key)")
                
            }
            //1: [july 1, july4, july5]
            //3: [july 5]
            


            

            
        }
        print("THIS IS NEW ORDERED DICT \(bestDatesEventViewController.newOrderedDict)")
        
    }
    
}

extension BestDatesEventViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        BestDatesEventViewController.countDates()
        //        return(BestDatesEventViewController.rows.count)
        return 2
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print(BestDatesEventViewController.sectionNames.count)
                return(BestDatesEventViewController.sectionNames.count)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection sectionIndex: Int) -> String? {
        //        BestDatesEventViewController.countDates()
        
        return BestDatesEventViewController.sectionNames[sectionIndex]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "BestDatesCell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "BestDatesCell")
        }
        //        cell?.textLabel?.text = data[indexPath.section]
        return cell!
    }
    
    func configure(cell: BestDatesCell, atIndexPath indexPath: IndexPath) {
        
        cell.dateLabel.text = "hello"
        
    }
}

extension BestDatesEventViewController: UITableViewDelegate {
    
}
