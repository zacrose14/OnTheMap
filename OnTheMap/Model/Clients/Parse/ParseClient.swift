//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Zachary Rose on 11/29/17.
//  Copyright © 2017 Zachary Rose. All rights reserved.
//

import Foundation

class ParseClient : NSObject {
    
    // Shared session
    var session = URLSession.shared
    
    // Student Info Dict used in ListVC and MapVC
    var studentDictionary: [StudentInfo] = [StudentInfo]()
    
    // MARK: Initializers
    override init() {
        super.init()
    }

    // MARK: GET
    
    // MARK: POST
    
    // MARK: Helpers
    
    // Substitute the key for the value that is contained within the method name (from the Udacity iOS Nanodegree Course, Section 5)
    func substituteKeyInMethod(_ method: String, key: String, value: String) -> String? {
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
    
    // MARK: Shared Instance
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
}
