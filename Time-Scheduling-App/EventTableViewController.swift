//
//  EventTableViewController.swift
//  Time-Scheduling-App
//
//  Created by Kristie Huang on 7/11/17.
//  Copyright © 2017 Kristie Huang. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class EventTableViewController: UITableViewController {
    
    @IBOutlet var uiTableView: UITableView!
    
    
    
    
    var displayedEvents = [Event]() {
        
        didSet {
            tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        UserService.events(for: User.current) { (events) in
            self.displayedEvents = events
            self.tableView.reloadData()
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //my events
        UserService.events(for: User.current) { (events) in
            self.displayedEvents = events
            self.tableView.reloadData()
        }
        //invited events
        UserService.readInvitedEvents(for: User.current) { (invitedEvents) in
            
            for invitedEvent in invitedEvents {
                self.displayedEvents.append(invitedEvent)
            }
        }
        
        //displayed Events already contains user's data right
        
        //        for event in events {
        //            if User.current = event.host {
        //                displayedEvents = event
        //                //displayedEvents.append(event)
        //                //where in code does it append to displayed Events??
        //            }
        //            else if User.current != host {
        //                if event.invitees.contains(user.current) {
        //                    displayedEvents = event.invit
        //                }
        //                else {
        //                    displayedEvents ($0 filter: event)
        //                }
        //            }
        //        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventTableViewCell", for: indexPath) as! EventTableViewCell
        let row = indexPath.row
        let event = self.displayedEvents[row]
        cell.eventNameLabel.text = event.name
        cell.eventDetailsLabel.text = "Host | 14 Invites | Date Chosen"
        //host + number of invites + date (if finalized then date, else if not finalized then "Date pending"
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedEvents.count
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            
            if identifier == "showEventResults" {
                print("Table view cell tapped")
                
                let indexPath = tableView.indexPathForSelectedRow!
                let event = displayedEvents[indexPath.row]
                EventViewController.event = event
                
                //                if let bestDatesEventViewController = segue.destination as? BestDatesEventViewController {
                //                    EventViewController.countDates()
                //                    print(newOrderedDict)
                //                    bestDatesEventViewController.orderedDict = newOrderedDict as! [Date : Int]
                //                }
            }
            
            
        }
    }
}
