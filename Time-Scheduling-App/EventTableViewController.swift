//
//  EventTableViewController.swift
//  Time-Scheduling-App
//
//  Created by Kristie Huang on 7/11/17.
//  Copyright © 2017 Kristie Huang. All rights reserved.
//

import Foundation
import UIKit

class EventTableViewController: UITableViewController {
    
    @IBOutlet var uiTableView: UITableView!
    
    var events = [Event]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print("events enumergeated : \(events.enumerated())")
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        UserService.events(for: User.current) { (events) in
            self.events = events
            self.tableView.reloadData()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventTableViewCell", for: indexPath) as! EventTableViewCell
        let row = indexPath.row
        let event = self.events[row]
        cell.eventNameLabel.text = event.name
        cell.eventDetailsLabel.text = "Host | \(String(describing: event.creationDate)) | 14 Invites | Finalized"
        //creation date.convertToString() + host
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "showEvent" {
                print("Table view cell tapped")
                
                let indexPath = tableView.indexPathForSelectedRow!
                let event = events[indexPath.row]
//                let eventViewController = segue.destination as! EventViewController
                EventViewController.event = event
            }
        }
        
    }
}
