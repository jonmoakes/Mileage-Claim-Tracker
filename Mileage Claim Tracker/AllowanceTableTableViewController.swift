//
//  AllowanceTableTableViewController.swift
//  Mileage Claim Tracker
//
//  Created by Jonathan Oakes on 19/03/2019.
//  Copyright © 2019 Jonathan Oakes. All rights reserved.
//

import UIKit
import CoreData

class AllowanceTableTableViewController: UITableViewController {
    
    var managedObjectContext: NSManagedObjectContext!
    var mileageEntries = [MileageEntry]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.fetchEntries()
    }
    
    func fetchEntries()  {
        let fetchRequest = NSFetchRequest<MileageEntry>(entityName: "MileageEntry")
        
        let dateSort = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
        
        do  {
            let entryObjects = try managedObjectContext.fetch(fetchRequest)
            self.mileageEntries = entryObjects as [MileageEntry]
        } catch let error as NSError  {
            print("Could Not Fetch Entries \(error.localizedDescription)")
        }
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mileageEntries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let entry = self.mileageEntries[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        //  cell.textLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(22))
        cell.textLabel?.font = UIFont(name: "Noteworthy-Bold", size: 21)
        
        if let date = entry.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE, dd - MM - yyy"
            let dateString = formatter.string(from: date)
            
            cell.textLabel?.text = "\(dateString)\nMileage Amount = \(entry.total ?? "0") Miles\nMoney Claimed = £\(entry.amountClaimed ?? "0")"
            
            if (dateString.contains("Monday"))  {
                cell.backgroundColor  = UIColor.init(red: 244.0/255.0, green: 190.0/255.0, blue: 95.0/255.0, alpha: 1)
            }  else if (dateString.contains("Tuesday"))  {
                cell.backgroundColor = UIColor.init(red: 251.0/255.0, green: 21.0/255.0, blue: 40.0/255.0, alpha: 1)
            }  else if (dateString.contains("Wednesday")) {
                cell.backgroundColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 10.0/255.0, alpha: 1)
            }  else if (dateString.contains("Thursday"))  {
                cell.backgroundColor = UIColor.init(red: 95.0/255.0, green: 195.0/255.0, blue: 241.0/255.0, alpha: 1)
            }  else if (dateString.contains("Friday")) {
                cell.backgroundColor = UIColor.init(red: 252.0/255.0, green: 0.0/255.0, blue: 136.0/255.0, alpha: 1)
            }  else if (dateString.contains("Saturday"))  {
                cell.backgroundColor = UIColor.init(red: 193.0/255.0, green: 255.0/255.0, blue: 5.0/255.0, alpha: 1)
            }  else if (dateString.contains("Sunday")) {
                cell.backgroundColor = UIColor.magenta
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entry = mileageEntries[indexPath.row]
        self.performSegue(withIdentifier: "goToTripsVC", sender: entry)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToTripsVC"  {
            let tripsVC = segue.destination as! ViewLogsViewController
            tripsVC.logsEntry = sender as? MileageEntry
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(indexPath.row % 2 == 0)  {
            let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 10, 0)
            cell.layer.transform = rotationTransform
            cell.alpha = 0.3
            
            UIView.animate(withDuration: 0.5) {
                cell.layer.transform = CATransform3DIdentity
                cell.alpha = 1.0
            }
        }   else  {
            let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 500, 10, 0)
            cell.layer.transform = rotationTransform
            cell.alpha = 0.3
            
            UIView.animate(withDuration: 0.5) {
                cell.layer.transform = CATransform3DIdentity
                cell.alpha = 1.0
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete  {
            let entry = self.mileageEntries[indexPath.row]
            
            let deleteAlertController = UIAlertController(title: "Are You Sure?", message: "This Will Delete All Data Contained Within This Entry For This Date Forever.", preferredStyle: .alert)
            
            let imSure = UIAlertAction(title: "I'm Sure", style: .destructive) { (action) in
                self.managedObjectContext.delete(entry)
                self.mileageEntries.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                do  {
                    try self.managedObjectContext.save()
                } catch let error as NSError  {
                    print("Could Not Save The New Entry \(error.localizedDescription)")
                }
            }
            deleteAlertController.addAction(imSure)
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            deleteAlertController.addAction(cancel)
            
            self.present(deleteAlertController, animated: true, completion: nil)
        }
    }

}
