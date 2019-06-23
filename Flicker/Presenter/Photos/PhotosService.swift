//
//  PhotosService.swift
//  Flicker
//
//  Created by Amr fawzy on 6/22/19.
//  Copyright © 2019 Amr fawzy. All rights reserved.
//

import Foundation
import Alamofire
import os.log

class PhotosService {
    
    typealias completion = (_ pictures: AllPhotos?, _ error: Error?) -> Void
    var test: Bool = false
    
    /// send http get request for photos
    func getPhotos(page: Int = 1, text: String, completion: @escaping completion) {
        os_log(.info, "get photos ...")
        
        if test {
            
            let fileUrl = Bundle.main.url(forResource: "photos", withExtension: "json")!
            let data = try! Data.init(contentsOf: fileUrl)
            parseData(data, completion: completion)
            
        } else {
            
            let url = URLs.photos
            let parameters: Parameters = [
                "api_key": FLICKER_API_KEY,
                "format": "json",
                "nojsoncallback": 1,
                "fbclid": FLICKET_FBCLID,
                "page": page,
                "text": text
            ]
            
            Alamofire.request(url, parameters: parameters)
                .responseJSON { (response) in
                    switch response.result {
                    case .failure(let error):
                        os_log(.error, "get photos response error")
                        completion(nil, error)
                        
                    case .success(_):
                        os_log(.info, "get photos response success")
                        self.parseData(response.data!, completion: completion)
                    }
            }
            
        }
    }
    
    /// parsing data for photos

    private func parseData(_ data: Data, completion: @escaping completion) {
        do {
            let allPhotos = try JSONDecoder().decode(AllPhotos.self, from: data)
            os_log(.info, "get photos parsing json success")
            completion(allPhotos, nil)
        } catch {
            os_log(.error, "get photos parsing json error")
            completion(nil, error)
        }
    }
    
}
