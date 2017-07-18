//
//  User.swift
//  Time-Scheduling-App
//
//  Created by Kristie Huang on 7/10/17.
//  Copyright © 2017 Kristie Huang. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot

class User: NSObject {
    
    let uid: String
    let name: String
    

    
    init(uid: String, name: String) {
        self.uid = uid
        self.name = name
        super.init()

    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String: Any], let name = dict["name"] as? String
            else { return nil }
        self.uid = snapshot.key
        self.name = name
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let uid = aDecoder.decodeObject(forKey: "uid") as? String,
            let name = aDecoder.decodeObject(forKey: "name") as? String
            else { return nil }
        
        self.uid = uid
        self.name = name
        
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
    }
}
