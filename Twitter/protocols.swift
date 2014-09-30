//
//  protocols.swift
//  Twitter
//
//  Created by Amit Chowdhary on 9/27/14.
//  Copyright (c) 2014 Amit Chowdhary. All rights reserved.
//

import Foundation

let RequestHandlerIsReadyNotification = "RequestHandlerIsReadyNotification"
let UserImageUpdatedNotification = "UserImageUpdatedNotification"

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

func getMainUser() -> User {
    let mainUserName: String = NSUserDefaults.standardUserDefaults().objectForKey("mainUserScreenName") as String
    let mainUserId = NSUserDefaults.standardUserDefaults().integerForKey("mainUserId")
    return User(id: mainUserId, screenName: mainUserName)
}

func saveMainUserToUserDefaults(id: Int, screenName: String) {
    NSUserDefaults.standardUserDefaults().setInteger(id, forKey: "mainUserId")
    NSUserDefaults.standardUserDefaults().setObject(screenName, forKey: "mainUserScreenName")
    NSUserDefaults.standardUserDefaults().synchronize()
}