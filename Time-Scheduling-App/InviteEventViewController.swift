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
    
    static var event: Event?
    var invitees: [String]?
    
    @IBOutlet weak var eventNameLabel: UILabel!
    
    //add contacts output
    
    @IBOutlet weak var inviteesTableView: UITableView!
    
    @IBAction func unwindToInvite(_ segue: UIStoryboardSegue) {
    }
    
    func saveEvent(){
        //if event already exists, SAVE to existing
        
        let eventTableViewController = EventTableViewController()

        UserService.events(for: User.current, completion: { (events:[Event]) in
            
            for eventz in events {
                if EventViewController.event?.key == eventz.key {
                    let eventRef = Database.database().reference().child("events").child(User.current.uid).child((EventViewController.event?.key!)!)
                    
                    eventRef.child("invitees").updateChildValues((EventViewController.event?.invitees)!)
                    eventTableViewController.tableView.reloadData()
                }
            }
        })
        
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let inviteFriendsViewController = segue.destination as? InviteFriendsViewController {
            
            invitees = inviteFriendsViewController.invitees
            InviteFriendsViewController.event = InviteEventViewController.event
            
            saveEvent()
        }
        if let addNoteViewController = segue.destination as? AddNoteViewController {
            AddNoteViewController.event = InviteEventViewController.event
            
            saveEvent()
            
            //            addNoteViewController.eventNameLabel.text = InviteEventViewController.event?.name
            //            print(addNoteViewController.eventNameLabel.text!)
            
            
        }
        
    }
    
    
    @IBAction func sendInvitesButtonTapped(_ sender: Any) {
        sendInvites()
    }
    
    @IBAction func saveCloseButton(_ sender: Any) {
        print("transitioning back to home/save")
        //save invites & segue
        saveEvent()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("dates are \(InviteEventViewController.event?.dates ?? [])")
        
        eventNameLabel.text = InviteEventViewController.event?.name //printing nil
        //add contacts output
        
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

extension InviteEventViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InviteesCell") as! InviteesCell
        
        return cell
    }
}
