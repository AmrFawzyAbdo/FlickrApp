//
//  PictureSearch.swift
//  Flicker
//
//  Created by Amr fawzy on 6/16/19.
//  Copyright © 2019 Amr fawzy. All rights reserved.
//

import UIKit
import os.log

class PhotosVC: UIViewController {
    
    // MARK:- IBOutlets
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var searchButton: UIButton!
    
    // MARK:- Properties
    
    private let cellId = "PhotoCell"
    private lazy var presenter = PhotosPresenter(photosService: PhotosService())
    
    
    // MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: cellId, bundle: nil), forCellWithReuseIdentifier: cellId)
        
        collectionView.keyboardDismissMode = .onDrag
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

extension PhotosVC: PhotosView {
    
    func startLoading() {
        os_log(.info , "Start loading photos ..")
        searchButton.isEnabled = false
        searchTextField.isEnabled = false
    }
    
    func finishLoading() {
        os_log(.info , "Finish load photos !")
        
        searchButton.isEnabled = true
        searchTextField.isEnabled = true
    }
    
    func didFetchPhotos() {
        os_log(.info , "table reloads photos ..")
        
        self.collectionView.reloadData()
    }
    
    func didFetchLastState() {
        os_log(.info , "table reloads last searched photos")
        searchTextField.text = presenter.getText()
        didFetchPhotos()
        os_log(.info , "table reloaded last searched photos successfuly")
    }
    
    func didFailWithError(_ error: Error) {
        os_log(.error , "dispalying error msg .. ")
        self.showErrorAlert(message: error.localizedDescription)
    }
    
}

// MARK:- CollectionView Data Soruce

extension PhotosVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.getPhotosCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? PhotoCell else {
            fatalError("can't dequeue cell with id: \(cellId)")
        }
        
        cell.fetchImageFromURL(url: presenter.getPhoto(atIndex: indexPath.item).url)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == presenter.getPhotosCount()-1 {
            // last cell
            self.presenter.getMorePhotos()
        }
    }
    
}

// MARK:- Collection View Delegate

extension PhotosVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds.width
        let width = (screenSize - 20) / 3
        return CGSize(width: width, height: width)
    }
    
}
