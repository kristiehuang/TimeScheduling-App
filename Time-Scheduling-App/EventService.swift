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
    
    static var key: String = ""
    
    //just add event to database
    static func addEvent(name: String, invitees: [String: Bool], creationDate: Date, dates: [String], note: String) -> Event {
        let currentUser = User.current
        print("current user is \(currentUser.name)")
        
        //save to database
        let event = Event(host: User.current.uid, name: name, invitees: invitees, creationDate: creationDate, dates: dates, note: note)
        let dict = event.dictValue
        
        EventViewController.event = event
        
        let eventRef = Database.database().reference().child("events").child(currentUser.uid).childByAutoId()
        event.key = eventRef.key

        print("dict is \(dict)")
        eventRef.updateChildValues(dict)
        
        
        let ref = Database.database().reference().child("users").child(currentUser.uid).child("hosting events").child(eventRef.key)
        ref.updateChildValues(dict)
        
        //        let hostData = ["users/\(currentUser.uid)/hosting events/\(key)": true]
        //        Database.database().reference().updateChildValues(hostData) { (error, _) in
        //            if let error = error {
        //                assertionFailure(error.localizedDescription)
        //            }
        //        }
        
        return event
        
    }
    
}
