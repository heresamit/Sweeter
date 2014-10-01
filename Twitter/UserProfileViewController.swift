//
//  UserProfileViewController.swift
//  Twitter
//
//  Created by Amit Chowdhary on 9/27/14.
//  Copyright (c) 2014 Amit Chowdhary. All rights reserved.
//

import UIKit
import CoreData

class UserProfileViewController: UIViewController, RequestHandlerUser {
    
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var imageDownloadingActivityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var user: User?
    var requestHandlerReadyNotificationObserver: AnyObject?
    var userImageUpdatedNotificationObserver: AnyObject?
    var canShowStatuses: Bool = false
    var displayingMainUser: Bool = false
    var userID: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imgView.layer.masksToBounds = true
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        let mainQueue = NSOperationQueue.mainQueue()
        
        self.userImageUpdatedNotificationObserver = notificationCenter.addObserverForName(UserImageUpdatedNotification, object: nil, queue: mainQueue) {
            notification in
            if let updatedUser = notification.userInfo?["user"] as? User {
                if updatedUser.id == self.user!.id {
                    if let data =  self.user!.imageData {
                        self.imgView.image = UIImage(data: data)
                        self.imageDownloadingActivityIndicatorView.stopAnimating()
                        self.canShowStatuses = true
                    }
                }
            }
        }
        
        if RequestHandler.sharedInstance.isReady {
            requestHandlerIsReady()
        } else {
            self.requestHandlerReadyNotificationObserver = notificationCenter.addObserverForName(RequestHandlerIsReadyNotification, object: nil, queue: mainQueue) { _ in
                self.requestHandlerIsReady()
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    func requestHandlerIsReady() {
        if user == nil {
            if let tempUser = User.userForID(userID) {
                user = tempUser
                self.imgView.image = UIImage(data: user!.imageData!)
                self.imageDownloadingActivityIndicatorView.stopAnimating()
                self.canShowStatuses = true
                self.updateView()
            } else {
                downloadUser()
            }
        } else {
            updateView()
        }
    }
    
    func downloadUser() {
        RequestHandler.sharedInstance.getUserInfo(userID) {
            dictOptional in
            if let userDict = dictOptional {
                self.user = User.userFromJsonDict(userDict)
                self.updateView()
            }
        }
    }
    
    @IBAction func imageButtonPressed(sender: AnyObject) {
        if canShowStatuses {
            let onCompletion: (tweets: NSArray?)->() = {
                tweets in
                var tweetsArray: Array<Tweet> = [Tweet]()
                for tweet in tweets! {
                    tweetsArray.append(TweetParser.parseToTweet(tweet as NSDictionary))
                }
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                var  vc = storyboard.instantiateViewControllerWithIdentifier("TweetsTableViewController") as TweetsTableViewController
                vc.tweets = tweetsArray
                self.navigationController?.pushViewController(vc, animated: true)
            }
            //TODO Show saved Tweets first
            if displayingMainUser {
                RequestHandler.sharedInstance.getHomeTimeline(10, onCompletion: onCompletion)
            } else {
                RequestHandler.sharedInstance.getUserTimeline(user!.id, count: 10, onCompletion: onCompletion)
            }
        }
    }
    
    @IBAction func followersButtonPressed(sender: UIButton) {
        if canShowFollowers() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            var  vc = storyboard.instantiateViewControllerWithIdentifier("UserListViewController") as UserListViewController
            vc.mainUser = user!
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func canShowFollowers() -> Bool {
        //[TODO]
        return true
    }
    
    func updateView() {
        screenNameLabel.text = "@" + user!.screenName
        locationLabel.text = user!.location
        nameLabel.text = user!.name
    }
    
    override func viewDidLayoutSubviews() {
        imgView.layer.cornerRadius = imgView.frame.size.height / 2;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        if let obs: AnyObject = self.requestHandlerReadyNotificationObserver {
            NSNotificationCenter.defaultCenter().removeObserver(obs)
        }
        if let obs: AnyObject = self.userImageUpdatedNotificationObserver {
            NSNotificationCenter.defaultCenter().removeObserver(obs)
        }
    }
}

