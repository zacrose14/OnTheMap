//
//  StudentInfo.swift
//  OnTheMap
//
//  Created by Zachary Rose on 12/5/17.
//  Copyright © 2017 Zachary Rose. All rights reserved.
//

import Foundation


struct StudentInfo {
    
    var objectId: String?
    var uniqueKey: String?
    var firstName: String?
    var lastName: String?
    var mapString: String?
    var mediaURL: String?
    var longitude: Double?
    var latitude: Double?
    var createdAt: String?
    var updatedAt: String?
    
    static var studentLocations = [StudentInfo]()
    
    init(dictionary: [String : AnyObject]) {
        
        objectId = dictionary[ParseClient.JSONResponseKeys.ObjectID] as? String
        uniqueKey = dictionary[ParseClient.JSONResponseKeys.UniqueKey] as? String
        firstName = dictionary[ParseClient.JSONResponseKeys.FirstName] as? String
        lastName = dictionary[ParseClient.JSONResponseKeys.LastName] as? String
        mapString = dictionary[ParseClient.JSONResponseKeys.MapString] as? String
        mediaURL = dictionary[ParseClient.JSONResponseKeys.MediaURL] as? String
        longitude = dictionary[ParseClient.JSONResponseKeys.Longitude] as? Double
        latitude = dictionary[ParseClient.JSONResponseKeys.Latitude] as? Double
        createdAt = dictionary[ParseClient.JSONResponseKeys.CreatedAt] as? String
        updatedAt = dictionary[ParseClient.JSONResponseKeys.UpdatedAt] as? String
        
    }
    
    // MARK: Helper function to convert array of dictionaries to array of StudentInfo Objects
    static func studentsFromResults(_ results: [[String : AnyObject]]) -> [StudentInfo] {
        var students = [StudentInfo]()
        
        for result in results {
            students.append(StudentInfo(dictionary: result))
        }
        
        return students
    }
}
