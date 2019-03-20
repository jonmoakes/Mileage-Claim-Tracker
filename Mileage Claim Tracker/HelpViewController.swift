//
//  HelpViewController.swift
//  Mileage Claim Tracker
//
//  Created by Jonathan Oakes on 20/03/2019.
//  Copyright © 2019 Jonathan Oakes. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {

    @IBOutlet var closeButton: UIBarButtonItem!
    @IBOutlet var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.applyRoundedCorners()
        
        closeButton.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont(name: "Noteworthy-Bold", size: 19)!], for: UIControl.State.normal)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.textView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil
        )
    }
    
    

}
