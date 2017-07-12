//
//  Event.swift
//  Time-Scheduling-App
//
//  Created by Kristie Huang on 7/11/17.
//  Copyright © 2017 Kristie Huang. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot


class Event {
    
    var name: String?
    var creationDate: Date
    var host: User
    
    //turn event objects into dictionary type
    var dictValue: [String: Any] {
        let createdAgo = creationDate.timeIntervalSince1970
        
        return ["name": name ?? "Untitled Event",
                "created_at": createdAgo]
    }
    
    init(name: String, creationDate: Date, host: User) {
        self.name = name
        self.creationDate = Date()
        self.host = User.current
    }
    
    
}
