//
//  TweetViewController.swift
//  Twitter
//
//  Created by Amit Chowdhary on 10/8/14.
//  Copyright (c) 2014 Amit Chowdhary. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {
    
    var tweet: Tweet!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleButton: UIButton!
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    
    @IBAction func handleButtonPressed(sender: AnyObject) {
        let vc = UIStoryboard(name: MainStoryboardName, bundle: nil).instantiateViewControllerWithIdentifier(UserProfileViewControllerID) as UserProfileViewController
        vc.user = tweet.creator
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateView()
    }
    
    func updateView() {
        nameLabel.text = tweet.creator.name
        handleButton.setTitle("@" + tweet.creator.screenName, forState: .Normal)
        avatarView.image = UIImage(data: tweet.creator.avatarData!)
        textLabel.text = tweet.text
        timeLabel.text = tweet.createdAt.humanReadableTimeSinceNowString() + " ago"
        if let media = tweet.containedMedia.anyObject() as? Media {
            media.updateData {
                self.imageView.image = UIImage(data: media.data)
            }
        }
    }
}