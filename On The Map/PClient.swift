//
//  PClient.swift
//  On The Map
//
//  Created by Chirag Ramani on 04/06/16.
//  Copyright © 2016 Chirag Ramani. All rights reserved.
//

import Foundation

class PClient:NSObject
{
    var mapString: String? = nil
    var mediaURL: String? = nil
    var latitude: Double? = nil
    var longitude: Double? = nil
    var objectId: String? = nil
    
    
    // Shared session
    var session = NSURLSession.sharedSession()
    
    // MARK: GET
    
    func taskForGETMethod(method: String, parameters: [String: AnyObject], completionHandlerForGet: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        // Build the URL and configure the request
        let request = NSMutableURLRequest(URL: urlFromParameters(parameters, withPathExtention: method))
        request.addValue(PClient.Constants.ApplicationId, forHTTPHeaderField: PClient.HeaderFields.ParseAppIdKey)
        request.addValue(PClient.Constants.RestApiKey, forHTTPHeaderField: PClient.HeaderFields.RestApiKey)
        
        // Make the request
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            func sendError(error: String) {
                
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForGet(result: nil, error: NSError(domain: "taskForGetMethod", code: 1, userInfo: userInfo))
            }
            
            // GUARD: Was there an error?
            guard (error == nil) else {
                if(error!.code==(-1009))
                {
                    sendError("The Internet connection appears to be offline")
                }
                else
                {
                    sendError("There was an error with your request: \(error)")
                }
                return
            }

            
            // GUARD: Did we get a successful 2XX response?
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if (response as? NSHTTPURLResponse)?.statusCode == 401
                {
                    sendError("Unauthorized!")
                }
                else
                {
                    sendError("Invalid Request!")
                }
                return
            }
            
            // GUARD: Was there any data returned?
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            // Parse the data and use the data (in completion handler)
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGet)
            
        }
        
        // Start the request
        task.resume()
        
        return task
    }
    
    // MARK: Post
    
    func taskForPOSTMethod(method: String, parameters: [String: AnyObject], jsonBody: String, completionHandlerForPOST: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        // Build the URL and configure the request
        let request = NSMutableURLRequest(URL: urlFromParameters(parameters, withPathExtention: method))
        request.HTTPMethod = "POST"
        request.addValue(PClient.Constants.ApplicationId, forHTTPHeaderField: PClient.HeaderFields.ParseAppIdKey)
        request.addValue(PClient.Constants.RestApiKey, forHTTPHeaderField: PClient.HeaderFields.RestApiKey)
        request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        // Make the request
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            func sendError(error: String) {
                print("\(error)\n")
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForPOST(result: nil, error: NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
                
            }
            
            // GUARD: Was there an error?
            guard (error == nil) else {
                if(error!.code==(-1009))
                {
                    sendError("The Internet connection appears to be offline")
                }
                else
                {
                    sendError("There was an error with your request: \(error)")
                }
                return
            }

            
            // GUARD: Did we get a successful 2XX response?
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if (response as? NSHTTPURLResponse)?.statusCode == 401
                {
                    sendError("Unauthorized!")
                }
                else
                {
                    sendError("Invalid Request!")
                }
                return
            }
            
            
            // GURAD: Was there any data returned?
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            // Parse the data and use it (in the compltetion handler).
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
        }
        
        // Start the request
        task.resume()
        
        return task
    }
    
    func taskForPUTMethod(method: String,  parameters: [String: AnyObject], jsonBody: String, completionHandlerForPUT: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        
        let request = NSMutableURLRequest(URL: urlFromParameters(parameters, withPathExtention: method))
        request.HTTPMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(PClient.Constants.ApplicationId, forHTTPHeaderField: PClient.HeaderFields.ParseAppIdKey)
        request.addValue(PClient.Constants.RestApiKey, forHTTPHeaderField: PClient.HeaderFields.RestApiKey)
        request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
        print(request)
        
        // Make the request
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            func sendError(error: String) {
                print("\(error)\n")
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForPUT(result: nil, error: NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
                
            }
            
            
            // GUARD: Was there an error?
            guard (error == nil) else {
                if(error!.code==(-1009))
                {
                    sendError("The Internet connection appears to be offline")
                }
                else
                {
                    sendError("There was an error with your request: \(error)")
                }
                return
            }

            
            // GUARD: Did we get a successful 2XX response?
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if (response as? NSHTTPURLResponse)?.statusCode == 401
                {
                    sendError("Unauthorized!")
                }
                else
                {
                    sendError("Invalid Request!")
                }
                return
            }
            
            
            // GURAD: Was there any data returned?
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            // Parse the data and use it (in the compltetion handler).
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPUT)
        }
        
        // Start the request
        task.resume()
        
        return task
    }
    
    
    // MARK: Helpers
    
    // Substitute the key for the value that is contained within the method name
    func substituteKeyInMethod(method: String, key: String, value: String) -> String? {
        if method.rangeOfString("{\(key)}") != nil {
            return method.stringByReplacingOccurrencesOfString("{\(key)}", withString: value)
        } else {
            return nil
        }
    }
    
    // Return a useable Foundation object from raw JSON data
    private func convertDataWithCompletionHandler(data: NSData, completionHandlerForConvertData: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        }
        catch {
            let userInfo = [NSLocalizedDescriptionKey: "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(result: nil, error: NSError(domain: "converDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        completionHandlerForConvertData(result: parsedResult, error: nil)
        
    }
    
    // Create a URL from parameters
    private func urlFromParameters(parameters: [String: AnyObject], withPathExtention: String? = nil) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = PClient.Constants.ApiScheme
        components.host = PClient.Constants.ApiHost
        components.path = PClient.Constants.ApiPath + (withPathExtention ?? "")
        components.queryItems = [NSURLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        print(components.URL!)
        return components.URL!
        
    }
    
    // MARK: Shared instance
    class func sharedInstance() -> PClient {
        struct Singleton {
            static var sharedInstance = PClient()
        }
        return Singleton.sharedInstance
    }
    
    
    
}