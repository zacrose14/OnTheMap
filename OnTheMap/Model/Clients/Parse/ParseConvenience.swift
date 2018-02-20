//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by Zachary Rose on 12/6/17.
//  Copyright © 2017 Zachary Rose. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension ParseClient {
    
    // Function to get student locations
    func getStudentLocations(completionHandlerForGetLocations: @escaping (_ result: [StudentInfo]?, _ error: NSError?) -> Void) {
        
        // 1. Set the parameters
        let methodParameters: [String:Any] = [ParseClient.ParameterKeys.Limit: 100, ParseClient.ParameterKeys.Order: "-updatedAt"]
        
        // 2/3. Build the URL and configure request
        let request = NSMutableURLRequest(url: ParseClient.parseURLFromParameters(methodParameters as [String : AnyObject]))
        request.addValue(ParseClient.Constants.AppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseClient.Constants.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        // 4. Make the request
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGetLocations(nil, NSError(domain: "getStudentLocations", code: 1, userInfo: userInfo))
            }
            
            // GUARD: Was there an error?
            guard (error == nil) else {
                
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            // GUARD: Did we get a successful 2XX response?
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            // GUARD: Was there any data returned?
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            // 5. Parse the data
            let parsedResult: [String:AnyObject]
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
            } catch {
                print("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            // 6. Use the data!
            if let results = parsedResult[ParseClient.JSONResponseKeys.Results] as? [[String : AnyObject]] {
                
                let students = StudentInfo.studentsFromResults(results)
                
                completionHandlerForGetLocations(students, nil)
                
            } else {
                completionHandlerForGetLocations(nil, NSError(domain: "Results from Parse", code: 0, userInfo: [NSLocalizedDescriptionKey: "Download (server) error occured. Please retry."]))
            }
            
        }
        // 7. Start the request
        task.resume()
        
    }
    
    // Function to create annotations
    func createAnnotationsFromLocations(_ locations:[StudentInfo], completionHandler: (_ result: [MKPointAnnotation]?, _ error: NSError?) -> Void){
    
    // Check to make sure we have locations
    if locations.isEmpty {
    
    completionHandler(nil, NSError(domain: "AnnotationParsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Couldn't create annotations."]))
    
    } else {
    
        var annotations = [MKPointAnnotation]()
        for dictionary in locations {
            var lat: CLLocationDegrees?
            var long: CLLocationDegrees?
            var coordinate: CLLocationCoordinate2D?
    
            if let latitude = dictionary.latitude, let longitude = dictionary.longitude {
                lat = CLLocationDegrees(latitude)
                long = CLLocationDegrees(longitude)
    
                // Create a CLLocationCoordinates2D instance.
                coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
            }
    
            // Create Annotation
            let annotation = MKPointAnnotation()
    
            if let coordinate = coordinate {
                annotation.coordinate = coordinate
            }
    
            if let firstName = dictionary.firstName, let lastName = dictionary.lastName {
                annotation.title = "\(firstName) \(lastName)"
            }
    
            if let mediaUrl = dictionary.mediaURL {
                annotation.subtitle = mediaUrl
            }
    
            annotations.append(annotation)
        }
    
        completionHandler(annotations, nil)
        }
    }
    
    // Function to post student locations
    func postStudentLocation(_ uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double, completionHandlerForPostStudent: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        let methodParameters: [String:Any] = [ParseClient.JSONResponseKeys.UniqueKey: uniqueKey, ParseClient.JSONResponseKeys.FirstName: firstName, ParseClient.JSONResponseKeys.LastName: lastName, ParseClient.JSONResponseKeys.MapString: mapString, ParseClient.JSONResponseKeys.MediaURL: mediaURL, ParseClient.JSONResponseKeys.Latitude: latitude, ParseClient.JSONResponseKeys.Longitude: longitude]
        
        taskForPostMethod(methodParameters as [String: AnyObject]) { (success, error) in
            if success {
                completionHandlerForPostStudent(true, nil)
            } else {
                completionHandlerForPostStudent(false, "There appears to have been an error: \(String(describing: error))")
            }
        }
    }
    
}
