//
//  FriendService.swift
//  Time-Scheduling-App
//
//  Created by Kristie Huang on 7/19/17.
//  Copyright © 2017 Kristie Huang. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct FriendService {
    
    private static func friendUser(_ user: User, forCurrentUserWithSuccess success: @escaping (Bool) -> Void) {
        let currentUID = User.current.uid
        let friendData = ["friends/\(currentUID)/\(user.uid)": true]
        
        let ref = Database.database().reference()
        ref.updateChildValues(friendData) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
            success(error == nil)
        }
    }
    
    private static func unfriendUser(_ user: User, forCurrentUserWithSuccess success: @escaping (Bool) -> Void) {
        let currentUID = User.current.uid
        let friendData = ["friends/\(currentUID)/\(user.uid)": NSNull()]
        
        let ref = Database.database().reference()
        ref.updateChildValues(friendData) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
            success(error == nil)
        }
    }
    
    
    private static func inviteUser(_ user: User, _ event: Event, forCurrentUserWithSuccess success: @escaping (Bool) -> Void) {

        let currentUID = User.current.uid
//        EventViewController.invitees.append(user)
//        print(EventViewController.invitees)

        let ref = Database.database().reference()
        
        let key = EventService.key
        print(key)
        //
        let inviteData = ["events/\(currentUID)/\(key)/invitees/\(user.uid)": true, "users/\(user.uid)/invited events/\(key)/invitees/\(user.uid)": true, "users/\(currentUID)/hosting events/\(key)/invitees/\(user.uid)": true]
        
        
        
        
        ref.updateChildValues(inviteData) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
            success(error == nil)
        }
        
        print(event.dictValue)

        
        let eventRef = Database.database().reference().child("users").child(user.uid).child("invited events").child(key)
        eventRef.updateChildValues(event.dictValue)
//
    }
    
    
    private static func uninviteUser(_ user: User, _ event: Event, forCurrentUserWithSuccess success: @escaping (Bool) -> Void) {
        let currentUID = User.current.uid
        let ref = Database.database().reference()
        
        let key = EventService.key
        print(key)
        
        let inviteData = ["events/\(currentUID)/\(key)/invitees/\(user.uid)": NSNull(), "users/\(user.uid)/invited events/\(key)/invitees/\(user.uid)": NSNull(), "users/\(currentUID)/hosting events/\(key)/invitees/\(user.uid)": NSNull()]
        ref.updateChildValues(inviteData) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
            success(error == nil)
        }
        
        
        let eventRef = Database.database().reference().child("users").child(user.uid).child("invited events").child(key)
        eventRef.updateChildValues(event.dictValue)
    }
    
    

    static func setIsFriending(_ isFriending: Bool, fromCurrentUserTo friender: User, success: @escaping (Bool) -> Void) {
        //friender = user who is doing the friending
        
        if isFriending == true {
            friendUser(friender, forCurrentUserWithSuccess: success)
        } else {
            unfriendUser(friender, forCurrentUserWithSuccess: success)
        }
    }
    
    static func setIsInviting(_ isInvited: Bool, _ event: Event, fromCurrentUserTo friender: User, success: @escaping (Bool) -> Void) {
        //friender = user who is doing the friending
        
        if isInvited == true {
            inviteUser(friender, event, forCurrentUserWithSuccess: success)
        } else {
            uninviteUser(friender, event, forCurrentUserWithSuccess: success)
        }
    }

    
    static func isUserFriended(_ user: User, byCurrentUserWithCompletion completion: @escaping (Bool) -> Void) {
        let currentUID = User.current.uid
        //does current user follow user?
        let ref = Database.database().reference().child("friends").child(currentUID)
        
        ref.queryEqual(toValue: nil, childKey: user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? [String : Bool] {
                completion(true)
            } else {
                completion(false)
            }
        })
    }
    
    static func isUserInvited(_ user: User, _ event: Event, byCurrentUserWithCompletion completion: @escaping (Bool) -> Void) {
        let currentUID = User.current.uid
        //does current user follow user?
        let ref = Database.database().reference().child("events").child(currentUID).child("invitees")

        ref.queryEqual(toValue: nil, childKey: user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? [String : Bool] {
                completion(true)
            } else {
                completion(false)
            }
        })
    }
    
}
