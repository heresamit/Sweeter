//
//  TweetsTableViewController.swift
//  Twitter
//
//  Created by Amit Chowdhary on 9/30/14.
//  Copyright (c) 2014 Amit Chowdhary. All rights reserved.
//

import UIKit

class TweetsTableViewController: UITableViewController {
    var tweets: Array<Tweet>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath:indexPath) as TweetCell
        var tweet = tweets[indexPath.row]
        
        cell.imgView.image = tweet.creator?.avatar
        cell.screenNameLabel.text = "@" + tweet.creator!.screenName
        cell.nameLabel.text = tweet.creator!.name
        cell.tweetTextLabel.text = tweet.text
        
        return cell
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }
    
}

