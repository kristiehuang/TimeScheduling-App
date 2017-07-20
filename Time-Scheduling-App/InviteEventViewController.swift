//
//  finalEventViewController.swift
//  Time-Scheduling-App
//
//  Created by Kristie Huang on 7/17/17.
//  Copyright © 2017 Kristie Huang. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase


class InviteEventViewController: UIViewController {
    
    var event: Event?
    var invitees: [String]?
    
    @IBOutlet weak var eventNameLabel: UILabel!
    
    //add contacts output
    
    @IBOutlet weak var inviteesTableView: UITableView!
    
    @IBAction func unwindToInvite(_ segue: UIStoryboardSegue) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let inviteFriendsViewController = segue.destination as? InviteFriendsViewController {
            invitees = inviteFriendsViewController.invitees
            inviteFriendsViewController.event = event
            print(inviteFriendsViewController.event)
            print(event)
        }
        if let addNoteViewController = segue.destination as? AddNoteViewController {
            
        }
    }
    
    
    @IBAction func sendInvitesButtonTapped(_ sender: Any) {
        sendInvites()
    }
    
    @IBAction func saveCloseButton(_ sender: Any) {
        print("transitioning back to home/save")
        //save invites & segue
    }
    
    
    @IBAction func touchCancelTriggered(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let event = event {
            eventNameLabel.text = event.name
            //add contacts output
        }
        
        // remove separators for empty cells
        inviteesTableView.tableFooterView = UIView()
        inviteesTableView.rowHeight = 71
        
        //dismiss keyboard
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    
    
    
    func sendInvites() {
        //
        
    }
    
    
    
    
}
