//
//  User.swift
//  Time-Scheduling-App
//
//  Created by Kristie Huang on 7/10/17.
//  Copyright © 2017 Kristie Huang. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase.FIRDataSnapshot

class User: NSObject {
    
    let uid: String
    let name: String
    var email: String = (Auth.auth().currentUser?.email)!
    
    var isFriended = false
    var isInvited = false
    
    
    
    init(uid: String, name: String, email: String) {
        self.uid = uid
        self.name = name
        self.email = email
        super.init()
        
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String: Any], let name = dict["name"] as? String, let email = dict["email"] as? String
            else { return nil }
        self.uid = snapshot.key
        self.name = name
        self.email = email
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let uid = aDecoder.decodeObject(forKey: "uid") as? String,
            let name = aDecoder.decodeObject(forKey: "name") as? String, let email = aDecoder.decodeObject(forKey: "email") as? String
            else { return nil }
        
        self.uid = uid
        self.name = name
        self.email = email
        
        super.init()
    }
    
    private static var _current: User?
    
    static var current: User {
        guard let currentUser = _current
            else {
                fatalError("Error: current user doesn't exist")
        }
        return currentUser
    }
    
    
    class func setCurrent(_ user: User, writeToUserDefaults: Bool = false) {
        if writeToUserDefaults {
            let data = NSKeyedArchiver.archivedData(withRootObject: user)
            
            // 4
            UserDefaults.standard.set(data, forKey: "currentUser")
        }
        
        _current = user
    }
    
    
    
}

extension User: NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(email, forKey: "email")
    }
}
