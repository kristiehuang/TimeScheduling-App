//
//  EventViewController.swift
//  Time-Scheduling-App
//
//  Created by Kristie Huang on 7/10/17.
//  Copyright © 2017 Kristie Huang. All rights reserved.
//

import Foundation
import UIKit
import JTAppleCalendar

class EventViewController: UIViewController {
    //event page
    let formatter = DateFormatter()

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension EventViewController: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2017 01 01")!
        let endDate = formatter.date(from: "2017 12 31")!

        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        cell.dateLabel.text = cellState.text
        return cell
    }

}

//extension EventViewController: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate, UICollectionViewDataSource {
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 10
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath)
//        
//        return cell
//    }
//    
//    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
//        formatter.dateFormat = "yyyy MM dd"
//        formatter.timeZone = Calendar.current.timeZone
//        formatter.locale = Calendar.current.locale
//        
//        //2017 only, change later
//        let startDate = formatter.date(from: "2017 01 01")!
//        let endDate = formatter.date(from: "2017 12 31")!
//        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
//        return parameters
//    }
//    
//
//    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
//        
//        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarView", for: indexPath) as! CalendarCell
//        cell.dateLabel.text = cellState.text
//        return cell
//    }
//    
////                //cell text
////                myCustomCell.dayLabel.text = cellState.text
////        
////                //text color
////        
////                //Important: cache your colors in a real app else your calendar will be laggy. The code is for demonstration only. Just like in UITableView, this function will be called for every cell displayed on screen so be efficient with this code.
////        
////        
////                if cellState.dateBelongsTo == .thisMonth {
////                    myCustomCell.dayLabel.textColor = UIColor.black
////                }
////                else {
////                    myCustomCell.dayLabel.textColor = UIColor.gray
////                }
////    }
//}
