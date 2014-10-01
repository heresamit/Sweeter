//
//  UserListViewController.swift
//  Twitter
//
//  Created by Amit Chowdhary on 10/1/14.
//  Copyright (c) 2014 Amit Chowdhary. All rights reserved.
//

import UIKit

class UserListViewController: UITableViewController {
    var mainUser: User!
    var users: Array<User> = Array<User>()
    
    func loadUsers() {
        RequestHandler.sharedInstance.getFollowers(self.mainUser.id, count: 100, onUserLoad: {
            user in
            self.users.append(user)
            self.tableView.reloadData()
        })
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadUsers()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("userCell", forIndexPath:indexPath) as UserCell
        var user = users[indexPath.row]
        cell.nameLabel?.text = user.name
        cell.screenNameLabel?.text = "@" + user.screenName
        if let data = user.avatarData {
            cell.imageView?.image = UIImage(data: data)
        }
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 75
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("UserProfileVC") as UserProfileViewController
        vc.user = users[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
}