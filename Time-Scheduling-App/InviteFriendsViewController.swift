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
    var invitees = [String]()

    

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {

        UserService.usersExcludingCurrentUser { [unowned self] (users) in
            self.friends = users
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        super.viewWillAppear(animated)
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
        cell.friendNameLabel.text = friend.name
        cell.friendEmailLabel.text = friend.email
        
        cell.inviteButton.isSelected = friend.isInvited
        

        
    }
}

extension InviteFriendsViewController: InviteFriendsCellDelegate {
    func didTapInviteButton(_ inviteButton: UIButton, on cell: InviteFriendsCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        inviteButton.isUserInteractionEnabled = false
        let friender = friends[indexPath.row]
        
        self.invitees = []

        
        //friendservice methods
        print(InviteFriendsViewController.event?.dates)
        print(InviteFriendsViewController.event?.invitees)

        FriendService.setIsInviting(!friender.isInvited, InviteFriendsViewController.event!, fromCurrentUserTo: friender) { (success) in
            defer {
                inviteButton.isUserInteractionEnabled = true
                self.invitees.append("\(friender)")
                print("invitees!!: \(self.invitees.enumerated())")
            }
            
            guard success else { return }
            
            friender.isInvited = !friender.isInvited
            
            
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        
//        if cell.inviteButton.isUserInteractionEnabled {
//            friender.isInvited = true
//            invites.append(friender)
//        }
//        else {
//            friender.isInvited = false
//            invites = invites.filter { $0 != friender }
//        }
//        print("they were invited: \(invites.enumerated())")
        
    }
}
