//
//  InviteesCell.swift
//  Time-Scheduling-App
//
//  Created by Kristie Huang on 7/19/17.
//  Copyright © 2017 Kristie Huang. All rights reserved.
//

import Foundation
import UIKit

protocol InviteEventCellDelegate: class {
    func didTapInviteeButton(_ inviteeButton: UIButton, on cell: InviteesCell)
}
//on invite cell
class InviteesCell: UITableViewCell {

    weak var delegate: InviteEventCellDelegate?
    
    @IBOutlet weak var inviteeNameLabel: UILabel!
    @IBOutlet weak var inviteeEmailLabel: UILabel!
    @IBOutlet weak var inviteeButton: UIButton!
    
    @IBAction func inviteeButtonTapped(_ sender: Any) {
        print("celltappeed")
        //if selected = true, invite
        //if not selected, uninvite
        //uninvite
        delegate?.didTapInviteeButton(sender as! UIButton, on: self)

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        inviteeButton.setTitle("", for: .normal)
        inviteeButton.setTitle("", for: .selected)
    }
    
    
}
