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
    
    var displayedEvents = [Event]()
    let refreshCont = UIRefreshControl()
    
    let dispatchGroup = DispatchGroup()
    

    
    override func viewDidLoad() {
        reloadTimeline()

        refreshCont.addTarget(self, action: #selector(reloadTimeline), for: .valueChanged)
        tableView.addSubview(refreshCont)
        
        super.viewDidLoad()
    }
    
    var creationDates = [String]()
    
    var sortedDisplayedEvents = [Event]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    func reloadTimeline() {
        creationDates = []
        sortedDisplayedEvents = []
        
        dispatchGroup.enter()
        dispatchGroup.enter()
        
        UserService.events(for: User.current) { (events) in
            self.displayedEvents = events
            self.dispatchGroup.leave()
        }
        
        UserService.readInvitedEvents(for: User.current) { (invitedEvents) in
            
            for invitedEvent in invitedEvents {
                self.displayedEvents.append(invitedEvent)
            }
            self.dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) {
            self.reorderTable()
            
            if self.refreshCont.isRefreshing {
                self.refreshCont.endRefreshing()
            }
            
        }
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        reloadTimeline()
        super.viewWillAppear(true)
    }

    
    func reorderTable() {
        
        
        for event in self.displayedEvents {
            self.creationDates.append("\(event.creationDate)")
        }
        
        self.creationDates = self.creationDates.sorted().reversed()
        for date in self.creationDates {
            for event in self.displayedEvents {
                if "\(event.creationDate)" == date {
                    self.sortedDisplayedEvents.append(event)
                }
            }
        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventTableViewCell", for: indexPath) as! EventTableViewCell
        let row = indexPath.row
        let event = self.sortedDisplayedEvents[row]
        
        cell.eventNameLabel.text = event.name
        
        if User.current.uid == event.host {
            cell.eventDetailsLabel.text = "Hosting | \((event.invitees?.count ?? 0) + (event.emailInvitees?.count ?? 0)) invitees"
            cell.hostInviteIndicator.text = "H"

        }
        else {
            cell.eventDetailsLabel.text = "Invited | \((event.invitees?.count ?? 0) + (event.emailInvitees?.count ?? 0)) invitees"
            cell.hostInviteIndicator.text = "I"

        }
        //host + number of invites + date (if finalized then date, else if not finalized then "Date pending"
        
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedDisplayedEvents.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow!
        let event = sortedDisplayedEvents[indexPath.row]
        EventViewController.event = event
        BestDatesEventViewController.thisEvent = event
        
        self.performSegue(withIdentifier: "showEventResults", sender: nil)

    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if User.current.uid == sortedDisplayedEvents[indexPath.row].host {
            if editingStyle == .delete {
                let alertController = UIAlertController(title: "Are you sure?", message: "This will delete the event permanently & uninvite all invitees.", preferredStyle: .alert)

                let delete = UIAlertAction(title: "Delete", style: .default) { _ in
                    let event = self.sortedDisplayedEvents[indexPath.row]
                    
                    for invitee in event.invitees! {
                        let inviteeRef = Database.database().reference().child("users").child(invitee.key).child("invited events").child(event.key!)
                        inviteeRef.removeValue()
                        print("\(invitee.key) uninvited")
                    }
                    
                    let eventRef = Database.database().reference().child("events").child(User.current.uid).child(event.key!)
                    eventRef.removeValue()
                    
                    
                    let hostRef = Database.database().reference().child("users").child(User.current.uid).child("hosting events").child(event.key!)
                    hostRef.removeValue()
                    
                    self.sortedDisplayedEvents.remove(at: indexPath.row)
                    
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
                    
                    
                    let event = self.sortedDisplayedEvents[indexPath.row]

                    for invitee in (event.invitees!) {
                        let inviteeRef = Database.database().reference().child("users").child(invitee.key).child("invited events").child((event.key!))
                        inviteeRef.removeValue()
                        print("\(invitee.key) uninvited")
                        
                        
                        let eventRef = Database.database().reference().child("events").child(event.host).child(event.key!).child("invitees").child(invitee.key)
                        eventRef.removeValue()
                        
                    }
                    
                    self.sortedDisplayedEvents.remove(at: indexPath.row)
                    
                    
                    

                }
                alertController.addAction(delete)
                
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(cancel)
                
                present(alertController, animated: true)
                
            }
        }
        

    }
}
