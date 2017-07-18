//
//  Storyboard+Utility.swift
//  Time-Scheduling-App
//
//  Created by Kristie Huang on 7/18/17.
//  Copyright © 2017 Kristie Huang. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    
    enum AirTime: String {
        case login
        case main
        
        var filename: String {
            return rawValue.capitalized
        }
        
        
    }
    
    
    
    //initialize correct storyboard
    convenience init(type: AirTime, bundle: Bundle? = nil) {
        self.init(name: type.filename, bundle: bundle)
    }
    
    
    static func initialViewController(for type: AirTime) -> UIViewController {
        let storyboard = UIStoryboard(type: type)
        guard let initialViewController = storyboard.instantiateInitialViewController()
            else {
                fatalError("Couldn't instantiate initial view controller for \(type.filename) storyboard.")
        }
        
        return initialViewController
    }
    
    
    
}
