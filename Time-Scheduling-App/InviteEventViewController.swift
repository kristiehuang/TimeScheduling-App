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
    
    var event: Event?

    @IBOutlet weak var eventNameLabel: UILabel!
    
    //add contacts output
    
    @IBOutlet weak var inviteesTableView: UITableView!
    
    
    @IBAction func unwindToInvite(_ segue: UIStoryboardSegue) {
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //back button triggers this too
        if let eventViewController = segue.destination as? EventViewController {
        }
    }
    
    @IBAction func sendInvitesButtonTapped(_ sender: Any) {
        //send invites
        sendInvites()
    }
    
    @IBAction func saveCloseButton(_ sender: Any) {
        print("transitioning back to home/save")
        //save invites & segue
    }
    
    
    @IBAction func touchCancelTriggered(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let event = event {
            eventNameLabel.text = event.name
            //add contacts output
        }
        
        //dismiss keyboard
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    

    
    func sendInvites() {
        //
        
    }
    
    
    
    
}
