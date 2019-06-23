//
//  Groups.swift
//  Flicker
//
//  Created by Amr fawzy on 6/19/19.
//  Copyright © 2019 Amr fawzy. All rights reserved.
//

import Foundation


struct AllGroups : Codable {
    var groups : Groups
}

struct Groups : Codable {
    var pages : Int
    var group : [Group]
}


struct Group : Codable {
    var nsid : String
    var name : String
    var iconserver : String
    var iconfarm : Int
    var pool_count : String
    var topic_count : String
    var privacy : String
    var members : String
    
    var photoUrl: URL {
        return URL(string: "https://farm\(iconfarm).staticflickr.com/\(iconserver)/buddyicons/\(nsid)_r.jpg")!
    }
}
