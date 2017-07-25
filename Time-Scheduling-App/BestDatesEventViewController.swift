//
//  BestDatesEventViewController.swift
//  Time-Scheduling-App
//
//  Created by Kristie Huang on 7/17/17.
//  Copyright © 2017 Kristie Huang. All rights reserved.
//

import Foundation
import UIKit

class BestDatesEventViewController: UIViewController, UITableViewDataSource {
    
    
    @IBOutlet weak var bestDatesLabel: UILabel!
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
                //key: num
                //date: num
            }
            
        }
        
        var i = 1
        var maxVal = sortedNumber.sorted()[sortedNumber.count - 1]
        print(maxVal)
        
        //go through counts key one by one
        while i <= maxVal {
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
                    i += 1
                    print(i)
                }


            }
        }
        print("THIS IS NEW ORDERED DICT \(bestDatesEventViewController.newOrderedDict)")
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        BestDatesEventViewController.countDates()
        return(BestDatesEventViewController.rows.count)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print(BestDatesEventViewController.sectionNames.count)
        return(BestDatesEventViewController.sectionNames.count)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection sectionIndex: Int) -> String? {
        BestDatesEventViewController.countDates()
        
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
        
        cell.bestDatesLabel.text = "hello"
        
    }
    
    
}
//
//extension BestDatesEventViewController: UITableViewDataSource {
//
////    let sections = number of keys in CountDates()
//    //section = value, row = dates/key
//    //dispatch group
//
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return(BestDatesEventViewController.sections.count)
//        print(BestDatesEventViewController.sections.count)
//    }
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
////        return BestDatesEventViewController.sections[section]
//        return BestDatesEventViewController.sections[section]
//
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
//        if cell == nil {
//            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
//        }
////        cell?.textLabel?.text = data[indexPath.section]
//        return cell!
//    }
//
//}
