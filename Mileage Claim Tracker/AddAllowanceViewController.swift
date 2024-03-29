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
    @IBOutlet var tripDescriptionLabel: UILabel!
    @IBOutlet var tripDescriptionTextField: UITextField!
    @IBOutlet var calculateMileageButton: UIButton!
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
        createJourneyStartToolbar()
        createJourneyEndToolbar()
        createPencePerMileToolbar()
        showCalculateButtonToolbar()
        
        dateTextFiled.applyRoundedCorners()
        journeyStartTextField.applyRoundedCorners()
        journeyEndTextField.applyRoundedCorners()
        claimAmounttextField.applyRoundedCorners()
        tripDescriptionTextField.applyRoundedCorners()
        calculateMileageButton.applyRoundedCorners()
        
        saveButton.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont(name: "Noteworthy-Bold", size: 19)!], for: UIControl.State.disabled)
        
        saveButton.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont(name: "Noteworthy-Bold", size: 19)!], for: UIControl.State.normal)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
        
        if mileageEntry != nil  {
            title = "Edit"
            
            dateTextFiled.text = ""
            journeyStartTextField.text = ""
            journeyEndTextField.text = ""
            claimAmounttextField.text = ""
            tripDescriptionTextField.text = ""
            calculateMileageButton.isEnabled = false
            resultLabel.text = mileageEntry.total
            result2Label.text = mileageEntry.amountClaimed
            saveButton.isEnabled = false
            imageView.alpha = 0.3
        }  else  {
            title = "Compose"
            saveButton.isEnabled = false
            mileageStartLabel.isHidden = true
            journeyStartTextField.isHidden = true
            mileageEndLabel.isHidden = true
            journeyEndTextField.isHidden = true
            tripDescriptionLabel.isHidden = true
            tripDescriptionTextField.isHidden = true
            calculateMileageButton.isHidden = true
            resultLabel.isHidden = true
            result2Label.isHidden = true
            mileageSoFarLabel.isHidden = true
            youCanClaimLabel.isHidden = true
            howMuchAreYouClaimingLabel.isHidden = true
            claimAmounttextField.isHidden = true
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if mileageEntry != nil  {
            Alert.SavedAlert(on: self)
            self.updateEntry()
            self.navigationController?.popToRootViewController(animated: true)
        } else  {
            Alert.SavedAlert(on: self)
            self.createNewMileageEntry()
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func calculateButtonTapped(_ sender: Any) {
        
        if calculateMileageButton.title(for: .normal) == "Tap To Calculate" {
            guard let startMileage = journeyStartTextField.text else { return }
            guard let startMileageAsDouble = Double(startMileage) else { return }
            
            guard let endMileage = journeyEndTextField.text else { return }
            guard let endMileageAsDouble = Double(endMileage) else { return }
            
            guard let pencePerMile = claimAmounttextField.text else { return }
            guard let pencePerMileAsDouble = Double(pencePerMile) else { return }
            
            if endMileageAsDouble <= startMileageAsDouble {
                Alert.fieldAlert(on: self)
            } else if (claimAmounttextField.text?.count)! < 4 || (claimAmounttextField.text?.count)! > 4 {
                Alert.pencePerMileAlert(on: self)
            } else if endMileageAsDouble > startMileageAsDouble {
                let diferenceBetweenStartAndEndMileage = endMileageAsDouble - startMileageAsDouble
                
                let mileage = diferenceBetweenStartAndEndMileage
                let mileageAsStringTo2DecimalPlaces = String(format: "%.1f", mileage)
                
                let moneyYouCanClaim = Double(mileage) * pencePerMileAsDouble
                let showAmountToClaimWith2DecimalPlaces = String(format: "%.2f", moneyYouCanClaim)
            
                resultLabel.text = mileageAsStringTo2DecimalPlaces
                result2Label.text = showAmountToClaimWith2DecimalPlaces
                
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
    
    func createNewMileageEntry()  {
        let mileageEntryEntity = NSEntityDescription.entity(forEntityName: "MileageEntry", in: managedObjectContext)!
        let newMileageEntry = MileageEntry(entity: mileageEntryEntity, insertInto: managedObjectContext)
        
        newMileageEntry.date = self.datePicker.date
        newMileageEntry.journeyStart = self.journeyStartTextField.text
        newMileageEntry.journeyEnd = self.journeyEndTextField.text
        newMileageEntry.pencePerMile = self.claimAmounttextField.text
        newMileageEntry.tripDescription = self.tripDescriptionTextField.text
        newMileageEntry.total = self.resultLabel.text
        newMileageEntry.amountClaimed = self.result2Label.text
        
        do  {
            try managedObjectContext.save()
        } catch let error as NSError  {
            print("Could Not Save The New Entry \(error.localizedDescription)")
        }
    }
    
    func updateEntry()  {
        mileageEntry.date = self.datePicker.date
        mileageEntry.journeyStart = self.journeyStartTextField.text
        mileageEntry.journeyEnd = self.journeyEndTextField.text
        mileageEntry.pencePerMile = self.claimAmounttextField.text
        mileageEntry.tripDescription = self.tripDescriptionTextField.text
        mileageEntry.total = self.resultLabel.text
        mileageEntry.amountClaimed = self.result2Label.text
        
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
    
    func createJourneyStartToolbar()  {
        let createJourneyStartToolbar = UIToolbar()
        createJourneyStartToolbar.sizeToFit()
        
        let journeyStartToolbarDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(journeyStartToolbarDoneButtonPressed))
        createJourneyStartToolbar.setItems([journeyStartToolbarDoneButton], animated: true)
        journeyStartTextField.inputAccessoryView = createJourneyStartToolbar
    }
    
    @objc func  journeyStartToolbarDoneButtonPressed()  {
        if mileageEntry == nil {
            journeyEndTextField.isHidden = false
            mileageEndLabel.isHidden = false
        }
        self.view.endEditing(true)
    }
    
    func createJourneyEndToolbar()  {
        let createJourneyEndToolbar = UIToolbar()
        createJourneyEndToolbar.sizeToFit()
        
        let createJourneyEndDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(journeyEndDoneButtonPressed))
        createJourneyEndToolbar.setItems([createJourneyEndDoneButton], animated: true)
        journeyEndTextField.inputAccessoryView = createJourneyEndToolbar
    }
    
    @objc func  journeyEndDoneButtonPressed()  {
        if mileageEntry == nil {
            claimAmounttextField.isHidden = false
            howMuchAreYouClaimingLabel.isHidden = false
        }
        self.view.endEditing(true)
    }
    
    func createPencePerMileToolbar()  {
        let createPencePerMileToolbar = UIToolbar()
        createPencePerMileToolbar.sizeToFit()
        
        let pencePerMileDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(pencePerMileDoneButtonPressed))
        createPencePerMileToolbar.setItems([pencePerMileDoneButton], animated: true)
        claimAmounttextField.inputAccessoryView = createPencePerMileToolbar
    }
    
    @objc func  pencePerMileDoneButtonPressed()  {
        if mileageEntry == nil {
            tripDescriptionLabel.isHidden = false
            tripDescriptionTextField.isHidden = false
            
        }
        self.view.endEditing(true)
    }
 
    func showCalculateButtonToolbar()  {
        let calculateButtonToolbar = UIToolbar()
        calculateButtonToolbar.sizeToFit()
        
        let showCalculateButtonDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(showCalculateButtonDoneButtonPressed))
        calculateButtonToolbar.setItems([showCalculateButtonDoneButton], animated: true)
        tripDescriptionTextField.inputAccessoryView = calculateButtonToolbar
    }
    
    @objc func  showCalculateButtonDoneButtonPressed()  {
        if mileageEntry == nil {
            calculateMileageButton.isHidden = false
        } else if mileageEntry != nil && dateTextFiled.text != "" || journeyStartTextField.text != "" || journeyEndTextField.text != "" || claimAmounttextField.text != "" || tripDescriptionTextField.text != "" {
            calculateMileageButton.isEnabled = true
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

extension UITextView {
    func applyRoundedCorners() {
        self.layer.cornerRadius = 15.0
        self.layer.borderColor = UIColor(white: 0, alpha: 0.90).cgColor
        self.layer.borderWidth = 1.0
        self.layer.masksToBounds = true
        self.textContainerInset = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
    }
}
