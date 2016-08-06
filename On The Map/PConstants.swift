//
//  PConstants.swift
//  On The Map
//
//  Created by Chirag Ramani on 04/06/16.
//  Copyright © 2016 Chirag Ramani. All rights reserved.
//


extension PClient
{
    struct Constants {
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = ""
        static let RestApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let ApplicationId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    }
    
    struct Methods {
        static let Locations = "/parse/classes/StudentLocation"
        static let UpdateLocations = "/parse/classes/StudentLocation/{objectId}"
    }
    
    struct HeaderFields {
        static let ParseAppIdKey = "X-Parse-Application-Id"
        static let RestApiKey = "X-Parse-REST-API-Key"
    }
    
    
    
    
    struct JSONRequestBodyKeys {
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let UniqueKey = "uniqueKey"
        
    }
    
    
    struct JSONResponseKeys {
        static let results = "results"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let mapString = "mapString"
        static let mediaURL = "mediaURL"
        static let uniqueKey = "uniqueKey"
    }
    
    struct parameterKeys {
        static let Limit = "limit"
        static let Order = "order"
    }
    
    
    struct paramaterValues {
        static let UpdatedAt = "updatedAt"
        static let ReturnObjectsCount = "100"
    }
    
}




