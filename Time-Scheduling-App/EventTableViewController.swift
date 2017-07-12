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
    
    //var events: [Event] = []
    var events = [Event]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {

        //1. need array to display on table
        
        //2. table reload
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventTableViewCell", for: indexPath) as! EventTableViewCell
        let row = indexPath.row
        let event = self.events[row]
        cell.eventNameLabel.text = event.name
//creation date + host
        return cell

    }
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let identifier = segue.identifier {
//            if identifier == "showNewEvent" {
//                print("Table view cell tapped")
//
//                let indexPath = tableView.indexPathForSelectedRow!
//                let eventTapped = events[indexPath.row]
//                let eventViewController = segue.destination as! EventViewController
//                print(eventTapped.name)
//
//            }
//
//        }
//    }
}
