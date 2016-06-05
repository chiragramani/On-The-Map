//
//  Convenience.swift
//  On The Map
//
//  Created by Chirag Ramani on 04/06/16.
//  Copyright © 2016 Chirag Ramani. All rights reserved.
//

import Foundation

extension UClient
{

    func getSessionID(username: String, password: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        let parameters = [String: AnyObject]()
        
        let jsonBody = "{\"udacity\": {\"\(UClient.URLKeys.username)\": \"\(username)\", \"\(UClient.URLKeys.password)\": \"\(password)\"}}"
        
        taskForPOSTMethod(UClient.Methods.Session, parameters: parameters, jsonBody: jsonBody) { (results, error) in
            
            if let error = error {
                completionHandler(success: false, errorString: error.localizedDescription)
            } else {
                print(results)
                if let session = results[UClient.JSONresponseKeys.Account] as? [String: AnyObject] {
                    if let user = session[UClient.JSONresponseKeys.UserID] as? String {
                        UClient.sharedInstance().userId = user
                       completionHandler(success: true, errorString: nil)
                        
                    }
                    
                } else {
                    completionHandler(success: false, errorString: "Cannot establish the session..Please try again!")
                }
            }
        }
    }
    
    
    func getPublicUserData()->Void{
        
        let parameters = [String: AnyObject]()
        var mutableMethod = UClient.Methods.PublicUserData
        mutableMethod = subtituteKeyInMethod(mutableMethod, key: UClient.URLKeys.UserID, value: UClient.sharedInstance().userId!)!
        
        
        taskForGETMethod(mutableMethod, parameters: parameters) { (results, error) in
            if let error = error {
                print("Could not get first and last name of the user")
            } else {
                guard let results = results as? [String: AnyObject] else {
                    print("Could not parse reponse")
                    return
                }
                guard let userData = results["user"] as? [String: AnyObject] else {
                    print("Invalid JSON response")
                    return
                }
                guard let firstName = userData["first_name"] as? String else {
                   print("first name not available in response")
                    return
                }
                guard let lastName = userData["last_name"] as? String else {
                    print("first name not available in response")
                    return
                }
                UClient.sharedInstance().firstName = firstName
                UClient.sharedInstance().lastName = lastName
                
                
            }
        }
    }

    func deleteSession(completionHandler: (success: Bool, errorString: String?) -> Void)
    {
    
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                
                completionHandler(success: false,errorString: error?.localizedDescription)
            }
        else
            {
                // GUARD: Did we get a successful 2XX response?
                guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                     completionHandler(success: false,errorString: "Your request returned a status code other than 2xx!")
                    return
                }
                completionHandler(success: true,errorString: nil)

            
            }
        
        }
        task.resume()
    
    }


}