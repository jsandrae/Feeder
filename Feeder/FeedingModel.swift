//
//  Feeding.swift
//  Feeder
//
//  Created by Jason Andrae on 3/30/16.
//  Copyright © 2016 Jason Andrae. All rights reserved.
//
//  Code modified from Apple tutorial:
//  https://developer.apple.com/library/ios/referencelibrary/GettingStarted/DevelopiOSAppsSwift/Lesson10.html#//apple_ref/doc/uid/TP40015214-CH14-SW1
//

import UIKit

class FeedingModel: NSObject, NSCoding {
    
    // MARK: Properties
    var date: String?
    var user: String
    
    // MARK: Archiving Path
    static let Directory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = Directory.appendingPathComponent("feeding")
    
    // MARK: Key
    struct PropertyKey {
        static let dateKey = "date"
        static let userKey = "user"
    }
    
    // MARK: Initialization
    init?(username: String, date: String? = nil){
        self.user = username
        if let savedDate = date {
            self.date = savedDate
        } else {
            self.date = DateFormatter.localizedString(from: Date(), dateStyle: .medium , timeStyle: .short)
        }
        super.init()
    }
    
    // MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(user, forKey: PropertyKey.userKey)
        aCoder.encode(date, forKey: PropertyKey.dateKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let user = aDecoder.decodeObject(forKey: PropertyKey.userKey) as! String
        if let date = aDecoder.decodeObject(forKey: PropertyKey.dateKey) as? String {
            // Must call other initializer
            self.init(username: user, date: date)
        }
        else {
            self.init(username: user)
        }
    }
}
