//
//  UserService.swift
//  Time-Scheduling-App
//
//  Created by Kristie Huang on 7/10/17.
//  Copyright © 2017 Kristie Huang. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseAuth.FIRUser
import FirebaseDatabase

struct UserService {

    
    
    static func createDatabase(_ firUser: FIRUser, name: String, email: String, completion: @escaping (User?) -> Void) {
        let userAttrs = ["name": name, "email": email]
        
        
        
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
        let ref = Database.database().reference().child("events").child(User.current.uid)
//        let ref = Database.database().reference().child("users").child(User.current.uid).child("hosting events")

        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return completion([])
            }
            print(snapshot)
            let events = snapshot.reversed().flatMap(Event.init)
            
            //events returned in array
            print("amt of events i have according to firebase: \(events)")
            
            completion(events)
            
        })
    }
    
    
    //reads database
    
    static func readInvitedEvents(for user: User, completion: @escaping ([Event]) -> Void) {
        let ref = Database.database().reference().child("users").child(User.current.uid)
        
        ref.child("invited events").observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return completion([])
            }
            
            print("snapshot : \(snapshot)")
            let invitedEvents: [Event] = snapshot.reversed().flatMap(Event.init)
            
            //events returned in array
            print("amt of events i was invited to: \(invitedEvents.count)")
            
            completion(invitedEvents)
            
        })
    }
    
    //reads database
    
    static func readHostingEvents(for user: User, completion: @escaping ([Event]) -> Void) {
        
        let ref = Database.database().reference().child("users").child(User.current.uid)

        ref.child("hosting events").observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return completion([])
            }
            let hostingEvents = snapshot.reversed().flatMap(Event.init)
            
            //events returned in array
            print("amt of events i am hosting: \(hostingEvents.count)")
            completion(hostingEvents)
        })

    }
    
    
    
    static func usersExcludingCurrentUser(completion: @escaping ([User]) -> Void) {
        let currentUser = User.current
        let ref = Database.database().reference().child("users")
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                else { return completion([]) }
            
            let users =
                snapshot
                    .flatMap(User.init)
                    .filter { $0.uid != currentUser.uid }
            
            let dispatchGroup = DispatchGroup()
            users.forEach { (user) in
                dispatchGroup.enter()
                FriendService.isUserFriended(user) { (isFriended) in
                    user.isFriended = isFriended
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main, execute: {
                completion(users)
            })
        })
    }
    
    static func allUsers(completion: @escaping ([User]) -> Void) {
        let ref = Database.database().reference().child("users")
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                else { return completion([]) }
            
            let users =
                snapshot
                    .flatMap(User.init)
            
            let dispatchGroup = DispatchGroup()
            users.forEach { (user) in
                dispatchGroup.enter()
                FriendService.isUserFriended(user) { (isFriended) in
                    user.isFriended = isFriended
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main, execute: {
                completion(users)
            })
        })
    }
    
}
