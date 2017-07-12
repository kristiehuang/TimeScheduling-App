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
    
    var events = [Event]() //{
//        didSet {
//            tableView.reloadData()
//        }
//    }

    override func viewDidLoad() {
        super.viewDidLoad()

        print("events enumergeated : \(events.enumerated())")
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
//creation date + host
        return cell

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //events.count = 0 for now since creating new array
        return events.count
    }
    

}
