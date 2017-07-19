//
//  DisplayNameViewController.swift
//  Time-Scheduling-App
//
//  Created by Kristie Huang on 7/10/17.
//  Copyright © 2017 Kristie Huang. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

class DisplayNameViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        guard let FIRUser = Auth.auth().currentUser, let name = nameTextField.text, let email = Auth.auth().currentUser?.email, !name.isEmpty else { return }
        
        UserService.createDatabase(FIRUser, name: name, email: email) { (user) in
            guard let user = user
                else { return }
            
            print("created new user: \(user.name)")
            
            User.setCurrent(user, writeToUserDefaults: true)
            
            let initialViewController = UIStoryboard.initialViewController(for: .main)
            self.view.window?.rootViewController = initialViewController
            self.view.window?.makeKeyAndVisible()
        }
    }
}


