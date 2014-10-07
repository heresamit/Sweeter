//
//  NFRCTableViewController.swift
//  Twitter
//
//  Created by Amit Chowdhary on 10/3/14.
//  Copyright (c) 2014 Amit Chowdhary. All rights reserved.
//

import UIKit
import CoreData

class NFRCTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    var fetchedResultController: NSFetchedResultsController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchedResultController = getFetchedResultController()
        fetchedResultController.delegate = self
        fetchedResultController.performFetch(nil)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultController.sections!.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultController.sections![section].numberOfObjects
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController!) {
        tableView.reloadData()
    }
    
    func getFetchedResultController() -> NSFetchedResultsController {
        fetchedResultController = NSFetchedResultsController(fetchRequest: taskFetchRequest(), managedObjectContext: delegate.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultController
    }
    
    func taskFetchRequest() -> NSFetchRequest {
        fatalError("This method must be overridden")
    }
    
}

