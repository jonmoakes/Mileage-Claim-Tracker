//
//  ViewLogsViewController.swift
//  Mileage Claim Tracker
//
//  Created by Jonathan Oakes on 20/03/2019.
//  Copyright © 2019 Jonathan Oakes. All rights reserved.
//

import UIKit

class ViewLogsViewController: UIViewController {

    var logsEntry: MileageEntry!
    
    @IBOutlet var textView: UITextView!
    
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
                
                textView.text = "Date Of Entry:\n\(dateString)\n\nMileage At Start Of Journey\n\(logsEntry.journeyStart ?? "0") Miles\n\nMileage At End Of Journey:\n\(logsEntry.journeyEnd ?? "0") Miles\n\nHow Much Are You Claiming Per Mile For This Trip?\n\(formattedString) Pence Per Mile\n\nTrip Description:\n\(logsEntry.tripDescription ?? "")\n\nYour Total Mileage So Far Is:\n\(logsEntry.total ?? "0") Miles\n\nAmount Claimed:\n£\(logsEntry.amountClaimed ?? "0")\n\n"

            }
    
            
        }
        
        
    }
    

    

}
