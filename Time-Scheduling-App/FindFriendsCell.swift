//
//  FindFriendsCell.swift
//  Time-Scheduling-App
//
//  Created by Kristie Huang on 7/19/17.
//  Copyright © 2017 Kristie Huang. All rights reserved.
//

import Foundation
import UIKit

protocol FindFriendsCellDelegate: class {
    func didTapAddButton(_ addButton: UIButton, on cell: FindFriendsCell)
}

class FindFriendsCell: UITableViewCell {

    weak var delegate: FindFriendsCellDelegate?

    
    @IBOutlet weak var friendNameLabel: UILabel!
    
    @IBOutlet weak var friendEmailLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    @IBAction func addButtonTapped(_ sender: Any) {
        delegate?.didTapAddButton(sender as! UIButton, on: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addButton.setTitle("", for: .normal)
        addButton.setTitle("", for: .selected)
    }
    
}
