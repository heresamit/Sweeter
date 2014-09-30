//
//  Tweet.swift
//  Twitter
//
//  Created by Amit Chowdhary on 9/30/14.
//  Copyright (c) 2014 Amit Chowdhary. All rights reserved.
//

import Foundation

class Tweet {
    var creator: User?
    var createdAt: NSDate?
    var text: String?
    var id: Int
    
    init(id: Int) {
        self.id = id
    }
    
    convenience init() {
        self.init(id: -1)
    }
    
}