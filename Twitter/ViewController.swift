//
//  ViewController.swift
//  Twitter
//
//  Created by Amit Chowdhary on 9/27/14.
//  Copyright (c) 2014 Amit Chowdhary. All rights reserved.
//

import UIKit

class ViewController: UIViewController, RequestHandlerUser {
    
    var requestHandlerReadyNotificationObserver: AnyObject?

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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var  vc = storyboard.instantiateViewControllerWithIdentifier("UserProfileVC") as UserProfileViewController
        vc.user = getMainUser()
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self.requestHandlerReadyNotificationObserver!)
    }
}

