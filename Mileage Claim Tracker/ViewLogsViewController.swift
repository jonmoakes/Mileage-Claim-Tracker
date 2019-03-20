//
//  ViewLogsViewController.swift
//  Mileage Claim Tracker
//
//  Created by Jonathan Oakes on 20/03/2019.
//  Copyright © 2019 Jonathan Oakes. All rights reserved.
//

import UIKit
import MessageUI

class ViewLogsViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    var logsEntry: MileageEntry!
    
    @IBOutlet var textView: UITextView!
    @IBOutlet var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.applyRoundedCorners()
        
        if let date = logsEntry.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE, dd - MM - yyy"
            let dateString = formatter.string(from: date)
            
            if (logsEntry.pencePerMile!.contains("0."))  {
                let penceString = logsEntry.pencePerMile
                let formattedString = penceString!.replacingOccurrences(of: "0.", with: "")
                
                textView.text = "Date Of Entry:\n\(dateString)\n\nMileage At Start Of Journey\n\(logsEntry.journeyStart ?? "0") Miles\n\nMileage At End Of Journey:\n\(logsEntry.journeyEnd ?? "0") Miles\n\nHow Much Are You Claiming Per Mile For This Trip?\n\(formattedString) Pence Per Mile\n\nTrip Description:\n\(logsEntry.tripDescription ?? "")\n\nTotal Mileage:\n\(logsEntry.total ?? "0") Miles\n\nAmount Claimed:\n£\(logsEntry.amountClaimed ?? "0")"
            }
        }
    }
    
    @IBAction func emailButtonTapped(_ sender: Any) {
        if MFMailComposeViewController.canSendMail()  {
            
            if  emailTextField.text == ""  {
                let alert = UIAlertController(title: "Error", message: "Please Fill In Your Email Address In The Box Provided In Order To Send An Email", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        
            if let date = logsEntry.date {
                let formatter = DateFormatter()
                formatter.dateFormat = "EEEE, dd - MM - yyy"
                let dateString = formatter.string(from: date)
                
                if (logsEntry.pencePerMile!.contains("0."))  {
                    let penceString = logsEntry.pencePerMile
                    let formattedString = penceString!.replacingOccurrences(of: "0.", with: "")
                    
                    let toRecipients = [emailTextField.text]
                    
                    let mc: MFMailComposeViewController = MFMailComposeViewController()
                    
                    mc.mailComposeDelegate = self
                    
                    mc.setToRecipients(toRecipients as? [String])
                    mc.setSubject("Car Fuel Allowance Log On \(dateString)")
                    
                    mc.setMessageBody("Here Is A Record Of Your Trip You Made For Your Records.\n\nDate Of Entry:\n\(dateString)\n\nMileage At Start Of Journey\n\(logsEntry.journeyStart ?? "0") Miles\n\nMileage At End Of Journey:\n\(logsEntry.journeyEnd ?? "0") Miles\n\nHow Much Are You Claiming Per Mile For This Trip?\n\(formattedString) Pence Per Mile\n\nTrip Description:\n\(logsEntry.tripDescription ?? "")\n\nTotal Mileage:\n\(logsEntry.total ?? "0") Miles\n\nAmount Claimed:\n£\(logsEntry.amountClaimed ?? "0")", isHTML: false)
                    
                    self.present(mc, animated: true, completion: nil)
                }
            }
        }  else {
            Alert.showNoEmailAccountFoundError(on: self)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            Alert.showEmailCancelledMessage(on: self)
            
        case MFMailComposeResult.failed.rawValue:
            Alert.showEmailFailedMessage(on: self)
            
        case MFMailComposeResult.saved.rawValue:
            Alert.showEmailSavedMessage(on: self)
            
        case MFMailComposeResult.sent.rawValue:
            Alert.showEmailSentMessage(on: self)
            
        default:
            break
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}
