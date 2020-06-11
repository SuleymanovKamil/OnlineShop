//
//  SubCell.swift
//  OnlineShop
//
//  Created by Камиль on 08.06.2020.
//  Copyright © 2020 Kamil. All rights reserved.
//

import UIKit

class SubCell: UITableViewCell {
    //MARK: IBOutlets
    @IBOutlet var itemImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var activityIndicatorLabel: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicatorLabel.startAnimating()
        activityIndicatorLabel.hidesWhenStopped = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func generateCell(_ item: Item) {
        
        nameLabel.text = item.name
        descriptionLabel.text = item.description
        priceLabel.text = convertToCurrency(item.price)
        priceLabel.adjustsFontSizeToFitWidth = true
        
        if item.imageLinks != nil && item.imageLinks.count > 0 {
            DispatchQueue.main.async {
                downloadImages(imageUrls: [item.imageLinks.first!]) { (images) in
                    self.itemImage.image = images.first as? UIImage
                    self.activityIndicatorLabel.stopAnimating()
                }
            }
            
        }

    }
    
   
}



