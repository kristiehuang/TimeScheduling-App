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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
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
        
        super.viewWillAppear(animated)
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
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow!
        let event = displayedEvents[indexPath.row]
        EventViewController.event = event
        
        
        
        if User.current.uid == event.host {
            //                        print("is host")
            self.performSegue(withIdentifier: "editEvent", sender: nil)
        }
        else {
            self.performSegue(withIdentifier: "showEventResults", sender: nil)
            //                        print("is not host")
        }
    }
}
