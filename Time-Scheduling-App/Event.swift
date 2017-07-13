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
//    var host: User
    var key: String?
    
    var dates: [Int: Date]
    
    //turn event objects into dictionary type
    var dictValue: [String: Any] {
        let createdAgo = creationDate.timeIntervalSince1970
        
        return ["name": name ?? "Untitled Event",
                "created_at": createdAgo, "dates": dates]
    }
    
    init(name: String, creationDate: Date, dates: [Int: Date]) {
        self.name = name
        self.creationDate = Date()
//        self.host = User.current
        self.dates = dates
    }
    
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let name = dict["name"] as? String,
//            let host = dict["host"] as? User,
            let createdAgo = dict["created_at"] as? TimeInterval,
            let dates = dict["dates"] as? [Int: Date]
            else { return nil }
        
        self.key = snapshot.key
        self.name = name
        //self.host = host
        self.creationDate = Date(timeIntervalSince1970: createdAgo)
        self.dates = dates
    }


}
