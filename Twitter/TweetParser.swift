//
//  TweetParser.swift
//  Twitter
//
//  Created by Amit Chowdhary on 9/30/14.
//  Copyright (c) 2014 Amit Chowdhary. All rights reserved.
//

import Foundation

class TweetParser {
    class func parseToTweet(tweetJson: NSDictionary) -> Tweet {
        let tweet = Tweet(id: tweetJson["id"] as Int)
        tweet.text = tweetJson["text"] as? String
        //[TODO] Check if user already in database
        if !userExists(tweetJson["id"] as Int) {
            tweet.creator = User.userFromJsonDict(tweetJson["user"] as NSDictionary)
        }
        tweet.createdAt = dateFromString(tweetJson["created_at"] as String)
        return tweet
    }
    
    class func dateFromString(dateStr: String) -> NSDate? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "E MMM HH:mm:ss Z y"
        return dateFormatter.dateFromString(dateStr)
    }
    
    class func userExists(userID: Int) -> Bool {
        return false
    }
}