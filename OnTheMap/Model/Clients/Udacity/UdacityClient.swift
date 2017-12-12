//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Zachary Rose on 11/29/17.
//  Copyright © 2017 Zachary Rose. All rights reserved.
//

import Foundation

class UdacityClient : NSObject {
    
    // Shared session
    var session = URLSession.shared
    
    // User key from a POST session
    var userKey: String?
    
    // MARK: Initializers
    override init() {
        super.init()
        session = URLSession.shared
    }
    
    // MARK: Helpers
    
    // Substitute the key for the value that is contained within the method name (from the Udacity iOS Nanodegree Course, Section 5)
    class func substituteKeyInMethod(_ method: String, key: String, value: String) -> String? {
        if method.range(of: "{\(key)}") != nil {
            return method.replacingOccurrences(of: "{\(key)}", with: value)
        } else {
            return nil
        }
    }
    
    // Given raw JSON, return a usable Foundation object (Also from the Udacity iOS Nanodegree Course, Section 5)
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    // From Udacity Networking course
    class func udacityURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = UdacityClient.Constants.APIScheme
        components.host = UdacityClient.Constants.APIHost
        components.path = UdacityClient.Constants.APIPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
        
    // MARK: Shared Instance
    
    class func sharedInstance() -> UdacityClient{
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
}
