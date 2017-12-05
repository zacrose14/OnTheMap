//
//  AddStudentLocationMapVC.swift
//  OnTheMap
//
//  Created by Zachary Rose on 12/1/17.
//  Copyright © 2017 Zachary Rose. All rights reserved.
//

import UIKit
import MapKit

class AddStudentLocationMapVC: UIViewController, MKMapViewDelegate  {

    var locationManager =  CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self as! CLLocationManagerDelegate

        // Load location from previous VC here.
        // Add code to allow autodetect using GPS?
    }

}
