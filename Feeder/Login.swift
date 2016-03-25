//
//  Login.swift
//  Feeder
//
//  Created by Jason Andrae on 3/14/16.
//  Copyright © 2016 Jason Andrae. All rights reserved.
//

import Foundation

class Login: NSObject, NSCoding {
    
    // MARK: Properties
    var username: String
    var url: String
    
    // MARK: Archiving Paths
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("login")
    
    // MARK: Types
    struct PropertyKey {
        static let userKey = "username"
        static let urlKey = "url"
    }
    
    // MARK: Initialization
    init? (username: String, url: String){
        self.username = username
        self.url = url
        
        super.init()
        
        // Should return nil if username is an empty string
        if username.isEmpty {
            return nil
        }
    }
    
    // MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(username, forKey: PropertyKey.userKey)
        aCoder.encodeObject(url, forKey: PropertyKey.urlKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let username = aDecoder.decodeObjectForKey(PropertyKey.userKey) as! String
        let url = aDecoder.decodeObjectForKey(PropertyKey.urlKey) as! String
        
        // Must call other initializer
        self.init(username: username, url:url)
    }
}
