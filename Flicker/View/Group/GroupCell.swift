//
//  GroupCell.swift
//  Flicker
//
//  Created by Amr fawzy on 6/18/19.
//  Copyright © 2019 Amr fawzy. All rights reserved.
//

import UIKit
import Kingfisher


class GroupCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var membersLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var topicCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.kf.indicatorType = .activity
    }
    
}
