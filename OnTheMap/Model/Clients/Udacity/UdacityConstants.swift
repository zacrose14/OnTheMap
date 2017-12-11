//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Zachary Rose on 11/29/17.
//  Copyright © 2017 Zachary Rose. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    // MARK: Constants
    struct Constants {
        
        static let SignupPath: String = "https://www.udacity.com/account/auth#!/signup"
        static let BaseURL: String = "https://www.udacity.com/api/"
        static let APIScheme = "https"
        static let APIHost = "www.udacity.com"
        static let APIPath = "/api/"
    }
    
    // MARK: Methods
    struct Methods {
        
        static let SessionCreate = "session"
        static let SessionDelete = "session"
        static let GetPublicData = "users/{user_id}"
    }
    
    // MARK: Login Errors
    struct LoginError{
        static let AccountError = "Invalid Email or Password"
        static let NetworkError = "Error! Check Network Connection"
    }
    
    // MARK: URL Keys
    struct URLKeys {
        
        static let UserID = "user_id"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        static let Session = "session"
        static let ID = "id"
        static let Status = "status"
        static let Account = "account"
        static let Key = "key"
        static let User = "user"
        static let FirstName = "first_name"
        static let LastName = "last_name"
    }
}
