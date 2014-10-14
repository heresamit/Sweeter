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
let MainUserIDNSUserDefaultsKey = "mainUserId"
let MainUserScreenNameNSUserDefaultsKey = "mainUserScreenName"
let MainStoryboardName = "Main"
let AuthenticationViewControllerID = "AuthenticateVC"
let UserProfileViewControllerID = "UserProfileVC"
let TweetViewControllerID = "TweetViewController"
let TweetsTableViewControllerID = "TweetsTableViewController"
let UserListViewControllerID = "UserListViewController"

let delegate = UIApplication.sharedApplication().delegate as AppDelegate

protocol ClientGeneratorDelegate {
    func clientCreated (client :OAuthSwiftClient) -> ()
}

protocol RequestHandlerUser {
    var requestHandlerReadyNotificationObserver: AnyObject! { get set }
    func requestHandlerIsReady()
}

func getMainUserId() -> (NSNumber) {
    return NSUserDefaults.standardUserDefaults().objectForKey(MainUserIDNSUserDefaultsKey) as NSNumber
}

func saveMainUserToUserDefaults(id: NSNumber, screenName: String) {
    NSUserDefaults.standardUserDefaults().setObject(id, forKey: MainUserIDNSUserDefaultsKey)
    NSUserDefaults.standardUserDefaults().setObject(screenName, forKey: MainUserScreenNameNSUserDefaultsKey)
    NSUserDefaults.standardUserDefaults().synchronize()
}

extension NSDate {
    func humanReadableTimeSinceNowString() -> String {
        var timeInterval = Int64(self.timeIntervalSinceNow)
        if timeInterval < 0 {
            timeInterval = timeInterval * -1
        }
        
        let minutes = (timeInterval / 60) % 60
        let hours = (timeInterval / 3600) % 24
        let days = (timeInterval / 3600) / 24
        
        var timeIntervalString = "\(minutes)m"
        if hours > 0 {
            timeIntervalString = "\(hours)h " + timeIntervalString
        }
        if days > 0 {
            timeIntervalString = "\(days)d " + timeIntervalString
        }
        
        return timeIntervalString
    }
}