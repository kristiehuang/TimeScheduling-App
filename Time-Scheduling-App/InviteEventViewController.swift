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
    var invitees = [String]()
    var inviteeEmails = [String]()
    var inviteesUser = [User]()
    
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
    }
    
    @IBAction func saveCloseButton(_ sender: Any) {
        print("transitioning back to home/save")
        //save invites & segue
        saveEvent()
    }
    
    
    override func viewDidLoad() {
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
        
        super.viewDidLoad()

    }
    
    let dispatchGroup = DispatchGroup()

    override func viewWillAppear(_ animated: Bool) {
        dispatchGroup.enter()
        getInvites()
        
        dispatchGroup.notify(queue: .main) { 
            self.inviteesTableView.reloadData()
            super.viewWillAppear(true)
        }
        
        
        UserService.usersExcludingCurrentUser { [unowned self] (users) in
            self.inviteesUser = users
            
            DispatchQueue.main.async {
                self.inviteesTableView.reloadData()
            }
        }


    }
    
    func getInvites() {
        
        var name = ""
        var email: String = ""
        
        
        UserService.events(for: User.current, completion: { (events:[Event]) in
            
            for eventz in events {
                if EventViewController.event?.key == eventz.key {


                    for invitee in eventz.invitees {

                        let ref = Database.database().reference().child("users").child(invitee.key)
                        
                        ref.observeSingleEvent(of: .value, with: { (snapshot) in
                            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                                return
                            }
                            print(snapshot[0].value as! String)
                            
//
                            name = snapshot[3].value as! String
                            email = snapshot[0].value as! String
                            
                            
                            self.invitees.append(name)
                            self.inviteeEmails.append(email)
                            
                        })


                    }
                }
            }
            self.dispatchGroup.leave()
        })

    }
    
    
}

extension InviteEventViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.invitees.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "InviteesCell") as! InviteesCell
        
        cell.delegate = self

        cell.inviteeNameLabel.text = "\(invitees[indexPath.row])"
        cell.inviteeEmailLabel.text = "\(inviteeEmails[indexPath.row])"

        
        return cell
    }
}
extension InviteEventViewController: InviteEventCellDelegate {
    func didTapInviteeButton(_ inviteeButton: UIButton, on cell: InviteesCell) {
        guard let indexPath = inviteesTableView.indexPath(for: cell) else { return }
        
        inviteeButton.isUserInteractionEnabled = false
        let friender = inviteesUser[indexPath.row]
        
        //display friends only
        //if setIsFriending = true, display
        
        self.invitees = []

        //friendservice methods
        
        FriendService.setIsInviting(!friender.isInvited, InviteEventViewController.event!, fromCurrentUserTo: friender) { (success) in
            defer {
                inviteeButton.isUserInteractionEnabled = true
                self.invitees.append("\(friender)")
                print("invitees!!: \(self.invitees.enumerated())")
            }
            
            guard success else { return }
            
            friender.isInvited = !friender.isInvited
            self.inviteesTableView.reloadRows(at: [indexPath], with: .none)
        }
        
    }
}

