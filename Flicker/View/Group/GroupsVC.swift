//
//  GroupsVC.swift
//  Flicker
//
//  Created by Amr fawzy on 6/18/19.
//  Copyright © 2019 Amr fawzy. All rights reserved.
//

import UIKit
import os.log


class GroupsVC: UIViewController {
    
    // MARK:- IBOutlets
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var searchButton: UIButton!
    
    // MARK:- Properties
    
    private let cellId = "GroupCell"
    private lazy var presenter = GroupsPresenter(groupsService: GroupsService())
    
    // MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib.init(nibName: cellId, bundle: nil), forCellWithReuseIdentifier: cellId)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        presenter.attachView(view: self)
    }
    
    // MARK:- Search Action
    
    @IBAction private func searchButton(_ sender: Any) {
        os_log(.info , "Search button for photos pressed")
        guard let text = searchTextField.text, !text.isEmpty else {
            searchTextField.becomeFirstResponder()
            presenter.clear()
            collectionView.reloadData()
            return
        }
        
        view.endEditing(true)
        presenter.setText(text)
    }
    
}

extension GroupsVC: GroupsView {
    
    func startLoading() {
        os_log(.info , "Start loading groups ..")
        searchButton.isEnabled = false
        searchTextField.isEnabled = false
    }
    
    func finishLoading() {
        os_log(.info , "Finish load groups ..")
        searchButton.isEnabled = true
        searchTextField.isEnabled = true
    }
    
    func didFetchGroups() {
        os_log(.info , "table reloads groups ..")
        self.collectionView.reloadData()
    }
    
    func didFetchLastState() {
        os_log(.info , "table reloads last searched groups")
        searchTextField.text = presenter.getText()
        didFetchGroups()
        os_log(.info , "table reloaded last searched groups successfuly")
    }
    
    func didFailWithError(_ error: Error) {
        os_log(.error , "dispalying error msg .. ")
        self.showErrorAlert(message: error.localizedDescription)
    }
    
}

// MARK:- Collection View Data Source

extension GroupsVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.getGroupsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? GroupCell else {
            fatalError("can't dequeue cell with id: \(cellId)")
        }
        
        let group = presenter.getGroup(atIndex: indexPath.item)
        cell.imageView.kf.setImage(with: group.photoUrl, placeholder: UIImage(named: "Placeholder"))
        cell.nameLabel.text = group.name
        cell.membersLabel.text = group.members
        cell.countLabel.text = group.count
        cell.topicCountLabel.text = group.topicCount
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == self.presenter.getGroupsCount()-1 {
            // last cell
            self.presenter.getMoreGroups()
        }
    }
}

// MARK:- Collection View Delegate

extension GroupsVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 105)
    }
    
}


