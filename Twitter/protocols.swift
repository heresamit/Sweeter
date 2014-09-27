//
//  protocols.swift
//  Twitter
//
//  Created by Amit Chowdhary on 9/27/14.
//  Copyright (c) 2014 Amit Chowdhary. All rights reserved.
//

import Foundation

let RequestHandlerIsReadyNotification = "RequestHandlerIsReadyNotification"

protocol ClientGeneratorDelegate {
    func clientCreated (client :OAuthSwiftClient) -> ()
}

protocol RequestHandlerUser {
    var observer: AnyObject? { get set }
    func requestHandlerIsReady()
}

func isFirstRun() -> Bool {
    if !NSUserDefaults.standardUserDefaults().boolForKey("notFirstRun") {
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "notFirstRun")
        return true
    }
    return false
}

func getMainUser() -> User {
    let mainUserName: String = NSUserDefaults.standardUserDefaults().objectForKey("mainUserScreenName") as String
    let mainUserId: String = NSUserDefaults.standardUserDefaults().objectForKey("mainUserId") as String
    return User(id: mainUserId, screenName: mainUserName)
}