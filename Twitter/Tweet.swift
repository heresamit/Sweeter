//
//  Tweet.swift
//  Twitter
//
//  Created by Amit Chowdhary on 9/30/14.
//  Copyright (c) 2014 Amit Chowdhary. All rights reserved.
//

import Foundation
import CoreData

@objc(Tweet)
class Tweet: NSManagedObject {
    
    @NSManaged var creator: User
    @NSManaged var visibleTo: User?
    @NSManaged var createdAt: NSDate
    @NSManaged var text: String?
    @NSManaged var id: NSNumber
    
    var containedMedia: NSMutableSet {
        get {
            return self.mutableSetValueForKey("containedMedia")
        }
    }
    
    class func newTweet(configurationBlock:(tweet: Tweet) -> ()) -> Tweet {
        let moc = delegate.managedObjectContext
        let tweet = NSEntityDescription.insertNewObjectForEntityForName("Tweet", inManagedObjectContext: moc!) as Tweet
        configurationBlock(tweet: tweet)
        delegate.saveContext()
        return tweet
    }
    
    class func tweetForID(id: NSNumber) -> Tweet? {
        let request = NSFetchRequest(entityName: "Tweet")
        request.predicate = NSPredicate(format:"id == \(id.longLongValue)")
        let moc = delegate.managedObjectContext
        let result = moc!.executeFetchRequest(request, error: nil) as [Tweet]
        if !result.isEmpty {
            return result[0]
        }
        return nil
    }
}

