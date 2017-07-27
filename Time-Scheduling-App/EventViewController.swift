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
import FirebaseDatabase
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
    
    @IBAction func unwindToPage1(_ segue: UIStoryboardSegue) {
        
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
    static let dispatchGroup = DispatchGroup()
    
    
    static var event: Event?
    static var invitees: [String: Bool] = [User.current.uid : true]
    
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
        
        //        let dispatchGroup = DispatchGroup()
        //        var existingDates = [Date]()
        //        dispatchGroup.enter()
        ////        UserService.events(for: User.current, completion: { (events:[Event]) in
        ////            //for each event in events called from user
        ////            for eventz in events {
        ////                if EventViewController.event?.key == eventz.key {
        ////                    for (myDate) in eventz.dates {
        ////
        ////                        let dateFormatter = DateFormatter()
        ////                        dateFormatter.dateFormat = myDate //Your date format
        //////                        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone
        ////                        let dateDate = dateFormatter.date(from: myDate) //according to date format your date string
        ////
        ////                        existingDates.append(dateDate!)
        ////                    }
        ////
        ////                }
        ////            }
        //            dispatchGroup.leave()
        ////        })
        //        dispatchGroup.notify(queue: .main) {
        ////            self.calendarView.selectDates(existingDates)
        //            self.calendarView.selectDates([currentDate])
        //
        //        }
        
        
        calendarView.allowsMultipleSelection  = true
        calendarView.isRangeSelectionUsed = true
        
        availableDatesLabel.text = "\(numberOfDates) dates chosen | Press & hold to select a range"
        
        //longpress to select range
        calendarView.allowsMultipleSelection = true
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(didStartRangeSelecting(gesture:)))
        gesture.minimumPressDuration = 0.5
        calendarView.addGestureRecognizer(gesture)
        calendarView.isRangeSelectionUsed = true
        
        //dismiss keyboard
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    //    for existing events
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let event = EventViewController.event {
            eventNameTextField.text = event.name
            //show selected event.dates
        } else {
            eventNameTextField.text = "Untitled Event"
        }
    }
    
    func setUpCalendarView() {
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
    }
    
    
    
    func handleCellSelected(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CalendarCell
            else { return }
        
//        if cellState.dateBelongsTo != .thisMonth {
//            validCell.isUserInteractionEnabled = false
//        }
        
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
    
    private func currentTopViewController() -> UIViewController {
        var topVC: UIViewController? = UIApplication.shared.delegate?.window??.rootViewController
        while ((topVC?.presentedViewController) != nil) {
            topVC = topVC?.presentedViewController
        }
        return topVC!
    }
    
    private func showError(bigErrorMsg: String, smallErrorMsg: String){
        let currentTopVC: UIViewController? = self.currentTopViewController()
        
        let alertController = UIAlertController(title: "\(bigErrorMsg)", message:
            "\(smallErrorMsg)", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        
        currentTopVC?.present(alertController, animated: true, completion: nil)
        
    }
    
    func newEvent(){
        
        //if event already exists, SAVE to existing
        
        let eventTableViewController = EventTableViewController()
        
        if (self.eventNameTextField.text?.isEmpty)! {
            eventNameTextField.text = "Untitled Event"
        }
        EventViewController.event?.name = self.eventNameTextField.text ?? "Untitled Event"
        
        
        print(" event name is \(EventViewController.event?.name ?? "Untitled Event")")
        var isFound = false
        UserService.events(for: User.current, completion: { (events:[Event]) in
            
            //for each event in events called from user
            for eventz in events {
                if EventViewController.event?.key == eventz.key {
                    
                    
                    
                    var datesArr = [String]()
                    for date in EventViewController.datesChosen.enumerated() {
                        let justDate = date.1
                        datesArr.append("\(justDate)")
                    }
                    print("dates chosen: \(EventViewController.datesChosen)")
                    print("dates array: \(datesArr)")
                    
                    if datesArr.isEmpty {
                        self.showError(bigErrorMsg: "Enter a date!", smallErrorMsg: "Please.")
                        //unwind to page 1, don't save
                        return
                    }
                    let eventRef = Database.database().reference().child("events").child(User.current.uid).child((EventViewController.event?.key!)!)
                    eventRef.child("name").setValue(EventViewController.event?.name ?? "Untitled Event")
                    
                    eventRef.child("dates").setValue(datesArr)
                    eventTableViewController.tableView.reloadData()
                    isFound = true
                    print("isfound is \(isFound)")
                    EventViewController.dispatchGroup.leave()
                    
                }
            }
            
            if isFound == false {
                print("new event")
                
                var datesArr = [String]()
                
                print("dates chosen is \(EventViewController.datesChosen)")
                
                //changing type date to type string
                for date in EventViewController.datesChosen.enumerated() {
                    let justDate = date.1
                    datesArr.append("\(justDate)")
                }
                
                
                print("dates datesarr is \(datesArr)")
                if datesArr.isEmpty {
                    self.showError(bigErrorMsg: "Enter a date!", smallErrorMsg: "Please.")
                    //unwind, don't save
                    return
                }
                //add event to database
                EventViewController.event = EventService.addEvent(name: EventViewController.event!.name!, invitees: EventViewController.invitees, creationDate: (EventViewController.event?.creationDate)!, dates: datesArr, note: "")
                
                //                UserService.events(for: User.current) { (events) in
                //                    events = eventTableViewController.displayedEvents
                //                    eventTableViewController.tableView.reloadData()
                //                    self.viewWillAppear(true)
                //                }
                //                eventTableViewController.tableView.reloadData()
                
                EventViewController.dispatchGroup.leave()
                print("dispatch group run")
            }
            
        })
        
    }
    
    
    static func countDates() {
        var counts: [Date: Int] = [:]
        var array: [Int] = []
        for date in datesChosen {
            counts[date] = (counts[date] ?? 0) + 1
        }
        //sort array by count value, then display only top three
        print("counts are \(counts)")  // "[BAR: 1, FOOBAR: 1, FOO: 2]"
        
        for (key, value) in counts {
            print("\(value) of people prefer the \(key) date")
            array.append(value)
            //value is int
            
            for var item in array.sorted() {
                let eventViewController = EventViewController()
                item = value
                eventViewController.newOrderedDict[key] = item
                print("THIS IS NEW ORDERED DICT \(eventViewController.newOrderedDict)")
            }
        }
        
    }
    
    
    
    //longpress gesture func!!
    func didStartRangeSelecting(gesture: UILongPressGestureRecognizer) {
        var rangeSelectedDates: [Date] = []
        
        let point = gesture.location(in: gesture.view!)
        rangeSelectedDates = calendarView.selectedDates
        
        
        if let cellState = calendarView.cellStatus(at: point) {
            let date = cellState.date
            if !rangeSelectedDates.contains(date) {
                print(rangeSelectedDates.first)
                let dateRange = calendarView.generateDateRange(from: rangeSelectedDates.first ?? date, to: date)
                for aDate in dateRange {
                    if !rangeSelectedDates.contains(aDate) {
                        rangeSelectedDates.append(aDate)
                    }
                }
                calendarView.selectDates(from: rangeSelectedDates.first!, to: date, keepSelectionIfMultiSelectionAllowed: true)
            } else {
                let indexOfNewlySelectedDate = rangeSelectedDates.index(of: date)! + 1
                let lastIndex = rangeSelectedDates.endIndex
                let calendar = Calendar(identifier: .gregorian)
                let followingDay = calendar.date(byAdding: .day, value: 1, to: date)!
                calendarView.selectDates(from: followingDay, to: rangeSelectedDates.last!, keepSelectionIfMultiSelectionAllowed: false)
                rangeSelectedDates.removeSubrange(indexOfNewlySelectedDate..<lastIndex)
            }
        }
        
        if gesture.state == .ended {
            rangeSelectedDates.removeAll()
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let identifier = segue.identifier {
            if identifier == "backButtonSegue" {
                print("Transitioning back to home/back")
            }
            else if identifier == "nextSegue" {
                print("Transitioning to next & save")
                
                EventViewController.dispatchGroup.enter()
                newEvent()
                EventViewController.dispatchGroup.notify(queue: .main, execute: {
                    EventViewController.countDates()
                    
                    
                    let inviteEventViewController = segue.destination as! InviteEventViewController
                    InviteEventViewController.event = EventViewController.event
                    inviteEventViewController.eventNameLabel.text = EventViewController.event?.name
                    
                    
                })
                
            }
                
            else if identifier == "saveCloseSegue" {
                print("Transitioning back to home/save")
                
                //dateschosen is dates form
                //datesarr is string form (to put into firebase)
                
                //merge all user's Counts dictionaries = mergedCounts
                //used mergedCounts instead
                //create users. add users to indiv events.
                
                EventViewController.dispatchGroup.enter()
                newEvent()
                EventViewController.dispatchGroup.notify(queue: .main, execute: {
                    EventViewController.countDates()
                    
                })
            }
            
        }
    }
}





extension EventViewController: JTAppleCalendarViewDataSource {
    
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

extension EventViewController: JTAppleCalendarViewDelegate {
    
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
        
        //read exisitng dates
        //for date in existing dates
        
        //let validCell = cell of date
        //cellState.isSelected = true
        //validCell.selectedView.isHidden = false
        //if date in eventz.date, set cellState.isSelected = true
//        if cellState.dateBelongsTo != .thisMonth {
//            cell?.isUserInteractionEnabled = false
//        }
        
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        
        handleSelection(cell: cell, cellState: cellState)
        numberOfDates += 1
        
        if numberOfDates == 1 {
            availableDatesLabel.text = "\(numberOfDates) date chosen"
        } else {
            availableDatesLabel.text = "\(numberOfDates) dates chosen"
        }
        
        
        
        EventViewController.datesChosen.append(date)
        print("dates chosen array are \(EventViewController.datesChosen.enumerated())")
        
        
        
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
        EventViewController.datesChosen = EventViewController.datesChosen.filter { $0 != dateDeselected }
        
        print("dates chosen array are \(EventViewController.datesChosen.enumerated())")
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        
        dateFormatter.dateFormat = "MMMM yyyy"
        monthYearLabel.text = "   \(dateFormatter.string(from: date))"
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
