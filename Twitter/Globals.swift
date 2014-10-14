//
//  protocols.swift
//  Twitter
//
//  Created by Amit Chowdhary on 9/27/14.
//  Copyright (c) 2014 Amit Chowdhary. All rights reserved.
//

import UIKit
import CoreData

let RequestHandlerIsReadyNotification = "RequestHandlerIsReadyNotification"
let UserImageUpdatedNotification = "UserImageUpdatedNotification"

let delegate = UIApplication.sharedApplication().delegate as AppDelegate

protocol ClientGeneratorDelegate {
    func clientCreated (client :OAuthSwiftClient) -> ()
}

protocol RequestHandlerUser {
    var requestHandlerReadyNotificationObserver: AnyObject? { get set }
    func requestHandlerIsReady()
}

func getMainUserId() -> (NSNumber) {
    return NSUserDefaults.standardUserDefaults().objectForKey("mainUserId") as NSNumber
}

func saveMainUserToUserDefaults(id: NSNumber, screenName: String) {
    NSUserDefaults.standardUserDefaults().setObject(id, forKey: "mainUserId")
    NSUserDefaults.standardUserDefaults().setObject(screenName, forKey: "mainUserScreenName")
    NSUserDefaults.standardUserDefaults().synchronize()
}

extension NSDate {
    func humanReadableTimeSinceNowString() -> String {
        var ti = Int64(self.timeIntervalSinceNow)
        if ti < 0 {
            ti = ti * -1
        }
        
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600) % 24
        let days = (ti / 3600) / 24
        
        var str = "\(minutes)m"
        if hours > 0 {
            str = "\(hours)h " + str
        }
        if days > 0 {
            str = "\(days)d " + str
        }
        
        return str
    }
}