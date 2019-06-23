//
//  PhotosView.swift
//  Flicker
//
//  Created by Amr fawzy on 6/22/19.
//  Copyright © 2019 Amr fawzy. All rights reserved.
//

import Foundation

protocol PhotosView: NSObjectProtocol {
    func startLoading()
    func finishLoading()
    func didFetchPhotos()
    func didFetchLastState()
    func didFailWithError(_ error: Error)
}
