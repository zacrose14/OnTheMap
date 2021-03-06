//
//  ParseConstants.swift
//  OnTheMap
//
//  Created by Zachary Rose on 11/29/17.
//  Copyright © 2017 Zachary Rose. All rights reserved.
//

import Foundation

extension ParseClient {
    
    // MARK: Constants
    struct Constants {
        
        static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let AppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let BaseURL: String = "https://parse.udacity.com/parse/classes/StudentLocation"
        static let APIScheme = "https"
        static let APIHost = "parse.udacity.com"
        static let APIPath = "/parse/classes/StudentLocation"
  
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        static let Limit = "limit"
        static let Order = "order"
        
    }

    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        static let StatusCode = "status_code"
        
        static let Results = "results"
        static let CreatedAt = "createdAt"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Longitude = "longitude"
        static let Latitude = "latitude"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let ObjectID = "objectId"
        static let UniqueKey = "uniqueKey"
        static let UpdatedAt = "updatedAt"
    }
}
