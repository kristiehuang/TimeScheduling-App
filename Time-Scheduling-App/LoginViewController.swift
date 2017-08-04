//
//  LoginViewController.swift
//  Time-Scheduling-App
//
//  Created by Kristie Huang on 7/5/17.
//  Copyright © 2017 Kristie Huang. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseAuthUI
import FirebaseDatabase

typealias FIRUser = FirebaseAuth.User

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    static var newUser = false
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        print("login button tapped")
        
        
        guard let authUI = FUIAuth.defaultAuthUI()
            else { return }
        authUI.delegate = self
        let authViewController = authUI.authViewController()
        present(authViewController, animated: true)
        //redesign auth page https://github.com/firebase/FirebaseUI-Android/issues/229
                
    }
    //google login doesnt work yet
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoginViewController.newUser = true
    }
    
}


extension LoginViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith user: FIRUser?, error: Error?) {
        if let error = error {
            if error.localizedDescription.contains("Network error") {
                let alertController = UIAlertController(title: "No network", message: "Make sure you're connected to wifi or data.", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Try again", style: .cancel, handler: nil)
                alertController.addAction(cancel)
                present(alertController, animated: true)
            }
            else if error.localizedDescription.contains("couldn’t be completed") {
//                    let alertController = UIAlertController(title: "Something went wrong", message: "", preferredStyle: .alert)
//                    let cancel = UIAlertAction(title: "Try again", style: .cancel, handler: nil)
//                    alertController.addAction(cancel)
//                    present(alertController, animated: true)
//                    assertionFailure("Error signing in: \(error.localizedDescription)")
                print("login cancelled")

            }
            else {
                let alertController = UIAlertController(title: "Something went wrong", message: "", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Try again", style: .cancel, handler: nil)
                alertController.addAction(cancel)
                present(alertController, animated: true)
                print("Error signing in: \(error.localizedDescription)")
                
            }
            return
        }
        

        //check user does exist
        guard let user = user
            else { return }
        let userRef = Database.database().reference().child("users").child(user.uid)
        
        
        userRef.observeSingleEvent(of: .value, with: { [unowned self] (snapshot) in
            if let user = User(snapshot: snapshot) {
                print("\(user.name) already exists")
                
                User.setCurrent(user, writeToUserDefaults: true)
                
                let storyboard = UIStoryboard(name: "Main", bundle: .main)
                
                if let initialViewController = storyboard.instantiateInitialViewController() {
                    self.view.window?.rootViewController = initialViewController
                    self.view.window?.makeKeyAndVisible()
//                    
                }
                
            }
            else {
                print("new user")
                self.performSegue(withIdentifier: "toDisplayName", sender: self)
                
            }
        })
        


        print("handle user signup / login")
    }
}
