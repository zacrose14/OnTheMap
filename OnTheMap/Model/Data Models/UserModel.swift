//
//  UserModel.swift
//  OnTheMap
//
//  Created by Zachary Rose on 12/5/17.
//  Copyright © 2017 Zachary Rose. All rights reserved.
//

import Foundation

struct UserModel {
    
    var userKey: String?
    var firstName: String?
    var lastName: String?
    
    init(dictionary: [String:AnyObject]) {
        
        userKey = dictionary[UdacityClient.JSONResponseKeys.Key] as? String
        firstName = dictionary[UdacityClient.JSONResponseKeys.FirstName] as? String
        lastName = dictionary[UdacityClient.JSONResponseKeys.LastName] as? String
    }
    
}
