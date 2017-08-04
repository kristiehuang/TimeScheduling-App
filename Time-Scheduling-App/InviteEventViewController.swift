//
//  finalEventViewController.swift
//  Time-Scheduling-App
//
//  Created by Kristie Huang on 7/17/17.
//  Copyright © 2017 Kristie Huang. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase


class InviteEventViewController: UIViewController {
	
	
	@IBOutlet weak var emailTextField: UITextField!
	
	@IBAction func returnButtonTapped(_ sender: Any) {
	}
	
	
	@IBOutlet weak var eventNameLabel: UILabel!
	
	//add contacts output
	
	@IBOutlet weak var inviteesTableView: UITableView!
	
	@IBAction func unwindToInvite(_ segue: UIStoryboardSegue) {
	}
	
	let dispatchGroup = DispatchGroup()
	
	
	static var event: Event?
	//    var inviteeNames = [String]() //invitee names array
	//    static var inviteeEmails = [String]() //emails of invitee array
	
	var invitees = [String: Bool]() //
	static var myInvitees = [User]() //actual invitees array in type User
	static var emailInvitees = [String]() //just emails
	
	@IBAction func sendInvitesButtonTapped(_ sender: Any) {
		
		if InviteEventViewController.myInvitees.count == 0 && InviteEventViewController.emailInvitees.count == 0 {

			
			let alertController = UIAlertController(title: "You didn't invite anyone!", message: "Please invite at least one person", preferredStyle: .alert)
			let cancel = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
			alertController.addAction(cancel)
			
			present(alertController, animated: true)
		}
		if InviteEventViewController.myInvitees.count == 0 {
			
			let ref = Database.database().reference()
			
			let key = InviteEventViewController.event?.key!
			let inviteData = ["events/\(User.current.uid)/\(key!)/invitees/\(User.current.uid)": false, "users/\(User.current.uid)/hosting events/\(key!)/invitees/\(User.current.uid)": false]
			
			ref.updateChildValues(inviteData) { (error, _) in
				if let error = error {
					assertionFailure(error.localizedDescription)
				}
			}
			
			
			
		}
		
//		if InviteEventViewController.emailInvitees.count == 0 {
//			InviteEventViewController.emailInvitees = ["tempvalue@gmail.com"]
		
//			let alertController = UIAlertController(title: "You didn't invite anyone!", message: "Please invite at least one person through email", preferredStyle: .alert)
//			let cancel = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
//			alertController.addAction(cancel)
//			
//			present(alertController, animated: true)
//		}
		//				else {
		let alertController = UIAlertController(title: "Are you sure?", message: "Invitations will be sent to \(InviteEventViewController.myInvitees.count) of \(InviteEventViewController.myInvitees.count + InviteEventViewController.emailInvitees.count) user(s). Users invited via email can be emailed later.", preferredStyle: .alert)
		let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		alertController.addAction(cancel)
		
		let next = UIAlertAction(
		title: "Send", style: .default) { (action) in
			
			AddNoteViewController.event = InviteEventViewController.event
			
			self.saveEvent()
			self.performSegue(withIdentifier: "toAddNote", sender: nil)
		}
		
		
		alertController.addAction(next)
		present(alertController, animated: true)
		//				}
	}
	
	@IBAction func saveCloseButton(_ sender: Any) {
		print("transitioning back to home/save")
		//save invites & segue
		saveEvent()
	}
	
	
	override func viewDidLoad() {
		print("dates are \(InviteEventViewController.event?.dates ?? [])")
		
		
		eventNameLabel.text = InviteEventViewController.event?.name //printing nil
		
		//add contacts output
		
		// remove separators for empty cells
		inviteesTableView.tableFooterView = UIView()
		inviteesTableView.rowHeight = 71
		
		//dismiss keyboard
		let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
		tap.cancelsTouchesInView = false
		self.view.addGestureRecognizer(tap)
		
		self.emailTextField.delegate = self
		
		InviteEventViewController.myInvitees = []
		InviteEventViewController.emailInvitees = []

		
		super.viewDidLoad()
		
	}
	
	override func viewDidAppear(_ animated: Bool) {


		
		//also for invitee in InviteEventViewController.event?.invitees
		for invitee in InviteEventViewController.event?.invitees ?? [:] {
			dispatchGroup.enter()
			
			
			let ref = Database.database().reference().child("users").child(invitee.key)
			
			ref.observeSingleEvent(of: .value, with: { [unowned self] (snapshot) in
				if let user = User(snapshot: snapshot) {
					InviteEventViewController.myInvitees.append(user)
					
					self.inviteesTableView.reloadData()
					
					self.dispatchGroup.leave()
				}
			})
			
			
			//			})
			//go into database, append user based on key
		}
		
		
		
		
		for email in (InviteEventViewController.event?.emailInvitees ?? []) { //from inviteFriends
			dispatchGroup.enter()
			
			InviteEventViewController.emailInvitees.append(email)
			self.inviteesTableView.reloadData()
			
			self.dispatchGroup.leave()
			//go into database, append user based on key
		}
		
		
		
		
		dispatchGroup.notify(queue: .main, execute: {
			
			print("dispatch group run yay")
			self.inviteesTableView.reloadData()
			super.viewDidAppear(true)
		})
		
	}
	
	
	
	func saveEvent(){
		
		//if event already exists, SAVE to existing
		
		let eventTableViewController = EventTableViewController()
		
		UserService.events(for: User.current, completion: { (events:[Event]) in
			
			for eventz in events {
				if EventViewController.event?.key == eventz.key {
					
					
					let eventRef = Database.database().reference().child("events").child(User.current.uid).child((EventViewController.event?.key!)!)
					
					var stringUIDs = [String: Bool]()
					for user in InviteEventViewController.myInvitees {
						stringUIDs.updateValue(true, forKey: user.uid)
					}
					
					//user uid : true
					//0: user.uid
					eventRef.child("invitees").setValue(stringUIDs)
					
					eventRef.child("invitees").child("email invitees").setValue(InviteEventViewController.emailInvitees)

					
					
					
					
					eventTableViewController.tableView.reloadData()
				}
			}
		})
		
	}
	
	
	
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		if let inviteFriendsViewController = segue.destination as? InviteFriendsViewController {
			
			inviteFriendsViewController.invitees = InviteEventViewController.myInvitees
			InviteFriendsViewController.event = InviteEventViewController.event
			
			saveEvent()
		}
		
	}
	
	
}

extension InviteEventViewController: UITableViewDataSource {
	
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		var inviteeCount = InviteEventViewController.myInvitees.count
		
		for email in InviteEventViewController.emailInvitees {
			inviteeCount += 1
		}
		
		return inviteeCount
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "InviteesCell") as! InviteesCell
		
		cell.delegate = self
		
		configure(cell: cell, atIndexPath: indexPath)
		
	
		
		return cell
	}
	
	func configure(cell: InviteesCell, atIndexPath indexPath: IndexPath) {
		
		
		var inviteeCount = InviteEventViewController.myInvitees.count + InviteEventViewController.emailInvitees.count
		
		if inviteeCount > indexPath.row {
			
			if InviteEventViewController.myInvitees.count > indexPath.row {
				print(InviteEventViewController.myInvitees[indexPath.row].name)
				
				cell.inviteeNameLabel.text = InviteEventViewController.myInvitees[indexPath.row].name
				cell.inviteeEmailLabel.text = InviteEventViewController.myInvitees[indexPath.row].email
				cell.inviteeButton.isSelected = InviteEventViewController.myInvitees[indexPath.row].isInvited
			}
			else {
				cell.inviteeNameLabel.text = InviteEventViewController.emailInvitees[indexPath.row - InviteEventViewController.myInvitees.count]
				cell.inviteeEmailLabel.text = ""
				cell.inviteeButton.isSelected = true
			}
		}
		
		//        let invitee = inviteesUser[indexPath.row]
		//
		//        cell.inviteeButton.isSelected = friender.isInvited
		
	}
	
	
}
extension InviteEventViewController: InviteEventCellDelegate {
	func didTapInviteeButton(_ inviteeButton: UIButton, on cell: InviteesCell) {
		guard let indexPath = inviteesTableView.indexPath(for: cell) else { return }
		
		inviteeButton.isUserInteractionEnabled = true
		var inviteeCount = InviteEventViewController.myInvitees.count
		
		for email in InviteEventViewController.emailInvitees {
			inviteeCount += 1
		}
		
		if inviteeCount > indexPath.row {
			if InviteEventViewController.myInvitees.count > indexPath.row {
				let friender = InviteEventViewController.myInvitees[indexPath.row]
				
				
				//friendservice methods
				let dispatchReloadTable = DispatchGroup()
				dispatchReloadTable.enter()
				FriendService.setIsInviting(!friender.isInvited, InviteEventViewController.event!, fromCurrentUserTo: friender) { (success) in
					defer {
						
						inviteeButton.isUserInteractionEnabled = true
						
						if !friender.isInvited == true { //false, inviting
							cell.inviteeButton.isSelected = false
							InviteEventViewController.myInvitees.append(friender)
							print("has been invited")
							dispatchReloadTable.leave()
						}
						else if !friender.isInvited == false { //true, uninviting
							cell.inviteeButton.isSelected = true
							InviteEventViewController.myInvitees = InviteEventViewController.myInvitees.filter { $0 != friender }
							print("has been UNinvited")
							dispatchReloadTable.leave()
						}
						
					}
					
					guard success else { return }
					
					dispatchReloadTable.notify(queue: .main, execute: {
						friender.isInvited = !friender.isInvited
						self.inviteesTableView.reloadData()
					})
					
				}
			}
			else {
				let friender = InviteEventViewController.emailInvitees[indexPath.row - InviteEventViewController.myInvitees.count]
				
				inviteeButton.isUserInteractionEnabled = true
				
				cell.inviteeButton.isSelected = true
				InviteEventViewController.emailInvitees = InviteEventViewController.emailInvitees.filter { $0 != friender }
				print("has been UNinvited")
				self.inviteesTableView.reloadData()
				
			}
		}
	}
	
}

extension InviteEventViewController: UITextFieldDelegate {
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		
		if !(textField.text?.isEmpty)! {
			let correctEmail = validateEmail(field: textField)
			if correctEmail != nil {
				textField.text = ""
				
				let ref = Database.database().reference()
				let key = InviteEventViewController.event?.key!
				
				print(key!)
				
				InviteEventViewController.emailInvitees.append(correctEmail!)
				
				let eventRef = ref.child("events").child(User.current.uid).child(key!).child("invitees").child("email invitees")
				eventRef.setValue(InviteEventViewController.emailInvitees)
				
				let hostRef = ref.child("users").child(User.current.uid).child("hosting events").child(key!).child("invitees").child("email invitees")
				hostRef.setValue(InviteEventViewController.emailInvitees)
				
				for person in InviteEventViewController.myInvitees {
					
					let inviteRef = ref.child("users").child(person.uid).child("invited events").child(key!).child("invitees").child("email invitees")
					inviteRef.setValue(InviteEventViewController.emailInvitees)
					
				}
				
				inviteesTableView.reloadData()
			}
			else {
				let alertController = UIAlertController(title: "Invalid email", message: "", preferredStyle: .alert)
				let tryAgain = UIAlertAction(title: "Try again", style: .cancel, handler: nil)
				alertController.addAction(tryAgain)
				present(alertController, animated: true)
			}
		}
		
		self.view.endEditing(true)
		return false
	}
	
	
	func validateEmail(field: UITextField) -> String? {
		guard let trimmedText = field.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
			return nil
		}
		
		guard let dataDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else {
			return nil
		}
		
		let range = NSMakeRange(0, NSString(string: trimmedText).length)
		let allMatches = dataDetector.matches(in: trimmedText,
		                                      options: [],
		                                      range: range)
		
		if allMatches.count == 1,
			allMatches.first?.url?.absoluteString.contains("mailto:") == true
		{
			return trimmedText
		}
		return nil
	}
}

