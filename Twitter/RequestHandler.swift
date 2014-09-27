//
//  RequestHandler.swift
//  Twitter
//
//  Created by Amit Chowdhary on 9/28/14.
//  Copyright (c) 2014 Amit Chowdhary. All rights reserved.
//

import Foundation

private let _SingletonASharedInstance = RequestHandler()

class RequestHandler: ClientGeneratorDelegate  {
    
    var client: OAuthSwiftClient = OAuthSwiftClient()
    var isReady: Bool = false
    
    class var sharedInstance : RequestHandler {
        return _SingletonASharedInstance
    }
    
    init() {
        let cg = ClientGenerator(delegate: self)
        cg.generateClient()
    }
    
    func clientCreated(client: OAuthSwiftClient) {
        self.client = client
        self.isReady = true
    }
}


