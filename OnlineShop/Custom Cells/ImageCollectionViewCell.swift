//
//  ImageCollectionViewCell.swift
//  OnlineShop
//
//  Created by Камиль on 12.06.2020.
//  Copyright © 2020 Kamil. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageLabel: UIImageView!
    @IBOutlet var activityIndicatorLabel: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicatorLabel.startAnimating()
        activityIndicatorLabel.hidesWhenStopped = true
    }
    func setupImageWith(itemImage: UIImage) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { 
            self.activityIndicatorLabel.stopAnimating()
        }
        imageLabel.image = itemImage
    }
}
