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
    var studentDictionary = [StudentInfo]()
    
    // MARK: Initializers
    override init() {
        super.init()
        session = URLSession.shared
    }
    
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
    
    // From Udacity iOS Course
    // MARK: POST
    func taskForPostMethod(_ methodParameters: [String:AnyObject], completionHandlerForTaskForPost: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        let request = NSMutableURLRequest(url: URL(string: ParseClient.Constants.BaseURL)!)
        request.httpMethod = "POST"
        request.addValue(ParseClient.Constants.AppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseClient.Constants.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: methodParameters, options: .prettyPrinted)
        } catch {
            completionHandlerForTaskForPost(false, NSError(domain: "taskForPostMethod", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error with student post"]))
        }
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForTaskForPost(false, NSError(domain: "taskForPostMethod", code: 0, userInfo: userInfo))
            }
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            guard let _ = data else {
                sendError("No data was returned by the request")
                return
            }
            completionHandlerForTaskForPost(true, nil)
        }
        task.resume()
    }
    
    // Build URL From Paramaters (Credit: Udacity Nanodegree)
    class func parseURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = ParseClient.Constants.APIScheme
        components.host = ParseClient.Constants.APIHost
        components.path = ParseClient.Constants.APIPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    // MARK: Shared Instance
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
}
