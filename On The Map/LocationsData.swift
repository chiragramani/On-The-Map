//
//  LocationsData.swift
//  On The Map
//
//  Created by Chirag Ramani on 08/06/16.
//  Copyright © 2016 Chirag Ramani. All rights reserved.
//

import Foundation

class LocationsData:NSObject
{
 var locations: [InfoModel] = [InfoModel]()
    
    class func sharedInstance() -> LocationsData {
        struct Singleton {
            static var sharedInstance = LocationsData()
        }
        return Singleton.sharedInstance
    }
}