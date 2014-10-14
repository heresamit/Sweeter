//
//  TweetsTableViewController.swift
//  Twitter
//
//  Created by Amit Chowdhary on 9/30/14.
//  Copyright (c) 2014 Amit Chowdhary. All rights reserved.
//

import UIKit
import CoreData

class TweetsTableViewController: NFRCTableViewController {
    var user: User!
    var displayingMainUser: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as TweetCell
        var tweet = fetchedResultController.objectAtIndexPath(indexPath) as Tweet
        
        if let data = tweet.creator.avatarData {
            cell.imgView.image = UIImage(data: data)
        }
        
        cell.screenNameLabel.text = "@" + tweet.creator.screenName
        cell.nameLabel.text = tweet.creator.name
        cell.tweetTextLabel.text = tweet.text
        
        return cell
    }
    
    override func taskFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "Tweet")
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        if displayingMainUser {
            fetchRequest.predicate = NSPredicate(format: "visibleTo.id == %@", user.id)
        } else {
            fetchRequest.predicate = NSPredicate(format: "creator.id == %@", user.id)
        }
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = UIStoryboard(name: MainStoryboardName, bundle: nil).instantiateViewControllerWithIdentifier(TweetViewControllerID) as TweetViewController
        vc.tweet = fetchedResultController.objectAtIndexPath(indexPath) as? Tweet
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == fetchedResultController.fetchedObjects!.count - 1 {
            var tweet = fetchedResultController.objectAtIndexPath(indexPath) as Tweet
            if displayingMainUser {
                RequestHandler.sharedInstance.fetchVisibleTweetsForMainUser(tweet.id)
            } else {
                RequestHandler.sharedInstance.fetchAuthoredTweetsForUser(user!, maxID: tweet.id, { _ in })
            }
        }
    }
    
}

