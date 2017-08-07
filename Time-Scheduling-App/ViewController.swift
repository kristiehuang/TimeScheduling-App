//
//  ViewController.swift
//  Time-Scheduling-App
//
//  Created by Kristie Huang on 7/5/17.
//  Copyright © 2017 Kristie Huang. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController {
    //main page
    
    var newUser = false
    
    @IBAction func newButtonTapped(_ sender: Any) {
        print("new button tapped")
        //reset event to new
    }
    
    @IBAction func unwindToHome(_ segue: UIStoryboardSegue) {
        
    }
    
    @IBOutlet weak var tableView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newUser = LoginViewController.newUser
        
        //dismiss keyboard
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let tutorialAlert = UIAlertController(title: "Have you used this app before?", message: nil, preferredStyle: .alert)
        let yes = UIAlertAction(title: "Yes", style: .cancel, handler: nil)
        tutorialAlert.addAction(yes)
        
        let no = UIAlertAction(title: "No", style: .default, handler: { (UIAlertAction) in
            self.performSegue(withIdentifier: "toTutorial", sender: nil)
        })
        tutorialAlert.addAction(no)
        
        if newUser == true {
            present(tutorialAlert, animated: true)
            newUser = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "showTableSegue" {
                print("showing container view tablezzz")
                
            }
            else if identifier == "showNewEvent" {
                print("+ button tapped")
                let newEvent = Event(host: User.current.uid, name: "", invitees: [User.current.uid : false], emailInvitees: ["tempValue"], creationDate: Date(), dates: [], note: "")
                EventViewController.event = newEvent
                
                
            }
        }
    }
    
    
}
