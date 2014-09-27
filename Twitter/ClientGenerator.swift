//
//  Authenticator.swift
//  Twitter
//
//  Created by Amit Chowdhary on 9/27/14.
//  Copyright (c) 2014 Amit Chowdhary. All rights reserved.
//

import Foundation

class ClientGenerator {
    
    var credentials: OAuthSwiftCredential = OAuthSwiftCredential()
    var delegate: ClientGeneratorDelegate
    
    init(delegate: ClientGeneratorDelegate) {
        self.delegate = delegate
    }
    
    private func loadCredentialsFromUserDefaults() {
        
        let keyArray = ["consumerKey", "consumerSecret", "oauthVerifier", "oauthToken", "oauthTokenSecret"]
        
        var i = 0
        for key in keyArray {
            if let val = NSUserDefaults.standardUserDefaults().objectForKey(key) as? NSString {
                
                switch (i++) {
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
        Authenticator.performOAuth() {
            credential in
            self.credentials = credential
            self.delegate.clientCreated(OAuthSwiftClient(credential: credential))
        }
    }
    
    func generateClient() {
        
        loadCredentialsFromUserDefaults()

        if !credentials.isUsable() {
            regenerateCredentials()
        } else {
            delegate.clientCreated(OAuthSwiftClient(credential: credentials))
        }
    }
}
