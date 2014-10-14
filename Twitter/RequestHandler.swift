//
//  RequestHandler.swift
//  Twitter
//
//  Created by Amit Chowdhary on 9/28/14.
//  Copyright (c) 2014 Amit Chowdhary. All rights reserved.
//

import Foundation
import UIKit

private let _SingletonASharedInstance = RequestHandler()

class RequestHandler: ClientGeneratorDelegate  {
    
    var client: OAuthSwiftClient?
    var isReady: Bool = false
    
    class var sharedInstance : RequestHandler {
    return _SingletonASharedInstance
    }
    
    init() {
        let clientGenerator = ClientGenerator(delegate: self)
        clientGenerator.generateClient()
    }
    
    func clientCreated(client: OAuthSwiftClient) {
        self.client = client
        self.isReady = true
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isAuthenticated")
        NSNotificationCenter.defaultCenter().postNotification(
            NSNotification(name: RequestHandlerIsReadyNotification,
                object: nil,
                userInfo: nil))
    }
    
    func getUserInfo(id: NSNumber, onCompletion:(userDict: NSDictionary?) -> ()) {
        if isReady {
            client!.get("https://api.twitter.com/1.1/users/show.json",
                parameters: ["user_id" : id],
                success: {
                    data, response in
                    onCompletion(userDict: NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary)
                },
                failure: {
                    error in
            })
        }
    }
    
    func downloadImage(urlString: String, onDownload:(downloadedImageData: NSData) -> ()) {
        let request = NSURLRequest(URL: NSURL(string:urlString))
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
            response, data, error in
            onDownload(downloadedImageData:data)
        }
    }
    
    func getTimeline(url: String, params: Dictionary<String, AnyObject>, onCompletion: (tweets: NSArray?)->()) {
        client!.get(url,
            parameters: params,
            success: {
                data, response in
                onCompletion(tweets: NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSArray)
            },
            failure: {
                _ in
            }
        )
    }
    
    func fetchAuthoredTweetsForUser(user: User, maxID: NSNumber?, onCompletion: (tweets: NSArray?)->()) {
        if isReady {
            var params: Dictionary<String, AnyObject> = ["count" : 20]
            if maxID != nil {
                params["max_id"] = maxID!
            }
            getTimeline("https://api.twitter.com/1.1/statuses/user_timeline.json",
                params:["user_id" : user.id],
                onCompletion: {
                    tweets in
                    for tweet in tweets! {
                        TweetParser.parseToTweet(tweet as NSDictionary)
                    }
            })
        }
    }
    
    func fetchVisibleTweetsForMainUser(maxID: NSNumber?) {
        if isReady {
            var params: Dictionary<String, AnyObject> = ["count" : 20]
            if maxID != nil {
                params["max_id"] = maxID!
            }
            
            getTimeline("https://api.twitter.com/1.1/statuses/home_timeline.json",
                params: params,
                onCompletion: {
                    tweets in
                    let mainUser = User.userForID(getMainUserId())
                    if tweets != nil && mainUser != nil {
                        for tweetDict in tweets! {
                            let tweet = TweetParser.parseToTweet(tweetDict as NSDictionary)
                            mainUser!.visibleTweets.addObject(tweet)
                            tweet.visibleTo = mainUser!
                        }
                        delegate.saveContext()
                    }
            })
        }
    }
    
    func fetchFollowersForUser(requestingUser: User, onUserLoad:(user: User) -> ()) {
        if isReady && requestingUser.nextFollowersCursor!.longLongValue != 0 {
            client!.get("https://api.twitter.com/1.1/followers/list.json",
                parameters: [
                    "user_id" : requestingUser.id,
                    "skip_status" : 1,
                    "cursor" : requestingUser.nextFollowersCursor!
                ],
                success: {
                    data, response in
                    if let userIDsDict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary {
                        if let nextCursor = userIDsDict["next_cursor"] as? NSNumber {
                            if let users = userIDsDict["users"] as? NSArray {
                                for user in users {
                                    if let userDict = user as? NSDictionary {
                                        
                                        var fetchedUser: User?
                                        
                                        if let existingUser = User.userForID(Double(userDict["id"] as NSNumber)) {
                                            fetchedUser = existingUser
                                        } else {
                                            if let newUser = User.userFromJsonDict(userDict) {
                                                fetchedUser = newUser
                                            } else {
                                                fetchedUser = nil
                                            }
                                        }
                                        
                                        if fetchedUser != nil {
                                            requestingUser.followers.addObject(fetchedUser!)
                                            fetchedUser!.followed.addObject(requestingUser)
                                            onUserLoad(user: fetchedUser!)
                                        }
                                    }
                                    
                                }
                            }
                            requestingUser.nextFollowersCursor = nextCursor
                            delegate.saveContext()
                        }
                    }
                },
                failure: {
                    _ in
            })
            
        }
    }
    
}



