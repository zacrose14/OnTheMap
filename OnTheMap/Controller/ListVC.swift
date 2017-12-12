//
//  ListVC.swift
//  OnTheMap
//
//  Created by Zachary Rose on 11/27/17.
//  Copyright © 2017 Zachary Rose. All rights reserved.
//

import UIKit
import MapKit

class ListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }
    
    // MARK: Actions (Buttons)
    
    // Add Loction
    @IBAction func addLocationPressed(_ sender: Any) {
        performSegue(withIdentifier: "listToAddLocationSegue", sender: UIBarButtonItem.self)
    }
    
    // Refresh
    @IBAction func refreshPressed(_ sender: Any) {
        refreshData()
    }
    
    // Logout Action
    @IBAction func logoutTapped(_ sender: Any) {
        UdacityClient.sharedInstance().logout() { success, error in
            if success{
                self.dismiss(animated: true, completion: nil)
            } else {
                print(error!)
            }
        }
    }
    // Refresh Action
    func refreshData(){
        ParseClient.sharedInstance().getStudentLocations(){(result, error) in
            // proceeed if we got result from Parse API with student locations (information)
            if error == nil {
                StudentInfo.studentLocations = result!
                performUIUpdatesOnMain {
                    self.tableView.reloadData()
                }
            } else {
                
                self.displayError(error?.localizedDescription)
                
            }
        }
    }
    // MARK: Table delegate and functions
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cellReuseIdentifier = "studentInfoTableCell"
        let student = StudentInfo.studentLocations[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)! as UITableViewCell
        
        // Cell Defaults
        
        var displayFirstName: String = ""
        var displayLastName: String = ""
        
        if let firstName = student.firstName {
            displayFirstName = firstName
        } else {
            displayFirstName = "[empty]"
        }
        
        if let lastName = student.lastName {
            displayLastName = lastName
        } else {
            displayLastName = "[empty]"
        }
        
        cell.textLabel?.text = "\(displayFirstName) \(displayLastName)"
        cell.imageView!.image = UIImage(named: "icon_pin")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentInfo.studentLocations.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let studentURL = StudentInfo.studentLocations[indexPath.row].mediaURL
        
        if let studentMediaURL = URL(string: studentURL!), UIApplication.shared.canOpenURL(studentMediaURL) {
            // Open URL
            UIApplication.shared.open(studentMediaURL)
        } else {
            displayError("That's not a valid URL!")
        }
        
    }
    
    // MARK: Error Functions and Alerts
    func displayError(_ errorString: String?) {
        performUIUpdatesOnMain {
            if let errorString = errorString {
                self.showAlert(errorString)
            }
        }
    }
    
    func showAlert(_ errorMessage: String?) {
        
        let alertController = UIAlertController(title: nil, message: errorMessage!, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Dismiss", style: .cancel) {(action) in
        }
        alertController.addAction(cancelAction)
        present(alertController, animated: true){
        }
        
    }
}

