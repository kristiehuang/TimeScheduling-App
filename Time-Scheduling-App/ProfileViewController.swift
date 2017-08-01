//
//  ProfileViewController.swift
//  Time-Scheduling-App
//
//  Created by Kristie Huang on 7/31/17.
//  Copyright © 2017 Kristie Huang. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {

    
    var authHandle: AuthStateDidChangeListenerHandle?

    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBAction func developerBioButton(_ sender: Any) {
    }
    @IBAction func unwindToProfile(_ segue: UIStoryboardSegue) {
    }
    
    @IBAction func logOutButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let signOutAction = UIAlertAction(title: "Sign Out", style: .default) { _ in
            do {
                try Auth.auth().signOut()
            } catch let error as NSError {
                assertionFailure("Error signing out: \(error.localizedDescription)")
            }
        }
        
        
        alertController.addAction(signOutAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameLabel.text = User.current.name
        userEmailLabel.text = User.current.email
        
        authHandle = Auth.auth().addStateDidChangeListener() { [unowned self] (auth, user) in
            guard user == nil else { return }
            
            let loginViewController = UIStoryboard.initialViewController(for: .login)
            self.view.window?.rootViewController = loginViewController
            self.view.window?.makeKeyAndVisible()
        }
        
        
    }
    
        
        deinit {
            if let authHandle = authHandle {
                Auth.auth().removeStateDidChangeListener(authHandle)
            }
    }
}

