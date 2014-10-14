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
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var user: User!
    var userID: NSNumber!
    var requestHandlerReadyNotificationObserver: AnyObject!
    var userImageUpdatedNotificationObserver: AnyObject!
    var canShowTweetsAndFollowers: Bool = false
    var displayingMainUser: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imgView.layer.masksToBounds = true
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        let mainQueue = NSOperationQueue.mainQueue()
        
        self.userImageUpdatedNotificationObserver = notificationCenter.addObserverForName(UserImageUpdatedNotification, object: nil, queue: mainQueue) {
            notification in
            if let updatedUser = notification.userInfo?["user"] as? User {
                if updatedUser.id == self.user!.id {
                    self.displayImage()
                }
            }
        }
        
        if RequestHandler.sharedInstance.isReady {
            requestHandlerIsReady()
        } else {
            self.requestHandlerReadyNotificationObserver = notificationCenter.addObserverForName(RequestHandlerIsReadyNotification, object: nil, queue: mainQueue) {
                _ in
                self.requestHandlerIsReady()
            }
        }
    }

    func requestHandlerIsReady() {
        if user == nil {
            if let tempUser = User.userForID(userID) {
                self.user = tempUser
                self.displayImage()
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
        if canShowTweetsAndFollowers {
            
            if displayingMainUser {
                RequestHandler.sharedInstance.fetchVisibleTweetsForMainUser(nil)
            } else {
                RequestHandler.sharedInstance.fetchAuthoredTweetsForUser(user!, maxID: nil, { _ in })
            }
            
            let storyboard = UIStoryboard(name: MainStoryboardName, bundle: nil)
            var  vc = storyboard.instantiateViewControllerWithIdentifier(TweetsTableViewControllerID) as TweetsTableViewController
            vc.user = user!
            vc.displayingMainUser = displayingMainUser
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func followersButtonPressed(sender: UIButton) {
        if readyToShowTweetsAndFollowers() {
            RequestHandler.sharedInstance.fetchFollowersForUser(user!, onUserLoad: { _ in })
            let storyboard = UIStoryboard(name: MainStoryboardName, bundle: nil)
            var followersViewController = storyboard.instantiateViewControllerWithIdentifier(UserListViewControllerID) as UserListViewController
            followersViewController.user = user
            self.navigationController?.pushViewController(followersViewController, animated: true)
        }
    }
    
    func readyToShowTweetsAndFollowers() -> Bool {
        return canShowTweetsAndFollowers
    }
    
    func updateView() {
        screenNameLabel.text = "@" + user!.screenName
        locationLabel.text = user!.location
        nameLabel.text = user!.name
        followersCountLabel.text = "\(user!.followersCount)"
        descriptionLabel.text = user!.userDescription!
        displayImage()
    }
    
    func displayImage() {
        if imgView.image == nil && user!.imageData != nil {
            imgView.image = UIImage(data: user!.imageData!)
            imageDownloadingActivityIndicatorView.stopAnimating()
            canShowTweetsAndFollowers = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        imgView.layer.cornerRadius = imgView.frame.size.height / 2;
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

