//
//  MapVC.swift
//  OnTheMap
//
//  Created by Zachary Rose on 11/27/17.
//  Copyright © 2017 Zachary Rose. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController, MKMapViewDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getStudentLocations()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        getStudentLocations()
    }

    // MARK: Actions (Buttons)
    // Add Location Action
    @IBAction func addLocationPressed(_ sender: Any) {
        performSegue(withIdentifier: "mapToAddLocationSegue", sender: UIBarButtonItem.self)
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

        if ParseClient.sharedInstance().studentDictionary.isEmpty {
            displayError("There are no students to show!")
        } else {
        
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
    }
    
    // MARK: Map Delegates
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let mediaURL = NSURL(string: ((view.annotation?.subtitle)!)!) {
                if UIApplication.shared.canOpenURL(mediaURL as URL) {
                    UIApplication.shared.open(mediaURL as URL)
                } else {
                    displayError("Error! Cannot Open That URL!")
                }
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
        present(alertController, animated: true){
        }
        
    }
}

