//
//  ListVC.swift
//  OnTheMap
//
//  Created by Zachary Rose on 11/27/17.
//  Copyright © 2017 Zachary Rose. All rights reserved.
//

import UIKit
import MapKit
import FacebookLogin

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
    
    // MARK: Logout Action
    @IBAction func logoutTapped(_ sender: Any) {
        UdacityClient.sharedInstance().logout() { success, error in
            if success{
                self.dismiss(animated: true, completion: nil)
            } else {
                print(error!)
            }
        }
    }
    
    func refreshData(){
        // get locations
        ParseClient.sharedInstance().getStudentLocations(){(result, error) in
            // proceeed if we got result from Parse API with student locations (information)
            if error == nil {
                ParseClient.sharedInstance().studentDictionary = result!
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
        let student = ParseClient.sharedInstance().studentDictionary[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)! as UITableViewCell
        
        // Cell Defaults
        cell.textLabel!.text = student.firstName! + " " + student.lastName!
        cell.imageView!.image = UIImage(named: "icon_pin")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ParseClient.sharedInstance().studentDictionary.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let app = UIApplication.shared
        app.openURL(URL(string: ParseClient.sharedInstance().studentDictionary[indexPath.row].mediaURL!)!)
        
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
        self.present(alertController, animated: true){
        }
        
    }
}

