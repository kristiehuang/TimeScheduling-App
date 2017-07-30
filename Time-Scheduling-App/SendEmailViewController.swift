////
////  SendEmailViewController.swift
////  Time-Scheduling-App
////
////  Created by Kristie Huang on 7/29/17.
////  Copyright © 2017 Kristie Huang. All rights reserved.
////
//
//import Foundation
//import MessageUI
//import UIKit
//
//class SendEmailViewController: UIViewController, MFMailComposeViewControllerDelegate {
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        if !MFMailComposeViewController.canSendMail() {
//            print("Mail services are not available")
//            return
//        }
//        sendEmail()
//    }
//    
//    func sendEmail() {
//        let composeVC = MFMailComposeViewController()
//        composeVC.mailComposeDelegate = self
//        // Configure the fields of the interface.
//        composeVC.setBccRecipients(InviteEventViewController.inviteeEmails)
//        composeVC.setSubject("Invite to \(String(describing: InviteEventViewController.event?.name))")
//        composeVC.setMessageBody("Hi! I'm planning an event for us to get together sometime for \(InviteEventViewController.event?.name). I'd love to know when everyone is available. \(InviteEventViewController.event?.note) Download AirTime on the iOS App Store to input your best dates to attend.", isHTML: false)
//        // Present the view controller modally.
//        self.present(composeVC, animated: true, completion: nil)
//    }
//    
//    func mailComposeController(controller: MFMailComposeViewController,
//                               didFinishWithResult result: MFMailComposeResult, error: NSError?) {
//        if result == .cancelled || result == .failed || result == .saved {
//            u
//        }
//        if result == .sent
//        // Check the result or perform other tasks.
//        // Dismiss the mail compzose view controller.
//        controller.dismiss(animated: true, completion: nil)
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//}
