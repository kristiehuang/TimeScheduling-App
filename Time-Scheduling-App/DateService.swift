//
//  DateService.swift
//  Time-Scheduling-App
//
//  Created by Kristie Huang on 7/12/17.
//  Copyright © 2017 Kristie Huang. All rights reserved.
//

//import Foundation
//import FirebaseDatabase
//
//struct DateService {
//    
//    //add datesChosen array to database
//    
//    static func datesToDatabase(_ firUser: FIRUser, dates: [Date], completion: @escaping (Dates?) -> Void) {
//        let dateAttrs = ["date": dates]
//        
//        let ref = Database.database().reference().child("events").child(firUser.uid).child("dates").childByAutoId()
//        ref.setValue(dateAttrs) { (error, ref) in
//            if let error = error {
//                assertionFailure(error.localizedDescription)
//                return completion(nil)
//            }
//            
//            ref.observeSingleEvent(of: .value, with: { (snapshot) in
//                let date = Dates(snapshot: snapshot)
//                completion(date)
//            })
//        }
//    }
//
//    
//}
