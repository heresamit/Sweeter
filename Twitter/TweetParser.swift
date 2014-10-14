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
        let id = tweetJson["id"] as NSNumber
        if let tweet = Tweet.tweetForID(id) {
            return tweet
        } else {
            return Tweet.newTweet {
                tweet in
                
                tweet.id = id
                tweet.text = tweetJson["text"] as? String
                tweet.createdAt = self.dateFromString(tweetJson["created_at"] as String)

                let userDict = tweetJson["user"] as NSDictionary
                
                if let user = User.userForID(Double(userDict["id"] as NSNumber)) {
                    self.setCreatorForTweet(tweet, creator: user)
                } else {
                    if let user = User.userFromJsonDict(userDict) {
                        self.setCreatorForTweet(tweet, creator: user)
                    }
                }
                
                if let entitiesDict = tweetJson["entities"] as? NSDictionary {
                    if let mediaArray = entitiesDict["media"] as? NSArray {
                        for mediaDict in mediaArray {
                            let dict = mediaDict as NSDictionary
                            tweet.containedMedia.addObject(Media.newMedia(dict, containedIn: tweet)!)
                        }
                    }
                }
            }
        }
    }
    
    private class func dateFromString(dateStr: String) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
        return dateFormatter.dateFromString(dateStr)!
    }
    
    private class func setCreatorForTweet(tweet: Tweet, creator: User) {
        tweet.creator = creator
        creator.authoredTweets.addObject(tweet)
    }
    
}