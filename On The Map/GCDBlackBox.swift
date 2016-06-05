//
//  GCDBlackBox.swift
//  On The Map
//
//  Created by Chirag Ramani on 30/05/16.
//  Copyright © 2016 Chirag Ramani. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(updates: () -> Void) {
    dispatch_async(dispatch_get_main_queue()) {
        updates()
    }
}