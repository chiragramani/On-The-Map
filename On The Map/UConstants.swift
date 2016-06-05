//
//  Constants.swift
//  On The Map
//
//  Created by Chirag Ramani on 04/06/16.
//  Copyright © 2016 Chirag Ramani. All rights reserved.
//

import Foundation

extension UClient {
    
    struct Constants {
        
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
        static let AuthorizationURL : String = "https://www.udacity.com/api/session"
    }
    
    struct Methods {
        static let PublicUserData = "/users/{id}"
        static let Session = "/session"
        
    }
    
    
    struct URLKeys {
        static let username = "username"
        static let password = "password"
        static let UserID = "id"
    }
    
    
    struct JSONresponseKeys {
        static let Account = "account"
        static let UserID = "key"
    }
}