//
//  EventService.swift
//  Time-Scheduling-App
//
//  Created by Kristie Huang on 7/11/17.
//  Copyright © 2017 Kristie Huang. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseStorage

struct EventService {
    
    static func createEvent(name: String, creationDate: Date) {
        let currentUser = User.current
        print("current user is \(currentUser.name)")
        
        
        let event = Event(name: name, creationDate: creationDate)
        let dict = event.dictValue

        let eventRef = Database.database().reference().child("events").child(currentUser.uid).childByAutoId()
        eventRef.updateChildValues(dict)
    }
    
}
