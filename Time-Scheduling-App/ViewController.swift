//
//  ViewController.swift
//  Time-Scheduling-App
//
//  Created by Kristie Huang on 7/5/17.
//  Copyright © 2017 Kristie Huang. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController {
    //main page

    @IBAction func newButtonTapped(_ sender: Any) {
        print("new button tapped")
        //reset event to new
    }
    
    @IBAction func unwindToHome(_ segue: UIStoryboardSegue) {
        
    }
    
    @IBOutlet weak var tableView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //dismiss keyboard
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "showTableSegue" {
                print("showing container view tablezzz")

            }
            else if identifier == "showNewEvent" {
                print("+ button tapped")
                let newEvent = Event(host: User.current.uid, name: "", invitees: [User.current.uid : true], creationDate: Date(), dates: [], note: "")
                EventViewController.event = newEvent
                
                
                }
        }
    }

    
}
