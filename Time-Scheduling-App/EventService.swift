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

    
    //just add event to database
//    static func addEvent(name: String, creationDate: Date, dates: [Int : Date]) -> Event {
    static func addEvent(name: String, creationDate: Date, dates: [String : String]) -> Event {
        let currentUser = User.current


        print(dates)
        
        print("current user is \(currentUser.name)")
        
        //save to database
        let event = Event(name: name, creationDate: creationDate, dates: dates)
        let dict = event.dictValue

        
        let eventRef = Database.database().reference().child("events").child(currentUser.uid).childByAutoId()

//        let eventRef = Database.database().reference().child("events").child(currentUser.uid)
 print(dict)

        eventRef.updateChildValues(dict)
        
//        let refref = eventRef.childByAutoId().key
//        let evnet = ["dates": dates as [Int: Date],
//                    "created_at": creationDate,
//                    "name": name] as [String : Any]
//        let childUpdates = ["/events/\(refref)": evnet]
//        eventRef.updateChildValues(childUpdates)
//        
        print("adfaf")
        return event

    }
    
    
    
    
}
