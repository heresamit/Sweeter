//
//  User.swift
//  Twitter
//
//  Created by Amit Chowdhary on 9/28/14.
//  Copyright (c) 2014 Amit Chowdhary. All rights reserved.
//

import Foundation
import UIKit

class User {
    var screenName: String = String()
    var id: Int = -1
    var name: String?
    var location: String?
    var description: String?
    var imageURL: String?
    var image: UIImage?
    var avatar:UIImage?
    
    init(id: Int, screenName: String) {
        self.screenName = screenName
        self.id = id
    }
    
    convenience init(id: Int, screenName: String, name: String?, location: String?, description: String?, imageURL: String?) {
        self.init(id: id, screenName: screenName)
        
        self.name = name
        self.location = location
        self.description = description
        self.image = nil
        if imageURL != nil {
            self.imageURL = imageURL
            updateAvatar()
            updateImage()
        }
    }
    
    func updateAvatar() {
        if let url = imageURL {
            RequestHandler.sharedInstance.downloadImage(url) {
                img in
                self.avatar = img
            }
        }
    }
    
    func updateImage() {
        if let url = imageURL {
            let profilePicURL = self.imageURL!.stringByReplacingOccurrencesOfString("_normal", withString: "")
            RequestHandler.sharedInstance.downloadImage(profilePicURL) {
                img in
                self.image = img
                NSNotificationCenter.defaultCenter().postNotification(
                    NSNotification(name: UserImageUpdatedNotification,
                        object: nil,
                        userInfo: ["user" : self]))
            }
        }
    }
    
    class func userFromJsonDict(userDict: NSDictionary) -> User?{
        return User(id: userDict["id"] as Int,
            screenName: userDict["screen_name"] as String,
            name: userDict["name"] as? String,
            location: userDict["location"] as? String,
            description: userDict["description"] as? String,
            imageURL: userDict["profile_image_url"] as? String)
    }
    
    class func exists(id: Int) -> Bool {
        return false
    }
    
}
