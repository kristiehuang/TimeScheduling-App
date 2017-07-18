//
//  EditResponseViewController.swift
//  Time-Scheduling-App
//
//  Created by Kristie Huang on 7/18/17.
//  Copyright © 2017 Kristie Huang. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase
import JTAppleCalendar

class EditResponseViewController: UIViewController {
    //event page
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var monthYearLabel: UILabel!
    @IBOutlet weak var eventNameTextField: UILabel!
    @IBOutlet weak var invitedAsLabel: UILabel!
    @IBOutlet weak var availableDatesLabel: UILabel!
    
    @IBAction func SaveButtonTapped(_ sender: Any) {
    }
    
    
    
    let outsideMonthColor = UIColor(colorWithHexValue: 0x7FAEE7) //cell date label color in indates/outdates
    let monthColor = UIColor.white //cell date label color in this month
    let selectedMonthColor = UIColor(colorWithHexValue: 0xA3C9F6) //color of selected date label text
    let currentDateSelectedViewColor = UIColor(colorWithHexValue: 0x7FAEE7)
    
    //    let event = Event(name: "", creationDate: Date(), host: User.current)
    
    let dateFormatter = DateFormatter()
    
    var numberOfDates:Int = 0
    static var datesChosen: [Date] = []
    var events: [Event] = []
    
    var newOrderedDict = NSMutableDictionary()
    
    
    static var event: Event?
    
    static func getEvent () -> Event {
        return event!
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCalendarView()
        calendarView.visibleDates { visibleDates in
            self.setupViewsOfCalendar(from: visibleDates)
        }
        let currentDate = Date()
        calendarView.scrollToDate(currentDate)
        calendarView.allowsMultipleSelection  = true
        calendarView.isRangeSelectionUsed = true
        
        availableDatesLabel.text = "\(numberOfDates) dates chosen"
        invitedAsLabel.text = "Invited as: \(User.current.name)"
        

        //dismiss keyboard
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    //    for existing events
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let event = EditResponseViewController.event {
            eventNameTextField.text = event.name
        } else {
            eventNameTextField.text = ""
        }
    }
    
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
        
        self.dateFormatter.dateFormat = "MMMM yyyy"
        self.monthYearLabel.text = "   \(self.dateFormatter.string(from: date))"
        
    }
    
    private func showError(bigErrorMsg: String, smallErrorMsg: String){
        let alertController = UIAlertController(title: "\(bigErrorMsg)", message:
            "\(smallErrorMsg)", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func newEvent(){
        //if event already exists, SAVE to existing
        
        if let event = EditResponseViewController.event {
            let eventTableViewController = EventTableViewController()
            
            event.name = self.eventNameTextField.text ?? ""
            
            print(event.name ?? "")
            var isFound = false
            UserService.events(for: User.current, completion: { (events:[Event]) in
                
                for eventz in events {
                    if event.key == eventz.key {
                        
                        var datesArr = [String]()
                        for date in EditResponseViewController.datesChosen.enumerated() {
                            datesArr.append("\(date)")
                        }
                        print("dates chosen: \(EditResponseViewController.datesChosen)")
                        print("dates array: \(datesArr)")
                        
                        if datesArr.isEmpty {
                            self.showError(bigErrorMsg: "Enter a date!", smallErrorMsg: "Please.")
                            return
                        }
                        
                        
                        let eventRef = Database.database().reference().child("events").child(User.current.uid).child(event.key!)
                        eventRef.child("name").setValue(event.name)
                        eventRef.child("dates").setValue(datesArr)
                        eventTableViewController.tableView.reloadData()
                        isFound = true
                        print(isFound)
                        
                    }
                    
                }
                
                if isFound == false {
                    print(isFound)
                    print("new event")
                    print(self.eventNameTextField.text ?? "")
                    
                    var datesArr = [String]()
                    for date in EditResponseViewController.datesChosen.enumerated() {
                        datesArr.append("\(date)")
                    }
                    print("dates chosen: \(EditResponseViewController.datesChosen)")
                    print("dates array: \(datesArr)")
                    
                    if datesArr.isEmpty {
                        self.showError(bigErrorMsg: "Enter a date!", smallErrorMsg: "Please.")
                        return
                    }
                    
                    EventService.addEvent(name: event.name!, creationDate: event.creationDate, dates: datesArr)
                    
                    UserService.events(for: User.current) { (events) in
                        //5
                        eventTableViewController.events = events
                        eventTableViewController.tableView.reloadData()
                        self.viewWillAppear(true)
                    }
                    
                    eventTableViewController.tableView.reloadData()
                }
                
            })
            
            
            
            
            
        }
    }
    
    
    static func countDates() {
        var counts: [Date: Int] = [:]
        var array: [Int] = []
        for date in datesChosen {
            counts[date] = (counts[date] ?? 0) + 1
        }
        //sort array by count value, then display only top three
        print(counts)  // "[BAR: 1, FOOBAR: 1, FOO: 2]"
        
        for (key, value) in counts {
            print("\(value) of people prefer the \(key) date")
            array.append(value)
            //value is int
            
            for var item in array.sorted() {
                let editResponseViewController = EditResponseViewController()
                item = value
                editResponseViewController.newOrderedDict[key] = item
                print("THIS IS NEW ORDERED DICT \(editResponseViewController.newOrderedDict)")
            }
        }
        
    }
    
      override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let identifier = segue.identifier {
            if identifier == "backButtonSegue" {
                print("Transitioning back to home/back")
            }
            else if identifier == "nextSegue" {
                print("Transitioning to next & save")
                newEvent()
                EditResponseViewController.countDates()
                
                
                //                if let bestDatesEventViewController = segue.destination as? BestDatesEventViewController {
                //                    print(self.newOrderedDict)
                //                    bestDatesEventViewController.orderedDict = newOrderedDict as! [Date : Int]
                //                }
            }
                
            else if identifier == "saveCloseSegue" {
                newEvent()
                print("Transitioning back to home/save")
                
                //dateschosen is dates form
                //datesarr is string form (to put into firebase)
                
                //merge all user's Counts dictionaries = mergedCounts
                //used mergedCounts instead
                //create users. add users to indiv events.
                
                EditResponseViewController.countDates()
                
            }
            
        }
    }
}





extension EditResponseViewController: JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        
        //        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        //        dateFormatter.dateFormat = "MMM dd, yyyy, h:mm a"
        dateFormatter.dateFormat = "MMM dd, yyyy, h:mm a"
        
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Calendar.current.locale
        dateFormatter.dateStyle = .medium
        
        let startDate = dateFormatter.date(from: "Jan 01, 2017")! //current month
        let endDate = dateFormatter.date(from: "Dec 31, 2018")!
        
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }
    
    
    
    
}

extension EditResponseViewController: JTAppleCalendarViewDelegate {
    
    func handleSelection(cell: JTAppleCell?, cellState: CellState) {
        
        let calendarCell = cell as! CalendarCell // You created the cell view if you followed the tutorial
        switch cellState.selectedPosition() {
        case .full, .left, .right:
            calendarCell.selectedView.isHidden = false
            calendarCell.selectedView.backgroundColor = UIColor.white // Or you can put what ever you like for your rounded corners, and your stand-alone selected cell
            calendarCell.isSelected = true
        case .middle:
            calendarCell.selectedView.isHidden = false
            calendarCell.selectedView.backgroundColor = UIColor.white // Or what ever you want for your dates that land in the middle
            calendarCell.isSelected = true
            
        default:
            calendarCell.selectedView.isHidden = true
            calendarCell.selectedView.backgroundColor = nil // Have no selection when a cell is not selected
            calendarCell.isSelected = false
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
        
        let dateSelected = date
        EditResponseViewController.datesChosen.append(dateSelected)
        print("dates chosen array are \(EditResponseViewController.datesChosen.enumerated())")
        
        
        
        
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
        EditResponseViewController.datesChosen = EditResponseViewController.datesChosen.filter { $0 != dateDeselected }
        
        print("dates chosen array are \(EditResponseViewController.datesChosen.enumerated())")
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        
        dateFormatter.dateFormat = "MMMM yyyy"
        monthYearLabel.text = "   \(dateFormatter.string(from: date))"
    }
}
