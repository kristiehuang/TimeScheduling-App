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
        
        for invitee in (BestDatesEventViewController.thisEvent?.invitees)! {
            let ref = Database.database().reference().child("users").child(invitee.key)
            
            ref.observeSingleEvent(of: .value, with: { [unowned self] (snapshot) in
                if let user = User(snapshot: snapshot) {
                    inviteeEmails.append(user.email)
                }


            })
        }
        

//        for invitee in InviteEventViewController.myInvitees {
//            inviteeEmails.append(invitee.email)
//        }
        for email in (BestDatesEventViewController.thisEvent?.emailInvitees)! {
            inviteeEmails.append(email)
        }

        
        composeVC.setBccRecipients(inviteeEmails)
        composeVC.setSubject("Invite to \(String(describing: BestDatesEventViewController.thisEvent?.name))")
        composeVC.setMessageBody("Hi! <p>I'm planning an event for us to get together sometime for \(BestDatesEventViewController.thisEvent?.name!). I'd love to know when everyone is available.</p> <br> <p>\(BestDatesEventViewController.thisEvent?.note)</p> <br> Download AirTime on the iOS App Store to input your best dates to attend.", isHTML: true)
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
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
