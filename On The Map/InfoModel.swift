//
//  InfoModel.swift
//  On The Map
//
//  Created by Chirag Ramani on 05/06/16.
//  Copyright © 2016 Chirag Ramani. All rights reserved.
//

import Foundation

struct InfoModel
{

    let uniqueKey:String
    let firstName:String
    let lastName:String
    let latitude:Double
    let longitude:Double
    let mapString:String
    let mediaURL:String
    let updatedAt: String
    
    init(dictionary: [String: AnyObject]) {
        uniqueKey = dictionary[PClient.JSONResponseKeys.uniqueKey] as! String
        firstName = dictionary[PClient.JSONResponseKeys.firstName] as! String
        lastName = dictionary[PClient.JSONResponseKeys.lastName] as! String
        latitude = dictionary[PClient.JSONResponseKeys.latitude] as! Double
        longitude = dictionary[PClient.JSONResponseKeys.longitude] as! Double
        mapString = dictionary[PClient.JSONResponseKeys.mapString] as! String
        mediaURL = dictionary[PClient.JSONResponseKeys.mediaURL] as! String
        updatedAt = dictionary["updatedAt"] as! String
        
    }
    static func buildInfoModel(results: [[String: AnyObject]]) -> [InfoModel] {
        
        var dataModel = [InfoModel]()
        
        for x in results {
            dataModel.append(InfoModel(dictionary: x))
        }
        
        return dataModel
    }


}