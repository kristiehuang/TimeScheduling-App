//
//  FriendsViewController.swift
//  Time-Scheduling-App
//
//  Created by Kristie Huang on 7/19/17.
//  Copyright © 2017 Kristie Huang. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

//when button clicked, invite saved to array

//prepare... done clicked, array passed to InviteEventVC
//array displays on table
class InviteFriendsViewController: UIViewController {
    static var event: Event?
    
    var friends = [User]()
    var invitees = [User]()
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        
        invitees = []
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        UserService.usersExcludingCurrentUser { [unowned self] (users) in
            self.friends = users
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        for invitee in (InviteEventViewController.myInvitees) {
            let ref = Database.database().reference().child("users").child(invitee.uid)
            
            ref.observeSingleEvent(of: .value, with: { [unowned self] (snapshot) in
                if let user = User(snapshot: snapshot) {
                    self.invitees.append(user)
                }
                
                
            })
        }
        //read invitees
        
        super.viewWillAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        let inviteEventViewController = segue.destination as! InviteEventViewController
        //        inviteEventViewController.invitees = self.invitees
        InviteEventViewController.myInvitees = self.invitees //set IE invitees to invited invitees
        
        
    }
    
    
}



extension InviteFriendsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
        //display all users
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InviteFriendsCell") as! InviteFriendsCell
        
        cell.delegate = self
        configure(cell: cell, atIndexPath: indexPath)
        
        return cell
    }
    
    func configure(cell: InviteFriendsCell, atIndexPath indexPath: IndexPath) {
        
        let friend = friends[indexPath.row]
        cell.friendNameLabel.text = friend.username
        cell.friendEmailLabel.text = friend.name
        
        print(friend.isInvited)
        
        for invitee in invitees {
            if invitee.username == friend.username {
                friend.isInvited = true
            }
        }
        
        cell.inviteButton.isSelected = friend.isInvited
        
    }
}

extension InviteFriendsViewController: InviteFriendsCellDelegate {
    func didTapInviteButton(_ inviteButton: UIButton, on cell: InviteFriendsCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        inviteButton.isUserInteractionEnabled = false
        let friender = friends[indexPath.row]
        
        //        self.invitees = []
        
        //if empty, give invitees default value. if new invitees, reset & append
        
        FriendService.setIsInviting(!friender.isInvited, InviteFriendsViewController.event!, fromCurrentUserTo: friender) { (success) in
            defer {
                inviteButton.isUserInteractionEnabled = true
                if friender.isInvited == true { //false, inviting
                    self.invitees.append(friender)
                }
                else {
                    self.invitees = self.invitees.filter { $0 != friender }
                }
                
                print("invitees!!: \(self.invitees.enumerated())")
            }
            
            guard success else { return }
            
            friender.isInvited = !friender.isInvited
            
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        
    }
}
