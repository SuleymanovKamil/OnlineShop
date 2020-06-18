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
        goToMapVC()
        
    }
    
    private func goToMapVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let dvc = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        dvc.modalPresentationStyle = .fullScreen
//        mainScreenVC.present(dvc, animated: true, completion: nil)
        self.window?.rootViewController?.present(dvc, animated: true, completion: nil)

    }
    
  
}
extension Header: UISearchBarDelegate {

func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {


    
}

func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
   
    }

}

