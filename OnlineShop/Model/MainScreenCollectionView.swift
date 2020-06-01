//
//  MainScreenCollectionView.swift
//  OnlineShop
//
//  Created by Камиль on 30.05.2020.
//  Copyright © 2020 Kamil. All rights reserved.
//

import UIKit
class MainScreenCollectionView: UICollectionViewController {

    @IBOutlet weak var mainCategories: UICollectionView!
        let catalog = Catalog()
    

    override func viewDidLoad() {
            super.viewDidLoad()
        mainCategories.register(UINib(nibName: "MainCVCell", bundle: nil), forCellWithReuseIdentifier: Constants.mainScreenCatalogCell)
        }

   //MARK: - CollectionView methods
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return catalog.mainCategories.count
        }
        
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.mainScreenCatalogCell, for: indexPath) as! MainCVCell
       
        cell.title.text = catalog.mainCategories[indexPath.row].name
        cell.image.image = catalog.mainCategories[indexPath.row].image
        
        cell.backgroundColor = .black
        cell.layer.cornerRadius = 5
        return cell
    }
        
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            performSegue(withIdentifier: "toSubCategory", sender: nil)    }

    //hide navBar while scrolling
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let height = scrollView.contentOffset.y
        print (height)
        
        if height > 110 {
            // TODO: add functions for this
            let searchButton = UIButton(type: .system)
            searchButton.setImage(UIImage(named: "search"), for: .normal)
            searchButton.frame = CGRect(x: 0.0, y: 0.0, width: 5, height: 5)
            let menuBarItem = UIBarButtonItem(customView: searchButton)
            let currWidth = menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 24)
            currWidth?.isActive = true
            let currHeight = menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 24)
            currHeight?.isActive = true
            searchButton.contentMode = .scaleAspectFit
            searchButton.tintColor = .black
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchButton)

//            navigationItem.title = "Search"
        } else if height < 110  {
            navigationItem.leftBarButtonItem = nil
            
        }

        }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let hadder = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! MainScreenCollectionReusableView
        return hadder
    }
  
}
//MARK: - Extension for CollectionViewLayout Delegate
extension MainScreenCollectionView: UICollectionViewDelegateFlowLayout {
    
    //cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsForRow: CGFloat = 2 //Количество ячеек в ряду
        let offset: CGFloat = 2 //размер отступа
        let paddins = offset * (itemsForRow + 1) //количество отступов
        let availableWidth = collectionView.frame.width - paddins //  Высчисляем доступную ширину для ячеек в зависимости от рахмера экрана
        let width = availableWidth / itemsForRow //Ширина ячейки
        let height = width - (width / 3)

        return CGSize(width: width - 20, height: height)
    }
    //Отсутпы
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    //Растояние между объектами по высоте
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    //Растояние между объектами по ширине
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
       return 5
    }
}



