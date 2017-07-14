//
//  EventViewController.swift
//  Time-Scheduling-App
//
//  Created by Kristie Huang on 7/10/17.
//  Copyright © 2017 Kristie Huang. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import JTAppleCalendar

class EventViewController: UIViewController {
    //event page
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var monthYearLabel: UILabel!
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var availableDatesLabel: UILabel!
    
    @IBAction func backButtonTapped(_ sender: Any) {
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
    }
    
    @IBAction func saveCloseButtonTapped(_ sender: Any) {
    }
    
    
    let outsideMonthColor = UIColor(colorWithHexValue: 0x7FAEE7) //cell date label color in indates/outdates
    let monthColor = UIColor.white //cell date label color in this month
    let selectedMonthColor = UIColor(colorWithHexValue: 0xA3C9F6) //color of selected date label text
    let currentDateSelectedViewColor = UIColor(colorWithHexValue: 0x7FAEE7)
    
    //    let event = Event(name: "", creationDate: Date(), host: User.current)
    
    let formatter = DateFormatter()
    
    var numberOfDates:Int = 0
    var datesChosen: [Date] = []
    var events: [Event] = []

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCalendarView()
        calendarView.visibleDates { visibleDates in
            self.setupViewsOfCalendar(from: visibleDates)
        }
        
        calendarView.allowsMultipleSelection  = true
        calendarView.isRangeSelectionUsed = true
        
        availableDatesLabel.text = "\(numberOfDates) dates chosen"
    }
    
    //for existing events
    //    override func viewWillAppear(_ animated: Bool) {
    //        super.viewWillAppear(animated)
    //
    //            eventNameTextField.text = event.name
    //    }
    
    func setUpCalendarView() {
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
    }
    
    
    func handleCellSelected(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CalendarCell
            else { return }
        
        if cellState.isSelected {
            //selected view = circle behind text
            validCell.selectedView.isHidden = false //is not hidden
        }
        else {
            validCell.selectedView.isHidden = true //is hidden
        }
    }
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CalendarCell
            else { return }
        
        if cellState.isSelected {
            //selected view = circle behind text
            validCell.dateLabel.textColor = selectedMonthColor
        }
        else {
            if cellState.dateBelongsTo == .thisMonth {
                validCell.dateLabel.textColor = monthColor
                //cell date label color in this month
            }
            else {
                validCell.dateLabel.textColor = outsideMonthColor
                //cell date label color in indates/outdates
            }
        }
    }
    
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        
        self.formatter.dateFormat = "MMMM yyyy"
        self.monthYearLabel.text = "   \(self.formatter.string(from: date))"
        
    }

    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            let eventTableViewController = segue.destination as? EventTableViewController
            
            if identifier == "backButtonSegue" {
                print("Transitioning back to home/back")
            }
            else if identifier == "saveCloseSegue" {
                print("Transitioning back to home/save")
                
                print(eventNameTextField.text ?? "")
                var dictItem = [String]()
                
                for date in datesChosen.enumerated() {
                    dictItem.append("\(date)")
                }

                //set tableview events to events in Firebase
                
                let event = EventService.addEvent(name: eventNameTextField.text ?? "Untitled Event", creationDate: Date(), dates: dictItem)

//                eventTableViewController?.events.append(event)

                
                //issue: event cell not showing in table view
                
                //if event exists, save. if else, new event = Event(sdfaf)
            }
        }
    }
    
}

extension EventViewController: JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2017 07 01")! //current month
        let endDate = formatter.date(from: "2018 12 31")!
        
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }
    
    
    
    
}

extension EventViewController: JTAppleCalendarViewDelegate {
    
    func handleSelection(cell: JTAppleCell?, cellState: CellState) {
        let calendarCell = cell as! CalendarCell // You created the cell view if you followed the tutorial
        switch cellState.selectedPosition() {
        case .full, .left, .right:
            calendarCell.selectedView.isHidden = false
            calendarCell.selectedView.backgroundColor = UIColor.white // Or you can put what ever you like for your rounded corners, and your stand-alone selected cell
        case .middle:
            calendarCell.selectedView.isHidden = false
            calendarCell.selectedView.backgroundColor = UIColor.white // Or what ever you want for your dates that land in the middle
        default:
            calendarCell.selectedView.isHidden = true
            calendarCell.selectedView.backgroundColor = nil // Have no selection when a cell is not selected
        }
        
    }
    
    
    
    
    
    
    //display the cell
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        cell.dateLabel.text = cellState.text
        
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        handleSelection(cell: cell, cellState: cellState)
        
        
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        
        handleSelection(cell: cell, cellState: cellState)
        numberOfDates += 1
        
        if numberOfDates == 1 {
            availableDatesLabel.text = "\(numberOfDates) date chosen"
        } else {
            availableDatesLabel.text = "\(numberOfDates) dates chosen"
        }
        
        //        selected date = date in selected cell
        //        if cellstate = selected, find date
        //        append to datesChosen the selected date
        
        let dateSelected = date
        datesChosen.append(dateSelected)
        print("dates chosen array are \(datesChosen.enumerated())")
        
        
        
    }
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        handleSelection(cell: cell, cellState: cellState)
        
        numberOfDates -= 1
        
        if numberOfDates == 1 {
            availableDatesLabel.text = "\(numberOfDates) date chosen"
        } else {
            availableDatesLabel.text = "\(numberOfDates) dates chosen"
        }
        
        let dateDeselected = date
        datesChosen = datesChosen.filter { $0 != dateDeselected }
        
        print("dates chosen array are \(datesChosen.enumerated())")
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        
        formatter.dateFormat = "MMMM yyyy"
        monthYearLabel.text = "   \(formatter.string(from: date))"
    }
}

extension UIColor {
    convenience init(colorWithHexValue value: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
