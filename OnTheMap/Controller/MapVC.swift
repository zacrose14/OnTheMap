//
//  MapVC.swift
//  OnTheMap
//
//  Created by Zachary Rose on 11/27/17.
//  Copyright © 2017 Zachary Rose. All rights reserved.
//

import UIKit
import MapKit
import FacebookLogin

class MapVC: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getStudentLocations()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: Actions (Buttons)
    
    // Add Location Action
    @IBAction func addLocationPressed(_ sender: Any) {
    }
    
    // Refresh Action
    @IBAction func refreshPressed(_ sender: Any) {
    
        getStudentLocations()
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
    
    // Function to get student locations
    func getStudentLocations() {

        ParseClient.sharedInstance().getStudentLocations(){(result, error) in
            
            ParseClient.sharedInstance().studentDictionary = result!
            
            if error == nil {
                ParseClient.sharedInstance().createAnnotationsFromLocations(result!) { (result, error) in

                    if error == nil {
                        
                        performUIUpdatesOnMain {
                            self.mapView.addAnnotations(result!)
                        }
                    } else {
                        self.displayError(error?.localizedDescription)
                    }
                    
                }
                
            } else {
                self.displayError(error?.localizedDescription)
                
            }
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
        self.present(alertController, animated: true){
        }
        
    }
}

