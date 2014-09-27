//
//  UserProfileViewController.swift
//  Twitter
//
//  Created by Amit Chowdhary on 9/27/14.
//  Copyright (c) 2014 Amit Chowdhary. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController, RequestHandlerUser {
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    
    var user: User?
    var observer: AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if RequestHandler.sharedInstance.isReady {
            requestHandlerIsReady()
        } else {
            
            let notificationCenter = NSNotificationCenter.defaultCenter()
            let mainQueue = NSOperationQueue.mainQueue()
            
            self.observer = notificationCenter.addObserverForName(RequestHandlerIsReadyNotification, object: nil, queue: mainQueue) { _ in
                self.requestHandlerIsReady()
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func requestHandlerIsReady() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        idLabel.text = user?.id
        screenNameLabel.text = user?.screenName
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self.observer!)
    }
}

