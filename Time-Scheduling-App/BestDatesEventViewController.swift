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
    var orderedDict: [Date: Int] = [:]
    static var thisEvent : Event?
    var select = false
    var finalInvite = false

    
    var bestDate: String = ""
    
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var respondantsLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func unwindToBestDates(_ segue: UIStoryboardSegue) {
    }
    
    @IBAction func backButton1(_ sender: Any) {
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        if User.current.uid == BestDatesEventViewController.thisEvent?.host {
            //                        print("is host")
            self.performSegue(withIdentifier: "editEvent", sender: nil)
            
        }
        else {
            self.performSegue(withIdentifier: "editResponse", sender: nil)
            //                        print("is not host")
        }
    }
    
    
    @IBOutlet weak var sendInvitesButton: UIButton!
    
    @IBAction func sendInvitesButtonTapped(_ sender: Any) {
        SendEmailViewController.bestDate = bestDate
        SendEmailViewController.finalInvite = finalInvite
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let invite = UIAlertAction(title: "Ask for input", style: .default) { (_) in
            self.finalInvite = false
            self.performSegue(withIdentifier: "toEmail", sender: nil)
        }
        alertController.addAction(invite)
        
        let final = UIAlertAction(title: "Send final invitation", style: .default) { (_) in
            self.finalInvite = true
            self.performSegue(withIdentifier: "toEmail", sender: nil)
            
        }
        alertController.addAction(final)
        

        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancel)
        
        present(alertController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if User.current.uid == BestDatesEventViewController.thisEvent?.host {
            sendInvitesButton.isHidden = false //not hidden
        }
        else {
            sendInvitesButton.isHidden = true
        }
        
        if let event = EventViewController.event {
            
            BestDatesEventViewController.thisEvent = event
            BestDatesEventViewController.countDates()
            getBestDate()
            //            var displayDates = ""
            //            for (date, _) in orderedDict {
            //                let dateString = getDateString(date: date)
            //                displayDates += "\(dateString)"
            //            }
            
            eventNameLabel.text = "\(event.name ?? "Untitled Event")"
            noteLabel.text = "Host:  \(event.note)"
            respondantsLabel.text = "\((event.invitees?.count ?? 0) + (event.emailInvitees?.count ?? 0)) invitees"
            
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        if let eventViewController = segue.destination as? EventViewController {
        //            let newOrderedDict = eventViewController.newOrderedDict
        //            print(newOrderedDict)
        //            print(orderedDict)
        //            orderedDict = newOrderedDict as! [Date : Int]
        //        }
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
    
    
    static var sortedDict: [Int: [Any]] = [:]
    
    static func countDates() {
        
        var counts: [String: Int] = [:]
        var sortedNumber: [Int] = []
        let newOrderedDict = NSMutableDictionary()
        
        for date in (BestDatesEventViewController.thisEvent?.dates)! {
            counts[date] = (counts[date] ?? 0) + 1
            counts.updateValue(counts[date]!, forKey: date)
            //int + 1 for every date
            
        }
        //sort array by count value, then display only top three
        //print(counts)  // "[BAR: 1, FOOBAR: 1, FOO: 2]"
        
        for (key, value) in counts {
            print("\(value) of people prefer the \(key) date")
            sortedNumber.append(value)
            //offset
            
            for var num in sortedNumber.sorted() {
                
                num = value
                
                newOrderedDict.setValue(num, forKey: key)
                
            }
        }
        
        //print(bestDatesEventViewController.newOrderedDict)
        
        
        var keysArray: [Int] = []
        sortedDict = [:]
        BestDatesEventViewController.sectionNames = []
        
        for (date, num) in newOrderedDict {
            let typeNum = num as! Int
            
            if !(keysArray.contains(typeNum)) {
                //if typeNum section doesn't exist already, create new section & insert date row
                keysArray.append(typeNum)
                
                var datesArr: [Any] = []
                //
                //                let dateFormatter = DateFormatter()
                //                dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
                //                dateFormatter.timeZone = Calendar.current.timeZone //Current time zone
                //                let formatDate = dateFormatter.string(from: date)
                
                
                datesArr.append(date)
                sortedDict.updateValue(datesArr, forKey: typeNum)
                
                BestDatesEventViewController.sectionNames.append("\(num) people")
            }
            else {
                //if typeNum section already exists, then just insert date row in section
                var newDates = Array(sortedDict[typeNum]!)
                
                //                let dateFormatter = DateFormatter()
                //                dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
                //                dateFormatter.timeZone = Calendar.current.timeZone //Current time zone
                //                let formatDate = dateFormatter.date(from: "\(date)")
                
                
                newDates.append(date)
                sortedDict.updateValue(newDates, forKey: typeNum)
                
                
            }
            //sorted dict
            //1: [july 1, july4, july5]
            //3: [july 5]
            
        }
        
    }
    
    func getBestDate() {
            let firstKey = BestDatesEventViewController.sortedDict.keys.first
            bestDate = BestDatesEventViewController.sortedDict[firstKey!]?.first as! String
    }
    
}

extension BestDatesEventViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var sectionString: Int = 1
        if section < BestDatesEventViewController.sortedDict.keys.count {
            sectionString = Array(BestDatesEventViewController.sortedDict.keys.sorted().reversed())[section]
            
        }
        else {
            print("failed")
        }
        
        return BestDatesEventViewController.sortedDict[sectionString]!.count
        
        //        let dates = BestDatesEventViewController.sortedDict.valueKeySorted[section].1
        //
        //        return dates.count
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print(BestDatesEventViewController.sectionNames.count)
        return(BestDatesEventViewController.sectionNames.count)
    }
    
    func reverseDictionary(array: [Int]) -> [Int] {
        var newArray: [Int] = []
        var size = (array.count - 1)
        while size >= 0 {
            for _ in array {
                newArray.append(array[size])
                size -= 1
            }
        }
        return newArray
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection sectionIndex: Int) -> String? {
        
        let reverseSectionNames = reverseDictionary(array: BestDatesEventViewController.sortedDict.keys.sorted())
        return ("\(reverseSectionNames[sectionIndex]) people")
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "bestDatesCell", for: indexPath) as! BestDatesCell
        cell.star.isHidden = true
        
        
        
        let datesInSect = BestDatesEventViewController.sortedDict.valueKeySorted[indexPath.section].1
        
        if indexPath.section < BestDatesEventViewController.sortedDict.keys.count && indexPath.row < (datesInSect.count) {
            
            cell.star.isHidden = true
            cell.dateLabel.text = datesInSect[indexPath.row] as? String
            
            if bestDate == datesInSect[indexPath.row] as? String {
//                select = true
                cell.star.isHidden = false
                cell.dateLabel.text = datesInSect[indexPath.row] as? String
                print("best date selected")
                //save to database

            }

            
        } else {
            print("index out of range")
        }
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if User.current.uid == BestDatesEventViewController.thisEvent?.host {
            let datesInSect = BestDatesEventViewController.sortedDict.valueKeySorted[indexPath.section].1
            
            if indexPath.section < BestDatesEventViewController.sortedDict.keys.count && indexPath.row < (datesInSect.count) {
                
                bestDate = (datesInSect[indexPath.row] as? String)!
                tableView.reloadData()
                
            } else {
                print("index out of range")
            }
            
            
        }
    }
    
    
    
}

extension BestDatesEventViewController: UITableViewDelegate {
    
}
