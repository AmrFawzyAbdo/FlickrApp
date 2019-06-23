//
//  GroupsPresenter.swift
//  Flicker
//
//  Created by Amr fawzy on 6/22/19.
//  Copyright © 2019 Amr fawzy. All rights reserved.
//

import Foundation
import os.log

class GroupsPresenter {
    
    /// keys to use with UserDefaults to save last search state
    private struct DefaultKeys {
        static let keyword = "groups_keyword"
        static let lastGroups = "last_groups"
    }
    
    // MARK: - Private
    private let groupsService: GroupsService
    weak private var groupsView: GroupsView?
    private var isLoading = false
    private var currentPage = 1
    private var lastPage = 1
    private var text: String = ""
    private var groups = [GroupViewData]()
    
    init(groupsService: GroupsService) {
        self.groupsService = groupsService
        
        // subscribe to app life cycle events for saving state before app terminated or becoming inactive
        NotificationCenter.default.addObserver(self, selector: #selector(saveState), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(saveState), name: NSNotification.Name.UIApplicationWillTerminate, object: nil)
    }
    
    deinit {
        // remove any observers to avoid memory leaks
        NotificationCenter.default.removeObserver(self)
    }
    
    /// save last search models & keyword to user defaults for next run
    
    @objc private func saveState() {
        os_log(.info, "Saving groups & keyword to user defaults before going inactive")
        if !text.isEmpty || !groups.isEmpty {
            let defaults = UserDefaults.standard
            defaults.set(text, forKey: DefaultKeys.keyword)
            
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(groups) {
                defaults.set(encoded, forKey: DefaultKeys.lastGroups)
            }
            os_log(.info, "Groups & keyword saved to user defaults")
        }
    }
    
    /// load last search models & keyword and notify view
    private func loadLastState() {
        os_log(.info, "Loading groups & keyword from user defaults")
        let defaults = UserDefaults.standard
        self.text = defaults.string(forKey: DefaultKeys.keyword) ?? ""
        
        if let lastGroupsData = defaults.object(forKey: DefaultKeys.lastGroups) as? Data {
            let decoder = JSONDecoder()
            if let lastGroups = try? decoder.decode([GroupViewData].self, from: lastGroupsData) {
                self.groups = lastGroups
                self.groupsView?.didFetchLastState()
                os_log(.info, "Groups & keyword from user defaults did finish loading")
            }
        }
    }
    
    /// get keyword
    
    func getText() -> String {
        return text
    }
    
    /// attach view to this presenter
    
    func attachView(view: GroupsView) {
        os_log(.info, "Attaching groups view to presenter")
        groupsView = view
        loadLastState()
    }
    
    /// detach view from presenter
    
    func detatchView() {
        os_log(.info, "Detaching groups view from presenter")
        groupsView = nil
    }
    
    /// set keyword and start fetching data
    
    func setText(_ text: String) {
        os_log(.info, "Start New Search for groups")
        guard !isLoading else { return }
        self.text = text
        getGroups(page: 1)
    }
    
    /// clear results
    
    func clear() {
        os_log(.info, "Clearing groups")
        groups = []
        currentPage = 1
    }
    
    /// load next page
    
    func getMoreGroups() {
        os_log(.info, "Loading more groups")
        getGroups(page: currentPage+1)
    }
    
    /// fetching photos from web service
    
    private func getGroups(page: Int = 1) {
        guard !isLoading else { return }
        if page > 1 {
            guard currentPage < lastPage else { return }
        }
        
        os_log(.info, "Fetching groups")
        
        self.isLoading = true
        self.groupsView?.startLoading()
        
        groupsService.getGroups(page: page, text: self.text) { [weak self] allGroups, error in
            self?.groupsView?.finishLoading()
            self?.isLoading = false
            
            guard let allGroups = allGroups, error == nil else {
                os_log(.error, "Did finish fetching groups with error")
                self?.groupsView?.didFailWithError(error!)
                return
            }
            
            let groups = allGroups.groups.group.map {
                return GroupViewData(
                    photoUrl: $0.photoUrl,
                    name: $0.name,
                    members: "Number of members are: \($0.members)",
                    count: "Count: \($0.pool_count)",
                    topicCount: "Topic Count: \($0.topic_count)"
                )
            }
            if page == 1 {
                self?.groups = groups
            } else {
                self?.groups.append(contentsOf: groups)
            }
            
            self?.groupsView?.didFetchGroups()
            self?.currentPage = page
            self?.lastPage = allGroups.groups.pages
            os_log(.info, "Did finish fetching groups successfully")
        }
    }
    
    func getGroupsCount() -> Int {
        return groups.count
    }
    
    func getGroup(atIndex index: Int) -> GroupViewData {
        return groups[index]
    }
    
}

struct GroupViewData: Codable {
    let photoUrl: URL
    let name: String
    let members: String
    let count: String
    let topicCount: String
}
