//
//  Extension.swift
//  Time-Scheduling-App
//
//  Created by Kristie Huang on 7/26/17.
//  Copyright © 2017 Kristie Huang. All rights reserved.
//

import Foundation

extension Dictionary where Key: Comparable {
    
    var valueKeySorted: [(Key, Value)] {
        return sorted {
            if $0.key != $1.key {
                return $0.key > $1.key
            }
            else {
                return String(describing: $0.key) < String(describing: $1.key)
            }
        }
    }

    
}
