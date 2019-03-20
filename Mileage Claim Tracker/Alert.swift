//
//  Alert.swift
//  Mileage Claim Tracker
//
//  Created by Jonathan Oakes on 19/03/2019.
//  Copyright © 2019 Jonathan Oakes. All rights reserved.
//

import Foundation
import UIKit

struct Alert {
    
    private static func showBasicAlert(on vc: UIViewController, with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async { vc.present(alert, animated: true) }
    }
    
    // Email Alerts
    static func areYouSureAlert(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "Are You Sure?", message: "")
    }
    
    static func SavedAlert(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "Saved!", message: "")
    }
    
    static func fieldAlert(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "Error", message: "Please Make Sure The 'Mileage At End Of Journey' Field Is A Greater Number Than The 'Mileage At Start Of Journey Field.'")
    }
    
    static func incompleteFieldsAlert(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "Error", message: "Please Make Sure All Of The Fields Are Filled In.")
    }
    
    static func dateErrorAlert(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "Warning", message: "The Date You Have Chosen To For This Entry Does Not Match The Date You Chose When Originally Creating The Entry.\n\nIf You Chose This Date In Error, Please Select The Date Again And Make Sure It Matches The Date You Originally Chose When Creating The Entry.\n\nIf You Wish To Create A New Entry, Tap The Back Button And Then Tap The Plus Button In The Top Right To Create A New Entry.")
    }
    
    static func pencePerMileAlert(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "Error", message: "Please Enter Your Pence Per Mile To 2 Decimal Points - Ie 0.50 For 50 Pence")
    }
    
    // Email Alerts
    static func showEmailCancelledMessage(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "Message Cancelled.", message: "Your Email Was Not Sent.")
    }
    
    static func showEmailSavedMessage(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "Draft Saved", message: "Your Message Was Saved To Your Draft Folder And Has Not Been Sent Yet.\n\nAccess The Drafts Tab In Your Apple Email App To Send The Message When You're Ready.")
    }
    
    static func showEmailFailedMessage(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "Email Saved", message: "Sorry, Your Message Did Not Send. Please Check Your Email Settings And Then Try Again.")
    }
    
    static func showEmailSentMessage(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "Thank You!", message: "Your Message Has Been Sent!")
    }
    
    static func showSuccessEmailSentMessage(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "Success!", message: "Your Message Has Been Sent!")
    }
    
    
    static func showNoEmailAccountFoundError(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "Error", message: "No Mail Account Detected. Please Make Sure The Apple Mail App Is Set Up In The 'Settings' App On Your Device.")
    }
}

