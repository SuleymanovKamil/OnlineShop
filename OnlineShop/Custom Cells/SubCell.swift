//
//  SubCell.swift
//  OnlineShop
//
//  Created by Камиль on 08.06.2020.
//  Copyright © 2020 Kamil. All rights reserved.
//

import UIKit

class SubCell: UITableViewCell {

    var minus: (() -> ()) = {}
    var plus: (() -> ()) = {}
    
    //MARK: IBOutlets
    @IBOutlet var itemImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var activityIndicatorLabel: UIActivityIndicatorView!
    @IBOutlet var quantityLabel: UILabel!
    @IBOutlet var stackViewLabel: UIStackView!
    

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        activityIndicatorLabel.hidesWhenStopped = true
        stackViewLabel.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func minusButton(_ sender: UIButton) {

        minus()
    }
    
    @IBAction func plusButton(_ sender: UIButton) {
        plus()
    }
    
    func generateCell(_ item: Item) {
        
        nameLabel.text = item.name
        descriptionLabel.text = item.description
        priceLabel.text = convertToCurrency(item.price)
        priceLabel.adjustsFontSizeToFitWidth = true
        itemImage.image = UIImage(named: "noImage")
        itemImage.layer.cornerRadius = 45
        
        if item.imageLinks != nil && item.imageLinks.count > 0 {
            
            activityIndicatorLabel.startAnimating()
            DispatchQueue.main.async {
                downloadImages(imageUrls: [item.imageLinks.first!]) { (images) in
                    self.itemImage.image = images.first as? UIImage
                    self.activityIndicatorLabel.stopAnimating()
                }
            }
            
        }

    }
    
}



