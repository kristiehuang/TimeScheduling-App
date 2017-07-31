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
    

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBAction func returnButtonTapped(_ sender: Any) {
    }

    
    @IBOutlet weak var eventNameLabel: UILabel!
    
    //add contacts output
    
    @IBOutlet weak var inviteesTableView: UITableView!
    
    @IBAction func unwindToInvite(_ segue: UIStoryboardSegue) {
    }
    
    let dispatchGroup = DispatchGroup()
    static var event: Event?
    var inviteeNames = [String]() //invitee names array
    static var inviteeEmails = [String]() //emails of invitee array
    
    var invitees = [User]() //
    var inviteesUser = [User]() //actual User array
    var myInvitees = [User]() //actual invitees array in type User

    
    
    @IBAction func sendInvitesButtonTapped(_ sender: Any) {
        print("hello")
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
    
    override func viewDidAppear(_ animated: Bool) {
        dispatchGroup.enter()
        inviteeNames = []
        InviteEventViewController.inviteeEmails = []
        inviteesUser = []
        
        getInvites()
        
        for invitee in (invitees) {
            
            let ref = Database.database().reference().child("users").child(invitee.uid)
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let user = User(snapshot: snapshot)
                self.inviteesUser.append(user!)
            })
            
            //go into database, append user based on key
        }
        
        
        
        
        dispatchGroup.notify(queue: .main, execute: {
            
            print("dispatch group run yay")
            self.inviteesTableView.reloadData()
            super.viewDidAppear(true)
        })
        
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
            
            inviteesUser = inviteFriendsViewController.invitees
            InviteFriendsViewController.event = InviteEventViewController.event
            
            saveEvent()
        }
        if let addNoteViewController = segue.destination as? AddNoteViewController {
            AddNoteViewController.event = InviteEventViewController.event
            
            saveEvent()
            
        }
        
    }
    
    
    func getInvites() {
        
        var name = ""
        var email: String = ""
        
        
        UserService.events(for: User.current, completion: { (events:[Event]) in
            
            for eventz in events {
                print(eventz.key)
                print(InviteEventViewController.event?.key)
                if InviteEventViewController.event?.key == eventz.key {
                    let anotherDispatchGroup = DispatchGroup()
                    
                    for invitee in eventz.invitees {
                        
                        anotherDispatchGroup.enter()
                        
                        let ref = Database.database().reference().child("users").child(invitee.key)
                        
                        ref.observeSingleEvent(of: .value, with: { (snapshot) in
                            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                                return
                            }
                            print(snapshot[0].value as! String)
                            
                            
                            //
                            email = snapshot[0].value as! String
                            
                            if snapshot.count == 4 {
                                name = snapshot[3].value as! String
                            }
                            else if snapshot.count == 3 {
                                name = snapshot[2].value as! String
                            }
                            else if snapshot.count == 2 {
                                name = snapshot[1].value as! String
                            }
                            
                            
                            self.inviteeNames.append(name)
                            InviteEventViewController.inviteeEmails.append(email)
                            
                            anotherDispatchGroup.leave()
                        })
                        
                        
                    }
                    anotherDispatchGroup.notify(queue: .main, execute: {
                        print("invitee")
                        self.inviteesTableView.reloadData()
                        
                        self.dispatchGroup.leave()
                    })
                    
                    
                    
                }
            }
        })
        
    }
    
    
}

extension InviteEventViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.inviteeNames.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "InviteesCell") as! InviteesCell
        
        cell.delegate = self
        
        configure(cell: cell, atIndexPath: indexPath)
        
        
        //
        //        let invitee = inviteesUser[indexPath.row]
        //        cell.inviteeButton.isSelected = invitee.isInvited
        
        return cell
    }
    
    func configure(cell: InviteesCell, atIndexPath indexPath: IndexPath) {
        
        
        //
        cell.inviteeNameLabel.text = "\(inviteeNames[indexPath.row])"
        cell.inviteeEmailLabel.text = "\(InviteEventViewController.inviteeEmails[indexPath.row])"
        
        //        let invitee = inviteesUser[indexPath.row]
        //
        //        cell.inviteeButton.isSelected = friender.isInvited
        
    }
    
    
}
extension InviteEventViewController: InviteEventCellDelegate {
    func didTapInviteeButton(_ inviteeButton: UIButton, on cell: InviteesCell) {
        guard let indexPath = inviteesTableView.indexPath(for: cell) else { return }
        
        inviteeButton.isUserInteractionEnabled = true
        if self.inviteesUser.count > indexPath.row {
            
            let friender = self.inviteesUser[indexPath.row]
            
            
            //friendservice methods
            let dispatchReloadTable = DispatchGroup()
            dispatchReloadTable.enter()
            FriendService.setIsInviting(!friender.isInvited, InviteEventViewController.event!, fromCurrentUserTo: friender) { (success) in
                defer {
                    inviteeButton.isUserInteractionEnabled = true
                    
                    if !friender.isInvited == true { //false, inviting
                        self.myInvitees.append(friender)
                        print("has been invited")
                        dispatchReloadTable.leave()
                    }
                    if !friender.isInvited == false { //true, uninviting
                        self.myInvitees = self.myInvitees.filter { $0 != friender }
                        print("has been UNinvited")

                        dispatchReloadTable.leave()
                    }
                    
                }
                
                guard success else { return }
                
                dispatchReloadTable.notify(queue: .main, execute: { 
                    friender.isInvited = !friender.isInvited
                    
                    cell.inviteeButton.isSelected = friender.isInvited
                    
                    self.inviteesTableView.reloadRows(at: [indexPath], with: .none)
                })
  
            }
        }
    }
}

