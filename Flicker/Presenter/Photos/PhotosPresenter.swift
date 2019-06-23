//
//  PhotosPresenter.swift
//  Flicker
//
//  Created by Amr fawzy on 6/22/19.
//  Copyright © 2019 Amr fawzy. All rights reserved.
//

import Foundation
import os.log

class PhotosPresenter {
    
    /// keys to use with UserDefaults to save last search state
    private struct DefaultKeys {
        static let keyword = "photos_keyword"
        static let lastPhotos = "last_photos"
    }
    
    // MARK: - Private
    private let photosService: PhotosService
    weak private var photosView: PhotosView?
    
    /// track loading state
    private var isLoading = false
    
    // track pagination
    private var currentPage = 1
    private var lastPage = 1
    
    /// keywords
    private var text: String = ""
    
    /// photo models
    private var photos = [PhotoViewData]()
    
    init(photosService: PhotosService) {
        self.photosService = photosService
        
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
        os_log(.info, "Saving photos & keyword to user defaults before going inactive")
        if !text.isEmpty || !photos.isEmpty {
            let defaults = UserDefaults.standard
            defaults.set(text, forKey: DefaultKeys.keyword)
            
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(photos) {
                defaults.set(encoded, forKey: DefaultKeys.lastPhotos)
            }
            os_log(.info, "Photos & keyword saved to user defaults")
        }
    }
    
    /// load last search models & keyword and notify view
    private func loadLastState() {
        os_log(.info, "Loading photos & keyword from user defaults")
        let defaults = UserDefaults.standard
        self.text = defaults.string(forKey: DefaultKeys.keyword) ?? ""
        
        if let lastPhotosData = defaults.object(forKey: DefaultKeys.lastPhotos) as? Data {
            let decoder = JSONDecoder()
            if let lastPhotos = try? decoder.decode([PhotoViewData].self, from: lastPhotosData) {
                self.photos = lastPhotos
                self.photosView?.didFetchLastState()
                os_log(.info, "Photos & keyword from user defaults did finish loading")
            }
        }
    }
    
    /// get keyword
    func getText() -> String {
        return text
    }
    
    /// attach view to this presenter
    func attachView(view: PhotosView) {
        os_log(.info, "Attaching photos view to presenter")
        photosView = view
        loadLastState()
    }
    
    /// detach view from presenter
    func detatchView() {
        os_log(.info, "Detaching photos view from presenter")
        photosView = nil
    }
    
    /// set keyword and start fetching data
    func setText(_ text: String) {
        os_log(.info, "Start New Search for photos")
        guard !isLoading else { return }
        self.text = text
        getPhotos(page: 1)
    }
    
    /// clear results
    func clear() {
        os_log(.info, "Clearing photos")
        photos = []
        currentPage = 1
    }
    
    /// load next page
    func getMorePhotos() {
        os_log(.info, "Loading more photos")
        getPhotos(page: currentPage+1)
    }
    
    /// fetching photos from web service
    private func getPhotos(page: Int = 1) {
        guard !isLoading else { return }
        if page > 1 {
            guard currentPage < lastPage else { return }
        }
        
        os_log(.info, "Fetching photos")
        
        self.isLoading = true
        self.photosView?.startLoading()
        
        photosService.getPhotos(page: page, text: self.text) { [weak self] allPhotos, error in
            self?.photosView?.finishLoading()
            self?.isLoading = false
            
            guard let allPhotos = allPhotos, error == nil else {
                os_log(.error, "Did finish fetching photos with error")
                self?.photosView?.didFailWithError(error!)
                return
            }
            
            let photos = allPhotos.photos.photo.map {
                return PhotoViewData(url: $0.photoUrl)
            }
            if page == 1 {
                self?.photos = photos
            } else {
                self?.photos.append(contentsOf: photos)
            }
            
            self?.photosView?.didFetchPhotos()
            self?.currentPage = page
            self?.lastPage = allPhotos.photos.pages
            os_log(.info, "Did finish fetching photos successfully")
        }
    }
    
    func getPhotosCount() -> Int {
        return photos.count
    }
    
    func getPhoto(atIndex index: Int) -> PhotoViewData {
        return photos[index]
    }

}

struct PhotoViewData: Codable {
    let url: URL
}
