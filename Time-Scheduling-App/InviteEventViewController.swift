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
    var invitees = [String]() //invitee names array
    static var inviteeEmails = [String]() //emails of invitee array
    
    var inviteesUser = [User]() //actual User array
    var myInvitees = [User]() //actual invitees array in type User
    @IBOutlet weak var emailTextField: UITextField!

    @IBAction func returnButtonTapped(_ sender: Any) {
        print(emailTextField.text)
    }
    
    let dispatchGroup = DispatchGroup()
    
    
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
            
            inviteesUser = inviteFriendsViewController.invitees
            InviteFriendsViewController.event = InviteEventViewController.event
            
            saveEvent()
        }
        if let addNoteViewController = segue.destination as? AddNoteViewController {
            AddNoteViewController.event = InviteEventViewController.event
            
            saveEvent()
            
        }
        
    }
    
    
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
        invitees = []
        InviteEventViewController.inviteeEmails = []
        
        getInvites()
        
        dispatchGroup.notify(queue: .main, execute: {
            
            //
            //            UserService.usersExcludingCurrentUser { [unowned self] (users) in
            //                self.inviteesUser = users
            //
            //                DispatchQueue.main.async {
            //                    self.inviteesTableView.reloadData()
            //                }
            //            }
            print("dispatch group run yay")
            self.inviteesTableView.reloadData()
            super.viewDidAppear(true)
        })
        
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
                        

                            self.invitees.append(name)
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
        return self.invitees.count
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
        cell.inviteeNameLabel.text = "\(invitees[indexPath.row])"
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
            
//            self.inviteesUser = []

//            cell.inviteeButton.isSelected = friender.isInvited
            
//            if !cell.inviteeButton.isSelected {
//                friender.isInvited = false
//                inviteesUser.remove(at: indexPath.row)
//                inviteesTableView.reloadData()
//                
//            }
//            
            //display friends only
            //if setIsFriending = true, display
            
            
            //friendservice methods
            
            FriendService.setIsInviting(!friender.isInvited, InviteEventViewController.event!, fromCurrentUserTo: friender) { (success) in
                defer {
                    inviteeButton.isUserInteractionEnabled = true
                    self.myInvitees.append(friender)
                    print("invitees!!: \(self.inviteesUser.enumerated())")

                }
                
                guard success else { return }
                
                friender.isInvited = !friender.isInvited
                
                cell.inviteeButton.isSelected = friender.isInvited

                self.inviteesTableView.reloadRows(at: [indexPath], with: .none)
            }
        }
    }
}

