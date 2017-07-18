//
//  finalEventViewController.swift
//  Time-Scheduling-App
//
//  Created by Kristie Huang on 7/17/17.
//  Copyright © 2017 Kristie Huang. All rights reserved.
//

import Foundation
import UIKit


class finalEventViewController: UIViewController {
    @IBOutlet weak var eventNameLabel: UILabel!
    
    @IBAction func sendInvitesButtonTapped(_ sender: Any) {
    }

    @IBAction func saveCloseButton(_ sender: Any) {
    }
    
    @IBAction func addInviteActionTriggered(_ sender: Any) {
            }
    
    @IBAction func touchCancelTriggered(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //dismiss keyboard
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let eventViewController = segue.destination as? EventViewController {
            eventViewController.newEvent()
        }
    }
    
    
    
    
}
