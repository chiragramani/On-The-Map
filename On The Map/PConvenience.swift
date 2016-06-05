//
//  PConvinience.swift
//  On The Map
//
//  Created by Chirag Ramani on 04/06/16.
//  Copyright © 2016 Chirag Ramani. All rights reserved.
//

import Foundation
import UIKit

extension PClient
{
    
   
    func getLocationInfoFromParse(completionHandlerForGetLocationFromParse:(success: Bool, errorString: String?) -> Void) {
        
        let parameters = [PClient.parameterKeys.Limit: PClient.paramaterValues.ReturnObjectsCount,
                          PClient.parameterKeys.Order: "-\(PClient.paramaterValues.UpdatedAt)"]
        
        taskForGETMethod(PClient.Methods.Locations, parameters: parameters) { (results, error) in
            
            if let error = error {
                // TODO: user alert
                print(error.localizedDescription)
            } else {
                
                
               if let results = results[PClient.JSONResponseKeys.results] as? [[String: AnyObject]] {
                    PClient.sharedInstance().locations = InfoModel.buildInfoModel(results)
                    completionHandlerForGetLocationFromParse(success: true, errorString: nil)
                } else {
                    completionHandlerForGetLocationFromParse(success: false, errorString: "Could not parse data")
                    
                }
            }
        }
    }

    
    func postStudentLocation(mediaURL: String, completionHandlerForPostStudentLocation: (success: Bool?, errorString: String?) -> Void) {
        
        let parameters = [String: AnyObject]()
        
        let jsonBody = "{\"\(PClient.JSONRequestBodyKeys.UniqueKey)\": \"\(UClient.sharedInstance().userId!)\", \"\(PClient.JSONRequestBodyKeys.FirstName)\": \"\(UClient.sharedInstance().firstName!)\", \"\(PClient.JSONRequestBodyKeys.LastName)\": \"\(UClient.sharedInstance().lastName!)\",\"\(PClient.JSONRequestBodyKeys.MapString)\": \"\(self.mapString!)\", \"\(PClient.JSONRequestBodyKeys.MediaURL)\": \"\(self.mediaURL!)\",\"\(PClient.JSONRequestBodyKeys.Latitude)\": \(self.latitude!), \"\(PClient.JSONRequestBodyKeys.Longitude)\": \(self.longitude!)}"
        
        taskForPOSTMethod(PClient.Methods.Locations, parameters: parameters, jsonBody: jsonBody) { (results, error) in
            
            if let error = error {
                print("\(error.localizedDescription)")
                completionHandlerForPostStudentLocation(success: false, errorString: "Could not add location")
            } else {
                print(results)
                completionHandlerForPostStudentLocation(success: true, errorString: nil)
            }
            
        }
        
        
    }
    
    func updateStudentLocation(mediaURL: String, completionHandlerForUpdatetStudentLocation: (success: Bool?, errorString: String?) -> Void) {
        
        let parameters = [String: AnyObject]()
        var mutableMethod: String = PClient.Methods.UpdateLocations
        mutableMethod = substituteKeyInMethod(mutableMethod, key: "objectId", value: PClient.sharedInstance().objectId!)!
               let jsonBody="{\"\(PClient.JSONRequestBodyKeys.UniqueKey)\": \"\(UClient.sharedInstance().userId!)\", \"firstName\": \"\(UClient.sharedInstance().firstName!)\", \"lastName\": \"\(UClient.sharedInstance().lastName!)\",\"mapString\": \"\(PClient.sharedInstance().mapString!)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(PClient.sharedInstance().latitude!), \"longitude\": \(PClient.sharedInstance().longitude!)}"
                
        taskForPUTMethod(mutableMethod, parameters: parameters, jsonBody: jsonBody) { (results, error) in
            
            if let error = error {
                print("\(error.localizedDescription)")
                completionHandlerForUpdatetStudentLocation(success: false, errorString: "Could not update new location")
            } else {
                print(results)
                completionHandlerForUpdatetStudentLocation(success: true, errorString: nil)
            }
            
        }
        
        
    }

    func queryStudentLocation(completionHandlerForQueryStudentLocation: (success: Bool, errorString: String?) -> Void) {
        
        let query = "{\"\(PClient.JSONRequestBodyKeys.UniqueKey)\": \"\(UClient.sharedInstance().userId!)\"}"
        
        let parameters = [
            "where" : query
        ]
        
        taskForGETMethod(PClient.Methods.Locations, parameters: parameters) { (results, error) in
            
            if let error = error {
                completionHandlerForQueryStudentLocation(success: false, errorString: error.localizedDescription)
            } else {
                
                if let results = results as? [String: AnyObject] {
                    if let resultsArray = results[PClient.JSONResponseKeys.results] {
                        print(resultsArray.count)
                        if resultsArray.count > 0 {
                            if let dict = resultsArray[0] {
                                guard let ID = dict["objectId"] as? String else {
                                    completionHandlerForQueryStudentLocation(success: false, errorString: "Invalid response")
                                    return
                                }
                                
                                 PClient.sharedInstance().objectId = ID
                                
                            }
                            completionHandlerForQueryStudentLocation(success: false, errorString: "Posted")
                        } else {
                            completionHandlerForQueryStudentLocation(success: true, errorString: nil)
                        }
                    }
                    
                } else {
                    print(results)
                    completionHandlerForQueryStudentLocation(success: false, errorString: "Could not parse results")
                }
                
                
            }
        }
    }




}