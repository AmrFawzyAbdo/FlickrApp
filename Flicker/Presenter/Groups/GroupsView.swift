//
//  GroupsView.swift
//  Flicker
//
//  Created by Amr fawzy on 6/22/19.
//  Copyright © 2019 Amr fawzy. All rights reserved.
//

import Foundation

protocol GroupsView: NSObjectProtocol {
    func startLoading()
    func finishLoading()
    func didFetchGroups()
    func didFetchLastState()
    func didFailWithError(_ error: Error)
}
