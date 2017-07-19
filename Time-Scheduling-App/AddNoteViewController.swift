//
//  AddNoteViewController.swift
//  Time-Scheduling-App
//
//  Created by Kristie Huang on 7/18/17.
//  Copyright © 2017 Kristie Huang. All rights reserved.
//

import Foundation
import UIKit

class AddNoteViewController: UIViewController {
    
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBAction func finishButtonTapped(_ sender: Any) {
    }
    
    @IBOutlet weak var noteTextView: UITextView!
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventNameLabel.text = EventViewController.event?.name
         
        //dismiss keyboard
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
}
