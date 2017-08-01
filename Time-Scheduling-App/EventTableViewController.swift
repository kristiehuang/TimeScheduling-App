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
        
        if User.current.uid == event.host {
            cell.eventDetailsLabel.text = "\(User.current.name) | \(event.invitees.count + event.emailInvitees.count) invitees | Hosting"
        }
        else {
            cell.eventDetailsLabel.text = "Invited | \(event.invitees.count + event.emailInvitees.count) invitees"
        }
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
        BestDatesEventViewController.thisEvent = event
        
        
        //                        print("is host")
        self.performSegue(withIdentifier: "showEventResults", sender: nil)
        //        }
        //        else {
        //            self.performSegue(withIdentifier: "showEventResults", sender: nil)
        //            //                        print("is not host")
        //        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if User.current.uid == displayedEvents[indexPath.row].host {
            if editingStyle == .delete {
                let alertController = UIAlertController(title: "Are you sure?", message: "This will delete the event permanently & uninvite all invitees.", preferredStyle: .alert)

                let delete = UIAlertAction(title: "Delete", style: .default) { _ in
                    let event = self.displayedEvents[indexPath.row]
                    
                    for invitee in event.invitees {
                        let inviteeRef = Database.database().reference().child("users").child(invitee.key).child("invited events").child(event.key!)
                        inviteeRef.removeValue()
                        print("\(invitee.key) uninvited")
                    }
                    
                    let eventRef = Database.database().reference().child("events").child(User.current.uid).child(event.key!)
                    eventRef.removeValue()
                    
                    
                    let hostRef = Database.database().reference().child("users").child(User.current.uid).child("hosting events").child(event.key!)
                    hostRef.removeValue()
                    
                    self.displayedEvents.remove(at: indexPath.row)
                    
                }
                alertController.addAction(delete)
                
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(cancel)
                
                present(alertController, animated: true)
                
            }
        }
        else { //if user is invitee
            if editingStyle == .delete {
                let alertController = UIAlertController(title: "Are you sure?", message: "You will no longer be able to access this event.", preferredStyle: .alert)
                
                let delete = UIAlertAction(title: "Delete", style: .default) { _ in
                                        //remove user from event invitees, remove user entries to dates
                    
                    self.displayedEvents.remove(at: indexPath.row)
                    
                    
                    

                }
                alertController.addAction(delete)
                
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(cancel)
                
                present(alertController, animated: true)
                
            }
        }
        
        //
        //        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        //
        //        let delete = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        //        alertController.addAction(delete)
        //
        //
        //
        //        present(alertController, animated: true)
    }
}
