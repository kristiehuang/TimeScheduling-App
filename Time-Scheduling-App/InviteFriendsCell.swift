//
//  InviteFriendsCell.swift
//  Time-Scheduling-App
//
//  Created by Kristie Huang on 7/19/17.
//  Copyright © 2017 Kristie Huang. All rights reserved.
//

import Foundation
import UIKit

protocol InviteFriendsCellDelegate: class {
    func didTapInviteButton(_ addButton: UIButton, on cell: InviteFriendsCell)
}
//display FRIENDS only

class InviteFriendsCell: UITableViewCell {
    
    weak var delegate: InviteFriendsCellDelegate?
    
    @IBOutlet weak var friendNameLabel: UILabel!
    @IBOutlet weak var friendEmailLabel: UILabel!
    @IBOutlet weak var inviteButton: UIButton!
    
    @IBAction func inviteButtonTapped(_ sender: Any) {
        delegate?.didTapInviteButton(sender as! UIButton, on: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        inviteButton.setTitle("", for: .normal)
        inviteButton.setTitle("", for: .selected)
    }
    
}
