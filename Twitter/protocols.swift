//
//  protocols.swift
//  Twitter
//
//  Created by Amit Chowdhary on 9/27/14.
//  Copyright (c) 2014 Amit Chowdhary. All rights reserved.
//

import Foundation

protocol clientGeneratorDelegate {
    func clientCreated (client :OAuthSwiftClient) -> ()
}