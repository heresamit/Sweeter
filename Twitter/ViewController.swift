//
//  ViewController.swift
//  Twitter
//
//  Created by Amit Chowdhary on 9/27/14.
//  Copyright (c) 2014 Amit Chowdhary. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let path = NSBundle.mainBundle().pathForResource("credentials", ofType: "plist") {
            let credentials = NSDictionary(contentsOfFile: path)

            let oauthswift = OAuth1Swift(
                consumerKey:    credentials["consumerKey"] as String,
                consumerSecret: credentials["consumerSecret"] as String,
                requestTokenUrl: "https://api.twitter.com/oauth/request_token",
                authorizeUrl:    "https://api.twitter.com/oauth/authorize",
                accessTokenUrl:  "https://api.twitter.com/oauth/access_token"
            )

            oauthswift.authorizeWithCallbackURL( NSURL(string: "sweeter://oauth-callback/twitter"), success: {
                credential, response in
                println("Twitter", message: "auth_token:\(credential.oauth_token)\n\noauth_toke_secret:\(credential.oauth_token_secret)")
                }, failure: {(error:NSError!) -> Void in
                    println(error.localizedDescription)
            })
        } else {
            println("credentials.plist not found")
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

