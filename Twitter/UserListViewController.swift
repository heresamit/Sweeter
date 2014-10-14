//
//  UserListViewController.swift
//  Twitter
//
//  Created by Amit Chowdhary on 10/1/14.
//  Copyright (c) 2014 Amit Chowdhary. All rights reserved.
//

import UIKit
import CoreData

class UserListViewController: NFRCTableViewController {
    
    var user: User!
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("userCell", forIndexPath:indexPath) as UserCell
        var userToDisplay = fetchedResultController.objectAtIndexPath(indexPath) as User
        cell.nameLabel?.text = userToDisplay.name
        cell.screenNameLabel?.text = "@" + userToDisplay.screenName
        if let data = userToDisplay.avatarData {
            cell.imageView!.image = UIImage(data: data)
        }
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 75
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let userProfileViewController = UIStoryboard(name: MainStoryboardName, bundle: nil).instantiateViewControllerWithIdentifier(UserProfileViewControllerID) as UserProfileViewController
        userProfileViewController.user = fetchedResultController.objectAtIndexPath(indexPath) as? User
        navigationController?.pushViewController(userProfileViewController, animated: true)
    }
    
    override func taskFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "User")
        let sortDescriptor = NSSortDescriptor(key: "screenName", ascending: true)
        fetchRequest.predicate = NSPredicate(format: "ANY followed.id == %@", user.id)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == fetchedResultController.fetchedObjects!.count - 1 {
            RequestHandler.sharedInstance.fetchFollowersForUser(user, onUserLoad: { _ in })
        }
    }
    
}