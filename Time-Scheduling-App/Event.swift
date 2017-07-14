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
    
    var dates: [String]
    
    //turn event objects into dictionary type
    var dictValue: [String: Any] {        
        return ["name": name ?? "Untitled Event",
                "created_at": creationDate.timeIntervalSince1970, "dates": dates]
    }
    
    init(name: String, creationDate: Date, dates: [String]) {
        self.name = name
        self.creationDate = Date()
//        self.host = User.current
        self.dates = dates
    }
    
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String: Any]
            else { return nil }

        guard let name = dict["name"] as? String
            else { return nil }

        guard let createdAgo = dict["created_at"] as? TimeInterval
            else { return nil }

        guard let dates = dict["dates"] as? [String]
            else { return nil }
        
        self.key = snapshot.key
        self.name = name
        //self.host = host
        self.creationDate = Date(timeIntervalSince1970: createdAgo)
//        for date in dates {
//            self.dates.append(date)
//        }
        self.dates = dates
    }


}
