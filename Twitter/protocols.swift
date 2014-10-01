//
//  protocols.swift
//  Twitter
//
//  Created by Amit Chowdhary on 9/27/14.
//  Copyright (c) 2014 Amit Chowdhary. All rights reserved.
//

import UIKit

let RequestHandlerIsReadyNotification = "RequestHandlerIsReadyNotification"
let UserImageUpdatedNotification = "UserImageUpdatedNotification"

let storyboard = UIStoryboard(name: "Main", bundle: nil)
let delegate = UIApplication.sharedApplication().delegate as AppDelegate

protocol ClientGeneratorDelegate {
    func clientCreated (client :OAuthSwiftClient) -> ()
}

protocol RequestHandlerUser {
    var requestHandlerReadyNotificationObserver: AnyObject? { get set }
    func requestHandlerIsReady()
}

func isAuthenticated() -> Bool {
    return NSUserDefaults.standardUserDefaults().boolForKey("isAuthenticated")
}

func getMainUserId() -> (Double) {
    return NSUserDefaults.standardUserDefaults().doubleForKey("mainUserId")
}

func saveMainUserToUserDefaults(id: Double, screenName: String) {
    println(id)
    NSUserDefaults.standardUserDefaults().setDouble(id, forKey: "mainUserId")
    NSUserDefaults.standardUserDefaults().setObject(screenName, forKey: "mainUserScreenName")
    NSUserDefaults.standardUserDefaults().synchronize()
}