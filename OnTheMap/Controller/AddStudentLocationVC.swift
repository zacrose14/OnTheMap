//
//  AddStudentLocationVC.swift
//  OnTheMap
//
//  Created by Zachary Rose on 12/1/17.
//  Copyright © 2017 Zachary Rose. All rights reserved.
//

import UIKit
import MapKit

class AddStudentLocationVC: UIViewController, MKMapViewDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var submitLocation: BorderedButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    var coords: CLLocationCoordinate2D?
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mapView.isHidden = true
        submitLocation.isHidden = true

    }

    // MARK: Actions
    @IBAction func findLocationPressed(_ sender: Any) {
        
        self.view.endEditing(true)
        activityIndicator.startAnimating()
        submitLocation.isHidden = false
        mapView.isHidden = false
        
        let geoCode = CLGeocoder()
        
        geoCode.geocodeAddressString(self.locationTextField.text!) { (placemarks, error) -> Void in
            
            // Check for error
            if error != nil {
                self.displayError("Invalid Location")
                self.activityIndicator.stopAnimating()
            } else {
                // Create Coords/Annotation
                let placemark = placemarks![0]
                let location = placemark.location
                self.coords = location!.coordinate
                
                self.latitude = self.coords!.latitude
                self.longitude = self.coords!.longitude
                
                let coordinate = CLLocationCoordinate2D(latitude: self.latitude!, longitude: self.longitude!)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                
                let region = MKCoordinateRegionMakeWithDistance(coordinate, 100000, 100000)
                
                performUIUpdatesOnMain {
        
                    self.activityIndicator.stopAnimating()
                    self.mapView.addAnnotation(annotation)
                    self.mapView.setRegion(region, animated: true)
                    
                }
            }
        }
    }
    
    @IBAction func submitPressed(_ sender: Any) {
    }
    
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Keyboard Functions
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true;
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
