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
    @IBAction func newButtonTapped(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "showNewEvent" {
                print("Transitioning to the new event")
            }
        }
    }
    
}

