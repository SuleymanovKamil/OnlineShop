//
//  MainScreenCollectionReusableView.swift
//  OnlineShop
//
//  Created by Камиль on 30.05.2020.
//  Copyright © 2020 Kamil. All rights reserved.
//

import UIKit

class MainScreenCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        searchBar.delegate = self
    }
    
}
extension MainScreenCollectionReusableView: UISearchBarDelegate {

func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

    location.text! = "Lol"
    
}

func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        location.text = "Lol"
        
      
    }

}
