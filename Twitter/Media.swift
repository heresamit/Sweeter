//
//  Media.swift
//  Twitter
//
//  Created by Amit Chowdhary on 10/8/14.
//  Copyright (c) 2014 Amit Chowdhary. All rights reserved.
//

import Foundation
import CoreData

@objc(Media)
class Media: NSManagedObject {

    @NSManaged var id: NSNumber
    @NSManaged var url: String
    @NSManaged var data: NSData
    @NSManaged var containedIn: Tweet
    
    class func newMedia(dict: NSDictionary, containedIn: Tweet) -> Media? {
        
        let id = dict["id"]! as NSNumber
        
        if let savedMedia = self.mediaForID(id) {
            return savedMedia
        } else {
            let moc = delegate.managedObjectContext
            let media = NSEntityDescription.insertNewObjectForEntityForName("Media", inManagedObjectContext: moc!) as Media
            media.id = id
            media.url = dict["media_url"] as String
            media.containedIn = containedIn
            delegate.saveContext()
            return media
        }
    }

    class func mediaForID(id: NSNumber) -> Media? {
        let request = NSFetchRequest(entityName: "Media")
        request.predicate = NSPredicate(format:"id == \(id.longLongValue)")
        let moc = delegate.managedObjectContext
        let result = moc!.executeFetchRequest(request, error: nil) as [Media]
        if !result.isEmpty {
            return result[0]
        }
        return nil
    }
    
    func updateData(completionBlock: () -> ()) {
        RequestHandler.sharedInstance.downloadImage(url) {
            data in
            self.data = data
            delegate.saveContext()
            completionBlock()
        }
    }
    

}
