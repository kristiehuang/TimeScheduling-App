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
        print("Transitioning back to home/save")

        
        dispatchGroup1.enter()
        mergeDates()
        dispatchGroup1.notify(queue: .main, execute: {
            BestDatesEventViewController.countDates()
            
        })
    }
    
    
    
    let outsideMonthColor = UIColor(colorWithHexValue: 0x7FAEE7) //cell date label color in indates/outdates
    
    let monthColor = UIColor.white //cell date label color in this month
    let selectedMonthColor = UIColor.white //color of selected date label text

    
    let inviteSelectedViewColor = UIColor(colorWithHexValue: 0xFFC55A) //color of invite selected view, orange
    let selectedViewColor = UIColor(colorWithHexValue: 0xBCD8F7) //color of invite selected view, light white
//    let selectedViewColor = UIColor.white //color of invite selected view, light white


//    let currentDateSelectedViewColor = UIColor(colorWithHexValue: 0x7FAEE7)
    
    //    let event = Event(name: "", creationDate: Date(), host: User.current)
    
    let dateFormatter = DateFormatter()
    
    var numberOfDates:Int = 0
    var datesChosen: [String] = []
    var events: [Event] = []
    
    var newOrderedDict = NSMutableDictionary()
    let dispatchGroup1 = DispatchGroup()
    
    
    static var event: Event?
    
    static func getEvent () -> Event {
        return event!
    }
    
    let dispatchGroup = DispatchGroup()
    var existingDates = [String]()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCalendarView()

        calendarView.visibleDates { visibleDates in
            self.setupViewsOfCalendar(from: visibleDates)
        }
        
        
        dispatchGroup.enter()
        
        UserService.readInvitedEvents(for: User.current, completion: { (events:[Event]) in
            //for each event in events called from user
            for eventz in events {
                if EditResponseViewController.event?.key == eventz.key {
                    
                    //for NOW, all dates in database. not just host's
//                    self.existingDates = []
                    for (myDate) in eventz.dates {
                        self.existingDates.append(myDate)
                    }
                }
            }
            self.dispatchGroup.leave()
        })
        
        calendarView.allowsMultipleSelection  = true
        calendarView.isRangeSelectionUsed = true
        
        self.availableDatesLabel.text = "\(self.numberOfDates) dates chosen | Press & hold to select a range"
        self.invitedAsLabel.text = "Invited as: \(User.current.name)"
        
        //longpress to select range
        calendarView.allowsMultipleSelection = true
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(self.didStartRangeSelecting(gesture:)))
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
        
        
        let currentDate = Date()
        calendarView.scrollToDate(currentDate)
        
        if let event = EditResponseViewController.event {
            eventNameTextField.text = event.name
        } else {
            eventNameTextField.text = "Untitled Event"
        }
    }
    
    func setUpCalendarView() {
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
    }
    
    
    func handleCellSelected(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? InviteCalendarCell
            else { return }
        
        if cellState.isSelected {
            //selected view = circle behind text
//            validCell.inviteSelectedView.isHidden = false //is not hidden
            validCell.selectedView.isHidden = false
            validCell.selectedView.backgroundColor = inviteSelectedViewColor
            
        }
        else {
            validCell.selectedView.isHidden = true //is hidden
            
        }
    }
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? InviteCalendarCell
            else { return }
        
//        if cellState.isSelected {
//            //selected view = circle behind text
//            validCell.dateLabel.textColor = selectedMonthColor
//        }
//        else {
//            if cellState.dateBelongsTo == .thisMonth {
//                validCell.dateLabel.textColor = monthColor
//                //cell date label color in this month
//            }
//            else {
//                validCell.dateLabel.textColor = outsideMonthColor
//                //cell date label color in indates/outdates
//            }
//        }

            if cellState.dateBelongsTo == .thisMonth {
                if cellState.isSelected {
                    validCell.dateLabel.textColor = selectedMonthColor
                }
                else {
                    validCell.dateLabel.textColor = monthColor
                }
            }
            else {
//                validCell.isUserInteractionEnabled = false
                validCell.dateLabel.textColor = outsideMonthColor
                //cell date label color in indates/outdates
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
            "\(smallErrorMsg)", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        
        currentTopVC?.present(alertController, animated: true, completion: nil)
        
    }
    
    func mergeDates(){
        //MERGE DATES to existing
        
        let eventTableViewController = EventTableViewController()
        
        if (self.eventNameTextField.text?.isEmpty)! {
            eventNameTextField.text = "Untitled Event"
        }
        EditResponseViewController.event?.name = self.eventNameTextField.text ?? "Untitled Event"
        
        
        print(" event name is \(EditResponseViewController.event?.name ?? "Untitled Event")")
        UserService.readInvitedEvents(for: User.current, completion: { (events:[Event]) in
            
            //for each event in INVITED events called from user
            for eventz in events {
                
                if EditResponseViewController.event?.key == eventz.key {
                    
                    var datesArr = [String]()
                    for date in self.datesChosen.enumerated() {
                        let justDate = date.1
                        
                        datesArr.append(justDate)
                    }
                    print("dates chosen: \(self.datesChosen)")
                    print("dates array: \(datesArr)")
                    datesArr = eventz.dates + datesArr
                    //change datesArr to existing dates + datesArr, then update
                    print("dates array after adding: \(datesArr)")


                    
                    if datesArr.isEmpty {
                        self.showError(bigErrorMsg: "Enter a date!", smallErrorMsg: "Please.")
                        //unwind to page 1, don't save
                        return
                    }
                    
                    let eventRef = Database.database().reference().child("events").child(eventz.host).child((EditResponseViewController.event?.key!)!)
                    eventRef.child("dates").setValue(datesArr)
                    
                    let hostRef = Database.database().reference().child("users").child(eventz.host).child("hosting events").child((EditResponseViewController.event?.key!)!)
                    hostRef.child("dates").setValue(datesArr)
                    
                    let inviteRef = Database.database().reference().child("users").child(User.current.uid).child("invited events").child((EditResponseViewController.event?.key!)!)
                    inviteRef.child("dates").setValue(datesArr)
                    
                    eventTableViewController.tableView.reloadData()
                    print("\(User.current.name) added dates")
                    
                    datesArr = []
                    self.datesChosen = []
                }

            }
            self.dispatchGroup1.leave()
            print("dispatch group run")
        })
        
    }
    
    
    //longpress gesture func!!
    func didStartRangeSelecting(gesture: UILongPressGestureRecognizer) {
        
        var rangeSelectedDates: [Date] = []

        let point = gesture.location(in: gesture.view!)
        rangeSelectedDates = calendarView.selectedDates
        if let cellState = calendarView.cellStatus(at: point) {
            let date = cellState.date
            if !rangeSelectedDates.contains(date) {
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
                print("Transitioning back")
            }

            
        }
    }
}





extension EditResponseViewController: JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
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
        
        
        let calendarCell = cell as! InviteCalendarCell // You created the cell view if you followed the tutorial

        switch cellState.selectedPosition() {
        case .full, .left, .right:
//            calendarCell.inviteSelectedView.isHidden = false
            
            calendarCell.selectedView.isHidden = false
            calendarCell.selectedView.backgroundColor = inviteSelectedViewColor

//            calendarCell.inviteSelectedView.backgroundColor = self.inviteSelectedViewColor
//            calendarCell.inviteSelectedView.backgroundColor = UIColor.white

//            calendarCell.isHidden = false
//            calendarCell.backgroundColor = self.inviteSelectedViewColor
            calendarCell.isSelected = true
        case .middle:
            calendarCell.selectedView.isHidden = false
            calendarCell.selectedView.backgroundColor = inviteSelectedViewColor // Or what ever you want for your dates that land in the middle
            calendarCell.isSelected = true
            
        default:
            calendarCell.inviteSelectedView.isHidden = true
            calendarCell.inviteSelectedView.backgroundColor = nil // Have no selection when a cell is not selected
            
            calendarCell.selectedView.isHidden = true
            calendarCell.selectedView.backgroundColor = nil
            
            calendarCell.isSelected = false
        }
        
    }
    


    
    //display the cell
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! InviteCalendarCell
        cell.dateLabel.text = cellState.text
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd hh:mm:ss Z"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
        
        let formatDate: Date? = dateFormatterGet.date(from: "\(date)")
        let newDate = dateFormatter.string(from: formatDate!)
        
        
        dispatchGroup.notify(queue: .main) {
            for myDate in self.existingDates {
                if myDate == newDate {
                    print("array of existing dates \(self.existingDates)")
                    cell.isSelected = true
                    
                    
                    cell.selectedView.isHidden = false
//                    cell.selectedView.isUserInteractionEnabled = false
                    cell.selectedView.backgroundColor = self.selectedViewColor
                    cell.dateLabel.textColor = self.selectedMonthColor
                    
                    self.datesChosen.append(myDate)
                    
                    break
                }
                else {
                    self.handleCellSelected(view: cell, cellState: cellState)
                    self.handleCellTextColor(view: cell, cellState: cellState)
                    self.handleSelection(cell: cell, cellState: cellState)
                }
                
            }
            if self.existingDates.isEmpty {
                self.handleCellSelected(view: cell, cellState: cellState)
                self.handleCellTextColor(view: cell, cellState: cellState)
                self.handleSelection(cell: cell, cellState: cellState)
            }
        
        }
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
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd hh:mm:ss Z"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
        
        let formatDate: Date? = dateFormatterGet.date(from: "\(dateSelected)")
        print(dateFormatter.string(from: formatDate!))
        
        
        self.datesChosen.append(dateFormatter.string(from: formatDate!))
        
        print("dates chosen array are \(self.datesChosen.enumerated())")
        
        
        
        
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
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd hh:mm:ss Z"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
        
        let formatDate: Date? = dateFormatterGet.date(from: "\(dateDeselected)")
        print(dateFormatter.string(from: formatDate!))
        
        datesChosen = datesChosen.filter { $0 != dateFormatter.string(from: formatDate!) }
        
        print("dates chosen array are \(datesChosen.enumerated())")
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        
        dateFormatter.dateFormat = "MMMM yyyy"
        monthYearLabel.text = "   \(dateFormatter.string(from: date))"
    }
}
