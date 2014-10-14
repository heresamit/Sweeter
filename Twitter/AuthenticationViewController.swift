//
//  ViewController.swift
//  Twitter
//
//  Created by Amit Chowdhary on 9/27/14.
//  Copyright (c) 2014 Amit Chowdhary. All rights reserved.
//

import UIKit

class AuthenticationViewController: UIViewController, RequestHandlerUser {
    
    var requestHandlerReadyNotificationObserver: AnyObject!

    @IBAction func authenticatePressed(sender: UIButton) {
        if RequestHandler.sharedInstance.isReady {
            requestHandlerIsReady()
        } else {
            
            let notificationCenter = NSNotificationCenter.defaultCenter()
            let mainQueue = NSOperationQueue.mainQueue()
            
            self.requestHandlerReadyNotificationObserver = notificationCenter.addObserverForName(RequestHandlerIsReadyNotification, object: nil, queue: mainQueue) { _ in
                self.requestHandlerIsReady()
            }
        }
    }
    
    func requestHandlerIsReady() {
        let storyboard = UIStoryboard(name: MainStoryboardName, bundle: nil)
        var mainUserProfileViewController = storyboard.instantiateViewControllerWithIdentifier(UserProfileViewControllerID) as UserProfileViewController
        mainUserProfileViewController.displayingMainUser = true
        mainUserProfileViewController.userID = getMainUserId()
        self.navigationController?.pushViewController(mainUserProfileViewController, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self.requestHandlerReadyNotificationObserver!)
    }
    
}

