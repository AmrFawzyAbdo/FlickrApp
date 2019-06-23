//
//  GroupsService.swift
//  Flicker
//
//  Created by Amr fawzy on 6/22/19.
//  Copyright © 2019 Amr fawzy. All rights reserved.
//

import Foundation
import Alamofire
import os.log

class GroupsService {
    
    typealias completion = (_ allGroups: AllGroups?, _ error: Error?) -> Void
    var test = false
    
    /// send http get request for groups
    
    func getGroups(page: Int = 1, text: String, completion: @escaping completion) {
        
        if test {
            
            let fileUrl = Bundle.main.url(forResource: "groups", withExtension: "json")!
            let data = try! Data.init(contentsOf: fileUrl)
            parseData(data, completion: completion)
            
        } else {
            
            let url = URLs.groups
            let parameters: Parameters = [
                "api_key": FLICKER_API_KEY,
                "format": "json",
                "nojsoncallback": 1,
                "page": page,
                "text": text
            ]
            
            Alamofire.request(url, parameters: parameters)
                .responseJSON { (response) in
                    switch response.result {
                    case .failure(let error):
                        os_log(.error, "get groups response error")
                        completion(nil, error)
                        
                    case .success(_):
                        os_log(.info, "get groups response success")
                        self.parseData(response.data!, completion: completion)
                    }
            }
            
        }
    }
    
    /// parsing data for groups
    
    private func parseData(_ data: Data, completion: @escaping completion) {
        do {
            let allPhotos = try JSONDecoder().decode(AllGroups.self, from: data)
            os_log(.info, "get groups parsing json success")
            completion(allPhotos, nil)
        } catch {
            os_log(.error, "get groups parsing json error")
            completion(nil, error)
        }
    }
    
}
