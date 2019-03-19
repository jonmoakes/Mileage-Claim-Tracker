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
}

