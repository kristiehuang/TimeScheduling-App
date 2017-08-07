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
    
    var host: String
    var key: String?
    
    var dates: [String]
    var invitees: [String: Any]?
    var emailInvitees: [String]?
    var note: String
    
    var bestDate: String?
    
    //turn event objects into dictionary type
    var dictValue: [String: Any] {        
        return ["best date": bestDate ?? "", "host": host, "name": name ?? "Untitled Event", "invitees": invitees ?? [User.current.uid: false], "created_at": creationDate.timeIntervalSince1970, "dates": dates, "note": note]
    }
    
    init(host: String, name: String, invitees: [String: Any], emailInvitees: [String]? = nil, creationDate: Date, dates: [String], note: String, bestDate: String? = nil) {
        self.host = host
        self.name = name
        self.creationDate = Date()
        self.dates = dates
        self.invitees = invitees
        self.emailInvitees = nil
        self.note = note
        self.bestDate = bestDate
        
    }
    
    
    init?(snapshot: DataSnapshot) {
        
        guard let dict = snapshot.value as? [String: Any]
            else { return nil }

        guard let name = dict["name"] as? String
            else { return nil }
        
        guard let host = dict["host"] as? String
            else { return nil }

        guard let createdAgo = dict["created_at"] as? TimeInterval
            else { return nil }

        guard let dates = dict["dates"] as? [String]
            else { return nil }
        
        guard let invitees = dict["invitees"] as? [String: Any]
            else { return nil }
        
        guard let note = dict["note"] as? String
            else { return nil }
        
        guard let bestDate = dict["best date"] as? String
            else { return nil }
        
        self.key = snapshot.key
        self.host = host
        self.name = name
        //self.host = host
        self.creationDate = Date(timeIntervalSince1970: createdAgo)
//        for date in dates {
//            self.dates.append(date)
//        }
        self.dates = dates
        self.invitees = invitees
        self.note = note
        self.bestDate = bestDate
    }


}
