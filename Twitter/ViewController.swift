//
//  ViewController.swift
//  Twitter
//
//  Created by Amit Chowdhary on 9/27/14.
//  Copyright (c) 2014 Amit Chowdhary. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let path = NSBundle.mainBundle().pathForResource("credentials", ofType: "plist") {
            let credentials = NSDictionary(contentsOfFile: path)
            println(credentials)
        } else {
            println("credentials.plist not found")
        }
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

