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
        ref.setValue(friendData) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
            success(error == nil)
        }
    }
    
    static func setIsFriending(_ isFriending: Bool, fromCurrentUserTo friender: User, success: @escaping (Bool) -> Void) {
        //friender = user who is doing the friending
        
        if isFriending {
            friendUser(friender, forCurrentUserWithSuccess: success)
        } else {
            unfriendUser(friender, forCurrentUserWithSuccess: success)
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
    
}
