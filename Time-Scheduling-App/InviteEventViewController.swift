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
    //    var inviteeNames = [String]() //invitee names array
    //    static var inviteeEmails = [String]() //emails of invitee array
    
    var invitees = [User]() //
    //    var inviteesUser = [User]() //actual User array
    static var myInvitees = [User]() //actual invitees array in type User
    
    @IBAction func sendInvitesButtonTapped(_ sender: Any) {
        print("hello")
        let alertController = UIAlertController(title: "Are you sure?", message: "Invites will be sent to \(InviteEventViewController.myInvitees.count) user(s).", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancel)
        
        let next = UIAlertAction(
        title: "Send", style: .default) { (action) in
            
            AddNoteViewController.event = InviteEventViewController.event
            
            self.saveEvent()
            self.performSegue(withIdentifier: "toAddNote", sender: nil)
        }
        
        
        alertController.addAction(next)
        present(alertController, animated: true)
    }
    
    @IBAction func saveCloseButton(_ sender: Any) {
        print("transitioning back to home/save")
        //save invites & segue
        saveEvent()
    }
    
    
    //    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    //        textField.text =
    //            self.view.endEditing(true);
    //        return false;
    //    }
    
    
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
        
        self.emailTextField.delegate = self
        
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //        inviteeNames = []
        //        InviteEventViewController.inviteeEmails = []
        //        inviteesUser = []
        InviteEventViewController.myInvitees = []
        
        
        //        getInvites()
        
        for invitee in invitees { //from inviteFriends
            dispatchGroup.enter()
            
            let ref = Database.database().reference().child("users").child(invitee.uid)
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let user = User(snapshot: snapshot)
                InviteEventViewController.myInvitees.append(user!)
                self.dispatchGroup.leave()
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
            
            InviteEventViewController.myInvitees = inviteFriendsViewController.invitees
            InviteFriendsViewController.event = InviteEventViewController.event
            
            saveEvent()
        }
        
    }
    
    
}

extension InviteEventViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return InviteEventViewController.myInvitees.count
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
        //        cell.inviteeNameLabel.text = "\(inviteeNames[indexPath.row])"
        //        cell.inviteeEmailLabel.text = "\(InviteEventViewController.inviteeEmails[indexPath.row])"
        if InviteEventViewController.myInvitees.count > indexPath.row {
            
            cell.inviteeNameLabel.text = InviteEventViewController.myInvitees[indexPath.row].name
            cell.inviteeEmailLabel.text = InviteEventViewController.myInvitees[indexPath.row].email
            cell.inviteeButton.isSelected = InviteEventViewController.myInvitees[indexPath.row].isInvited
        }
        
        //        let invitee = inviteesUser[indexPath.row]
        //
        //        cell.inviteeButton.isSelected = friender.isInvited
        
    }
    
    
}
extension InviteEventViewController: InviteEventCellDelegate {
    func didTapInviteeButton(_ inviteeButton: UIButton, on cell: InviteesCell) {
        guard let indexPath = inviteesTableView.indexPath(for: cell) else { return }
        
        inviteeButton.isUserInteractionEnabled = true
        if InviteEventViewController.myInvitees.count > indexPath.row {
            
            let friender = InviteEventViewController.myInvitees[indexPath.row]
            
            
            //friendservice methods
            let dispatchReloadTable = DispatchGroup()
            dispatchReloadTable.enter()
            FriendService.setIsInviting(!friender.isInvited, InviteEventViewController.event!, fromCurrentUserTo: friender) { (success) in
                defer {
                    
                    inviteeButton.isUserInteractionEnabled = true
                    
                    if !friender.isInvited == false { //false, inviting
                        cell.inviteeButton.isSelected = false
                        InviteEventViewController.myInvitees.append(friender)
                        print("has been invited")
                        dispatchReloadTable.leave()
                    }
                    else if !friender.isInvited == true { //true, uninviting
                        cell.inviteeButton.isSelected = true
                        InviteEventViewController.myInvitees = InviteEventViewController.myInvitees.filter { $0 != friender }
                        print("has been UNinvited")
                        dispatchReloadTable.leave()
                    }
                    
                }
                
                guard success else { return }
                
                dispatchReloadTable.notify(queue: .main, execute: {
                    friender.isInvited = !friender.isInvited
                    self.inviteesTableView.reloadData()
                })
                
            }
        }
    }
}

extension InviteEventViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //        textField.text =
        
        self.view.endEditing(true)
        return false
    }
}

