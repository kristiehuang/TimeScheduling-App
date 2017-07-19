//
//  FindFriendsCell.swift
//  Time-Scheduling-App
//
//  Created by Kristie Huang on 7/19/17.
//  Copyright © 2017 Kristie Huang. All rights reserved.
//

import Foundation
import UIKit

class FindFriendsCell: UITableViewCell {

    @IBOutlet weak var friendNameLabel: UILabel!
    
    @IBOutlet weak var friendEmailLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    @IBAction func addButtonTapped(_ sender: Any) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addButton.setTitle("", for: .normal)
        addButton.setTitle("", for: .selected)
    }
    
}
