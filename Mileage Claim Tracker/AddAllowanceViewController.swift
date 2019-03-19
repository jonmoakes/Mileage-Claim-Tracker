//
//  AddAllowanceViewController.swift
//  Mileage Claim Tracker
//
//  Created by Jonathan Oakes on 19/03/2019.
//  Copyright © 2019 Jonathan Oakes. All rights reserved.
//

import UIKit
import CoreData

class AddAllowanceViewController: UIViewController {
    
    var managedObjectContext: NSManagedObjectContext!
    var mileageEntry: MileageEntry!
    
    @IBOutlet var dateTextFiled: UITextField!
    @IBOutlet var mileageStartLabel: UILabel!
    @IBOutlet var journeyStartTextField: UITextField!
    @IBOutlet var mileageEndLabel: UILabel!
    @IBOutlet var journeyEndTextField: UITextField!
    @IBOutlet var howMuchAreYouClaimingLabel: UILabel!
    @IBOutlet var claimAmounttextField: UITextField!
    @IBOutlet var calculateMileageButton: UIButton!
    @IBOutlet var updateMileageButton: UIButton!
    @IBOutlet var mileageSoFarLabel: UILabel!
    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var youCanClaimLabel: UILabel!
    @IBOutlet var result2Label: UILabel!
    @IBOutlet var topLabel: UILabel!
    @IBOutlet var bottomLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var saveButton: UIBarButtonItem!
    
    let datePicker = UIDatePicker()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        topLabel.isHidden = true
        bottomLabel.isHidden = true
        
        createDatePicker()
        journeyStartToolbar()
        journeyEndToolbar()
        showCalculateButtonToolbar()
        
        dateTextFiled.applyRoundedCorners()
        journeyStartTextField.applyRoundedCorners()
        journeyEndTextField.applyRoundedCorners()
        claimAmounttextField.applyRoundedCorners()
        updateMileageButton.applyRoundedCorners()
        calculateMileageButton.applyRoundedCorners()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
        
        if mileageEntry != nil  {
            title = "Edit"
            
            if let date = mileageEntry.date {
                let formatter = DateFormatter()
                formatter.dateFormat = "EEEE, dd-MM-yyy"
                let dateString = formatter.string(from: date)
                dateTextFiled.text = dateString
            }
            journeyStartTextField.text = mileageEntry.journeyEnd
            journeyEndTextField.text = ""
            claimAmounttextField.text = mileageEntry.pencePerMile
            resultLabel.text = mileageEntry.total
            result2Label.text = mileageEntry.amountClaimed
            saveButton.isEnabled = false
            updateMileageButton.isHidden = false
            calculateMileageButton.isHidden = true
            imageView.alpha = 0.3
        }  else  {
            title = "Compose"
            saveButton.isEnabled = false
            mileageStartLabel.isHidden = true
            journeyStartTextField.isHidden = true
            mileageEndLabel.isHidden = true
            journeyEndTextField.isHidden = true
            calculateMileageButton.isHidden = true
            updateMileageButton.isHidden = true
            resultLabel.isHidden = true
            result2Label.isHidden = true
            mileageSoFarLabel.isHidden = true
            youCanClaimLabel.isHidden = true
            howMuchAreYouClaimingLabel.isHidden = true
            claimAmounttextField.isHidden = true
        }
        
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if dateTextFiled.text == ""   {
            Alert.fieldAlert(on: self)
        } else if mileageEntry != nil  {
            Alert.SavedAlert(on: self)
            self.updateEntry()
            self.navigationController?.popToRootViewController(animated: true)
        } else  {
            if dateTextFiled.text != ""   {
                Alert.SavedAlert(on: self)
                self.createNewMileageEntry()
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    @IBAction func calculateButtonTapped(_ sender: Any) {
        check()
    }
    
    @IBAction func updateButtonTapped(_ sender: Any) {
        if let startMileage = journeyStartTextField.text {
            if let endMileage = journeyEndTextField.text {
                let endMileageAsInt = Int(endMileage)
                let startMileageAsInt = Int(startMileage)
                
                if endMileageAsInt! <= startMileageAsInt! {
                    Alert.fieldAlert(on: self)
                } else if endMileageAsInt! > startMileageAsInt! {
                    
                    guard let currentMileage = resultLabel.text else { return }  // red label
                    guard let currentMileageAsInt = Int(currentMileage) else { return }
                    
                    guard let previousMileageAtEnd = journeyStartTextField.text else {return }
                    guard let previousMileageAtEndAsInt = Int(previousMileageAtEnd) else { return} // now the current start mileage
                    
                    guard let newMileageAtEnd = journeyEndTextField.text else { return }
                    guard let newMileageAtEndAsInt = Int(newMileageAtEnd) else { return } // now the current end mileage
                    
                    let latestMileageSum = newMileageAtEndAsInt - previousMileageAtEndAsInt
                    let updatedMileage = currentMileageAsInt + latestMileageSum // the start and end fileds
                    
                    guard let pencePerMileClaim = claimAmounttextField.text else { return }
                    guard let pencePerMileClaimAsDouble = Double(pencePerMileClaim) else { return }// get ppmile as double
                    
                    guard let previousAmountClaimed = result2Label.text else { return }
                    guard let previousAmountClaimedAsDouble = Double(previousAmountClaimed) else { return }// got previous amounc claimed
                    
                    let newMileageClaim = pencePerMileClaimAsDouble * Double(currentMileageAsInt)
                    let newUpdatedTotal = newMileageClaim + previousAmountClaimedAsDouble
                    
                  
                    let showAmountToClaimWith2DecimalPlaces = String(format: "%.2f", newUpdatedTotal)
                    
                    resultLabel.text = String(updatedMileage)
                    result2Label.text = showAmountToClaimWith2DecimalPlaces
                    //result2Label.text = "£\(showAmountToClaimWith2DecimalPlaces)"
                    saveButton.isEnabled = true
                    updateMileageButton.isEnabled = false
                    youCanClaimLabel.isHidden = false
                }
            }
        }
    }
    
    func calculateTotal() {
        if let mileageStart = journeyStartTextField.text {
            if let mileageStartAsInt = Int(mileageStart) {
                if let mileageEnd = journeyEndTextField.text {
                    let mileageEndAsInt = Int(mileageEnd)
                    let total = mileageEndAsInt! - mileageStartAsInt
                    
                    let pencePerMile = Double(claimAmounttextField.text!)
                    let mileage = String(total)
                    let amountToClaim = Double(mileage)! * pencePerMile!
                    let showAmountToClaimWith2DecimalPlaces = String(format: "%.2f", amountToClaim)
                    
                    resultLabel.text = mileage
                    result2Label.text = showAmountToClaimWith2DecimalPlaces
                }
            }
        }
    }
    
    func check() {
        if let startMileage = journeyStartTextField.text {
            if let endMileage = journeyEndTextField.text {
                let endMileageAsInt = Int(endMileage)
                let startMileageAsInt = Int(startMileage)
                if endMileageAsInt! <= startMileageAsInt! {
                    Alert.fieldAlert(on: self)
                } else if endMileageAsInt! > startMileageAsInt! {
                    calculateTotal()
                    
                    
                    mileageSoFarLabel.isHidden = false
                    resultLabel.isHidden = false
                    youCanClaimLabel.isHidden = false
                    result2Label.isHidden = false
                    imageView.alpha = 0.3
                    calculateMileageButton.isEnabled = false
                    saveButton.isEnabled = true
                }
            }
        }
    }
    
    func updateEntry()  {
        mileageEntry.journeyStart = self.journeyStartTextField.text
        mileageEntry.journeyEnd = self.journeyEndTextField.text
        mileageEntry.pencePerMile = self.claimAmounttextField.text
        mileageEntry.total = self.resultLabel.text
        mileageEntry.date = self.datePicker.date
        mileageEntry.amountClaimed = self.result2Label.text
        
        do  {
            try managedObjectContext.save()
        } catch let error as NSError  {
            print("Could Not Save The New Entry \(error.localizedDescription)")
        }
    }
    
    func createNewMileageEntry()  {
        let mileageEntryEntity = NSEntityDescription.entity(forEntityName: "MileageEntry", in: managedObjectContext)!
        let newMileageEntry = MileageEntry(entity: mileageEntryEntity, insertInto: managedObjectContext)
        
        newMileageEntry.date = self.datePicker.date
        newMileageEntry.journeyStart = self.journeyStartTextField.text
        newMileageEntry.journeyEnd = self.journeyEndTextField.text
        newMileageEntry.pencePerMile = self.claimAmounttextField.text
        newMileageEntry.total = self.resultLabel.text
        newMileageEntry.amountClaimed = self.result2Label.text
        
        do  {
            try managedObjectContext.save()
        } catch let error as NSError  {
            print("Could Not Save The New Entry \(error.localizedDescription)")
        }
    }
    
    // Start of code to create the date picker and the done button in the toolbar
    func createDatePicker()  {
        // create toolbar
        let dateToolbar = UIToolbar()
        dateToolbar.sizeToFit()
        
        // create done button for toolbar
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(datePickerViewDoneButtonPressed))
        dateToolbar.setItems([doneButton], animated: true)
        
        dateTextFiled.inputAccessoryView = dateToolbar
        dateTextFiled.inputView = datePicker
        
        // format picker for date only
        datePicker.datePickerMode = .date
    }
    
    @objc func  datePickerViewDoneButtonPressed()  {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, dd-MM-yyyy"
        
        let dateString = formatter.string(from: datePicker.date)
        
        dateTextFiled.text = "\(dateString)"
        journeyStartTextField.isHidden = false
        mileageStartLabel.isHidden = false
        imageView.alpha = 0.5
        self.view.endEditing(true)
    }
    
    func journeyStartToolbar()  {
        let journeyStartToolbar = UIToolbar()
        journeyStartToolbar.sizeToFit()
        
        let startJourneyDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(startJourneyDoneButtonPressed))
        journeyStartToolbar.setItems([startJourneyDoneButton], animated: true)
        journeyStartTextField.inputAccessoryView = journeyStartToolbar
    }
    
    @objc func  startJourneyDoneButtonPressed()  {
        if mileageEntry == nil {
            journeyEndTextField.isHidden = false
            mileageEndLabel.isHidden = false
        }
        self.view.endEditing(true)
    }
    
    func journeyEndToolbar()  {
        let journeyEndToolbar = UIToolbar()
        journeyEndToolbar.sizeToFit()
        
        let endJourneyDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(endJourneyDoneButtonPressed))
        journeyEndToolbar.setItems([endJourneyDoneButton], animated: true)
        journeyEndTextField.inputAccessoryView = journeyEndToolbar
    }
    
    @objc func  endJourneyDoneButtonPressed()  {
        if mileageEntry == nil {
            claimAmounttextField.isHidden = false
            howMuchAreYouClaimingLabel.isHidden = false
        }
        self.view.endEditing(true)
    }
 
    func showCalculateButtonToolbar()  {
        let calculateButtonToolbar = UIToolbar()
        calculateButtonToolbar.sizeToFit()
        
        let showCalculateButtonDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(showCalculateButtonDoneButtonPressed))
        calculateButtonToolbar.setItems([showCalculateButtonDoneButton], animated: true)
        claimAmounttextField.inputAccessoryView = calculateButtonToolbar
    }
    
    @objc func  showCalculateButtonDoneButtonPressed()  {
        if mileageEntry == nil {
            calculateMileageButton.isHidden = false
        } else if mileageEntry != nil {
            calculateMileageButton.isHidden = true
        }
        self.view.endEditing(true)
    }
 
    
}

extension UITextField {
    func applyRoundedCorners() {
        self.layer.cornerRadius = 10.0
        self.layer.borderColor = UIColor(white: 0, alpha: 0.90).cgColor
        self.layer.borderWidth = 1.0
        self.layer.masksToBounds = true
    }
}

extension UIButton {
    func applyRoundedCorners() {
        self.layer.cornerRadius = 15.0
        self.layer.borderColor = UIColor(white: 0, alpha: 0.90).cgColor
        self.layer.borderWidth = 1.0
        self.layer.masksToBounds = true
    }
}
