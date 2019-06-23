//
//  PhotosResponse.swift
//  Flicker
//
//  Created by Amr fawzy on 6/18/19.
//  Copyright © 2019 Amr fawzy. All rights reserved.
//

import Foundation


struct AllPhotos : Codable {
    var photos : Photos
}

struct Photos : Codable {
    var pages : Int
    var photo : [Photo]
}

struct Photo : Codable {
    var id : String
    var secret : String
    var server : String
    var farm : Int
    
    var photoUrl: URL {
        return URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_m.jpg")!
    }
}
