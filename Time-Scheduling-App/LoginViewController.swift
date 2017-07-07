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

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        print("login button tapped")
        
        guard let authUI = FUIAuth.defaultAuthUI()
            else { return }
        authUI.delegate = self
        let authViewController = authUI.authViewController()
        present(authViewController, animated: true)
    }
    //google login doesnt work yet
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}


extension LoginViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if let error = error {
            assertionFailure("Error signing in: \(error.localizedDescription)")
            return
        }
        
        print("handle user signup / login")
    }
}
