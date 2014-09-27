//
//  User.swift
//  Twitter
//
//  Created by Amit Chowdhary on 9/28/14.
//  Copyright (c) 2014 Amit Chowdhary. All rights reserved.
//

import Foundation

class User {
    var screenName: String = String()
    var id: String = String()
    
    init() {
        
    }
    
    init(id: String, screenName: String) {
        self.screenName = screenName
        self.id = id
    }
}
