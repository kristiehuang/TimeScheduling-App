//
//  SendEmailViewController.swift
//  Time-Scheduling-App
//
//  Created by Kristie Huang on 7/29/17.
//  Copyright © 2017 Kristie Huang. All rights reserved.
//

import Foundation
import MessageUI
import UIKit
import FirebaseDatabase

class SendEmailViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    var bestDate: String = ""
    static var finalInvite = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
        sendEmail()
    }
    
    
    func sendEmail() {
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        // Configure the fields of the interface.
        
        var inviteeEmails = [String]()
        
        let dispatchGroup = DispatchGroup()
        for invitee in (BestDatesEventViewController.thisEvent?.invitees)! {
            let ref = Database.database().reference().child("users").child(invitee.key)
            
            dispatchGroup.enter()
            ref.observeSingleEvent(of: .value, with: { [unowned self] (snapshot) in
                if let user = User(snapshot: snapshot) {
                    inviteeEmails.append(user.email)
                    dispatchGroup.leave()
                }
                
                
            })
        }
        let emailinvite = BestDatesEventViewController.thisEvent?.invitees?["email invitees"] ?? [""]
        print(emailinvite)
        let emailzz = emailinvite as! [String]
        
        if emailzz == [""] {
            print("no email invitees invited")
        }
        else {
            for email in emailzz {
                inviteeEmails.append(email)
            }
        }
        
        let eventName = (BestDatesEventViewController.thisEvent?.name)!
        let eventNote = (BestDatesEventViewController.thisEvent?.note)!
        
        dispatchGroup.notify(queue: .main, execute: {
            
            if SendEmailViewController.finalInvite == true {
                composeVC.setToRecipients(inviteeEmails)
                composeVC.setSubject("Invite to \(eventName)")
                composeVC.setMessageBody("Hi! <p>You're invited to \(eventName). The best date for everyone \(self.bestDate), so let's meet then.</p><p>\(eventNote)</p> <p>P.S. I used AirTime, available on the iOS App Store to gather everyone's most convenient dates. I hope I'll see you there!</p>", isHTML: true)
                // Present the view controller modally.
                self.present(composeVC, animated: true, completion: nil)
            }
            else {
                composeVC.setToRecipients(inviteeEmails)
                composeVC.setSubject("What time are you available to \(eventName)")
                composeVC.setMessageBody("Hi! <p>I'm planning an event for us to get together sometime for \(eventName). I'd love to know when everyone is available.</p> <br> <p>\(eventNote)</p> <p>Download AirTime on the iOS App Store to input your best dates to attend. Create an account with this email to view your invite.</p>", isHTML: true)
                // Present the view controller modally.
                self.present(composeVC, animated: true, completion: nil)
            }
        })
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        if result == .cancelled || result == .failed || result == .saved {
            performSegue(withIdentifier: "unwindToBestDates", sender: nil)
        }
        if result == .sent {
            performSegue(withIdentifier: "unwindToHome", sender: nil)
            let notification = UIAlertController(title: "Email sent", message: "", preferredStyle: .alert)
            present(notification, animated: true)
            
            
        }
        // Check the result or perform other tasks.
        // Dismiss the mail compzose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
