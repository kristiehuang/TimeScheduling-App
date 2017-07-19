//
//  UserService.swift
//  Time-Scheduling-App
//
//  Created by Kristie Huang on 7/10/17.
//  Copyright © 2017 Kristie Huang. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth.FIRUser
import FirebaseDatabase

struct UserService {
    static func createDatabase(_ firUser: FIRUser, name: String, completion: @escaping (User?) -> Void) {
        let userAttrs = ["name": name]
        
        let ref = Database.database().reference().child("users").child(firUser.uid)
        ref.setValue(userAttrs) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let user = User(snapshot: snapshot)
                completion(user)
            })
        }
    }
    
    
    //reads database

    static func events(for user: User, completion: @escaping ([Event]) -> Void) {
        let ref = Database.database().reference().child("events").child(user.uid)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return completion([])
            }
            let events = snapshot.reversed().flatMap(Event.init)
            
            //events returned in array
            print("amt of events i have according to firebase: \(events.count)")
            
            completion(events)

        })
    }
    
}
