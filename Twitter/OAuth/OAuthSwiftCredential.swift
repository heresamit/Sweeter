//
//  OAuthSwiftCredential.swift
//  OAuthSwift
//
//  Created by Dongri Jin on 6/22/14.
//  Copyright (c) 2014 Dongri Jin. All rights reserved.
//


class OAuthSwiftCredential {
    
    var consumer_key: String = String()
    var consumer_secret: String = String()
    var oauth_token: String = String()
    var oauth_token_secret: String = String()
    var oauth_verifier: String = String()
    
    init() {
        
    }
    
    init(consumer_key: String, consumer_secret: String){
        self.consumer_key = consumer_key
        self.consumer_secret = consumer_secret
    }
    
    init(oauth_token: String, oauth_token_secret: String){
        self.oauth_token = oauth_token
        self.oauth_token_secret = oauth_token_secret
    }
    
    func isUsable () -> Bool {
        return !consumer_key.isEmpty && !oauth_token.isEmpty
    }
    
    func saveToUserDefaults() {
        NSUserDefaults.standardUserDefaults().setObject(consumer_key, forKey: "consumerKey")
        NSUserDefaults.standardUserDefaults().setObject(consumer_secret, forKey: "consumerSecret")
        NSUserDefaults.standardUserDefaults().setObject(oauth_verifier, forKey: "oauthVerifier")
        NSUserDefaults.standardUserDefaults().setObject(oauth_token, forKey: "oauthToken")
        NSUserDefaults.standardUserDefaults().setObject(oauth_token_secret, forKey: "oauthTokenSecret")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}
