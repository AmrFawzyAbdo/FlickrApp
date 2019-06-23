//
//  PictureCell.swift
//  Flicker
//
//  Created by Amr fawzy on 6/18/19.
//  Copyright © 2019 Amr fawzy. All rights reserved.
//

import UIKit
import Kingfisher


class PhotoCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.kf.indicatorType = .activity
    }
    
    func fetchImageFromURL(url : URL) {
        imageView.kf.setImage(with: url, placeholder: UIImage(named: "Placeholder"))
    }

}
