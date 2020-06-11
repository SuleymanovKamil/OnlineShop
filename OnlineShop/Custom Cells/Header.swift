//
//  MainScreenCollectionReusableView.swift
//  OnlineShop
//
//  Created by Камиль on 30.05.2020.
//  Copyright © 2020 Kamil. All rights reserved.
//

import UIKit


class Header: UICollectionReusableView {


    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapOutlet: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    
    @IBAction func mapPressed(_ sender: Any) {
        
        
    }
    
    
  
}
extension Header: UISearchBarDelegate {

func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {


    
}

func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
   
    }

}

