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
        let cg = ClientGenerator(delegate: self)
        cg.generateClient()
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
    
    func getUserInfo(id: Int, onCompletion:(userDict: NSDictionary?) -> ()) {
        if isReady {
            client!.get("https://api.twitter.com/1.1/users/show.json",
                parameters: ["user_id" : id],
                success: {
                    data, response in
                    onCompletion(userDict: NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary)
                },
                failure: {
            _ in})
        }
    }
    
    func downloadImage(urlString: String, onDownload:(downloadedImage: UIImage) -> ()) {
        let request = NSURLRequest(URL: NSURL(string:urlString))
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
            response, data, error in
            onDownload(downloadedImage: UIImage(data: data))
        }
    }
    
    func getHomeTimeline(count: Int, onCompletion: (tweets: NSArray?)->()) {
        if isReady {
            client!.get("https://api.twitter.com/1.1/statuses/home_timeline.json",
                parameters: [
                    "count" : count
//                    "trim_user" : true
                ],
                success: {
                    data, response in
                    onCompletion(tweets: NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSArray)
                },
                failure: {
                    _ in})
        }
    }
}


