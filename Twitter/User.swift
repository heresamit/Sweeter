//
//  User.swift
//  Twitter
//
//  Created by Amit Chowdhary on 9/28/14.
//  Copyright (c) 2014 Amit Chowdhary. All rights reserved.
//

import UIKit
import CoreData

@objc(User)
class User: NSManagedObject {
    
    @NSManaged var screenName: String
    @NSManaged var id: Double
    @NSManaged var name: String?
    @NSManaged var location: String?
    @NSManaged var userDescription: String?
    @NSManaged var imageURL: String?
    @NSManaged var imageData: NSData?
    @NSManaged var avatarData:NSData?

    func updateAvatar() {
        if let url = imageURL {
            RequestHandler.sharedInstance.downloadImage(url) {
                data in
                self.avatarData = data
                delegate.saveContext()
            }
        }
    }
    
    func updateImage() {
        if let url = imageURL {
            let profilePicURL = self.imageURL!.stringByReplacingOccurrencesOfString("_normal", withString: "")
            RequestHandler.sharedInstance.downloadImage(profilePicURL) {
                data in
                self.imageData = data
                delegate.saveContext()
                NSNotificationCenter.defaultCenter().postNotification(
                    NSNotification(name: UserImageUpdatedNotification,
                        object: nil,
                        userInfo: ["user" : self]))
            }
        }
    }
    
    class func userFromJsonDict(userDict: NSDictionary) -> User? {
        return newUser {
            user in
            user.id = Double(userDict["id"]! as NSNumber)
            user.screenName = userDict["screen_name"] as String
            user.name = userDict["name"] as? String
            user.location = userDict["location"] as? String
            user.userDescription = userDict["description"] as? String
            user.imageURL = userDict["profile_image_url"] as? String
            user.updateAvatar()
            user.updateImage()
            delegate.saveContext()
        }
    }
    
    class func userForID(id: Double) -> User? {
        let request = NSFetchRequest(entityName: "User")
        request.predicate = NSPredicate(format:"id == \(id)")
        let moc = delegate.managedObjectContext
        let result = moc!.executeFetchRequest(request, error: nil) as [User]
        if !result.isEmpty {
            return result[0]
        }
        return nil
    }
    
    class func newUser(configurationBlock:(user: User) -> ()) -> User {
        let moc = delegate.managedObjectContext
        let user = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: moc!) as User
        configurationBlock(user: user)
        return user
    }
    
}
