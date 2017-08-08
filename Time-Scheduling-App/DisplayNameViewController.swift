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
    
    var newUser = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self

        //dismiss keyboard
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        if !(nameTextField.text?.isEmpty)! {
            
            guard let FIRUser = Auth.auth().currentUser, let username = nameTextField.text, let email = Auth.auth().currentUser?.email, let name = Auth.auth().currentUser?.displayName, !name.isEmpty else { return }
            
            UserService.createDatabase(FIRUser, username: username, email: email, name: name) { (user) in
                guard let user = user
                    else { return }
                
                print("created new user: \(user.username)")
                
                User.setCurrent(user, writeToUserDefaults: true)
                
                let initialViewController = UIStoryboard.initialViewController(for: .main)
                self.view.window?.rootViewController = initialViewController
                self.view.window?.makeKeyAndVisible()
                
            }
        }
        else {
            let alertController = UIAlertController(title: "Enter a username", message: nil, preferredStyle: .alert)
            let ok = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            alertController.addAction(ok)
            present(alertController, animated: true)
        }
    }
}

//if username already in database, set new

extension DisplayNameViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxChar: Int = 50
        return (textField.text?.utf16.count)! + string.utf16.count - range.length <= maxChar
    }
    
}

