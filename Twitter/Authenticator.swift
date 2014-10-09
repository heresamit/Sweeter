//
//  Authenticator.swift
//  Twitter
//
//  Created by Amit Chowdhary on 9/27/14.
//  Copyright (c) 2014 Amit Chowdhary. All rights reserved.
//

import Foundation

let requestTokenURLString = "https://api.twitter.com/oauth/request_token"
let authorizURLString = "https://api.twitter.com/oauth/authorize"
let accessTokenURLString = "https://api.twitter.com/oauth/access_token"
let callbackURLString = "sweeter://oauth-callback/twitter"

class Authenticator {
    
    class func performOAuth(onAuthentication: (credential: OAuthSwiftCredential) -> ()) {
        if let path = NSBundle.mainBundle().pathForResource("credentials", ofType: "plist") {
            
            let credentials = NSDictionary(contentsOfFile: path)
            
            var oauthswift = OAuth1Swift(
                consumerKey: credentials["consumerKey"] as String,
                consumerSecret: credentials["consumerSecret"] as String,
                requestTokenUrl: requestTokenURLString,
                authorizeUrl: authorizURLString,
                accessTokenUrl: accessTokenURLString
            )
            
            oauthswift.authorizeWithCallbackURL( NSURL(string: callbackURLString), success: {
                credential, response in
                credential.saveToUserDefaults()
                onAuthentication(credential: credential)
                }, failure: {(error:NSError!) -> Void in
                    println(error.localizedDescription)
            })
            
        } else {
            println("credentials.plist not found")
        }
    }
    
}