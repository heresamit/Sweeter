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

class ClientGenerator {
    
    var credentials: OAuthSwiftCredential = OAuthSwiftCredential()
    var delegate: clientGeneratorDelegate
    
    init(delegate: clientGeneratorDelegate) {
        self.delegate = delegate
    }
    
    private func loadCredentialsFromUserDefaults() {
        
        let keyArray = ["consumerKey", "consumerSecret", "oauthVerifier", "oauthToken", "oauthTokenSecret"]
        
        var i = 0
        for key in keyArray {
            if let val = NSUserDefaults.standardUserDefaults().objectForKey(key) as? NSString {
                
                switch (i) {
                case 0:
                    credentials.consumer_key = val
                case 1:
                    credentials.consumer_secret = val
                case 2:
                    credentials.oauth_verifier = val
                case 3:
                    credentials.oauth_token = val
                case 4:
                    credentials.oauth_token_secret = val
                default:
                    break
                }
            }
        }
    }
    
    private func regenerateCredentials() {
        
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
                    self.credentials = credential
                    self.credentials.saveToUserDefaults()
                    self.informDelegate()
                }, failure: {(error:NSError!) -> Void in
                    println(error.localizedDescription)
            })
            
        } else {
            println("credentials.plist not found")
        }
    }
    
    func informDelegate() {
        delegate.clientCreated(OAuthSwiftClient(credential: credentials))
    }
    
    func generateClient() {
        
        loadCredentialsFromUserDefaults()
        
        if !credentials.isUsable() {
            regenerateCredentials()
        } else {
            informDelegate()
        }
    }
}
