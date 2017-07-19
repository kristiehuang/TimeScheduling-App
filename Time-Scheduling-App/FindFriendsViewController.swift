//
//  FindFriendsViewController.swift
//  Time-Scheduling-App
//
//  Created by Kristie Huang on 7/19/17.
//  Copyright © 2017 Kristie Huang. All rights reserved.
//

import Foundation
import UIKit

class FindFriendsViewController: UIViewController {

    var users = [User]()
    
    @IBOutlet weak var tableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view did load")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        UserService.usersExcludingCurrentUser { [unowned self] (users) in
            self.users = users
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    //find friend by email, then friend
    
}


extension FindFriendsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FindFriendsCell") as! FindFriendsCell
        cell.delegate = self
        configure(cell: cell, atIndexPath: indexPath)
        
        return cell
    }
    
    func configure(cell: FindFriendsCell, atIndexPath indexPath: IndexPath) {
        let friend = users[indexPath.row]
        
        cell.friendNameLabel.text = friend.name
        cell.addButton.isSelected = friend.isFriended
        
    }
}

extension FindFriendsViewController: FindFriendsCellDelegate {
    func didTapAddButton(_ addButton: UIButton, on cell: FindFriendsCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        addButton.isUserInteractionEnabled = false
        let friender = users[indexPath.row]
        
        FriendService.setIsFriending(!friender.isFriended, fromCurrentUserTo: friender) { (success) in
            defer {
                addButton.isUserInteractionEnabled = true
            }
            
            guard success else { return }
            
            friender.isFriended = !friender.isFriended
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}
