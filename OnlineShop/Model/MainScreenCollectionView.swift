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
        let categories = Catalog()
        override func viewDidLoad() {
            super.viewDidLoad()
            mainCategories.register(UINib(nibName: "MainCVCell", bundle: nil), forCellWithReuseIdentifier: Constants.mainScreenCatalogCell)
        }

    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 15
        }
        
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.mainScreenCatalogCell, for: indexPath) as! MainCVCell
        cell.title.text = categories.categories[0].name
        cell.image.image = categories.categories[0].image
        cell.image.layer.cornerRadius = 5
        cell.backgroundColor = .black
        cell.layer.cornerRadius = 5
        return cell
        }
        
  
        
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//            performSegue(withIdentifier: "toSubCategory", sender: nil)    }

//        func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//        }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let hadder = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! MainScreenCollectionReusableView
        return hadder
    }
  
}

extension MainScreenCollectionView: UICollectionViewDelegateFlowLayout {
    
    //cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsForRow: CGFloat = 2 //Количество ячеек в ряду
        let offset: CGFloat = 2 //размер отступа
        let paddins = offset * (itemsForRow + 1) //количество отступов
        let availableWidth = collectionView.frame.width - paddins //  Высчисляем доступную ширину для ячеек в зависимости от рахмера экрана
        let width = availableWidth / itemsForRow //Ширина ячейки
        let height = width - (width / 3)
        
        
//        let frame = collectionView.frame
//        let width = frame.width / itemsForRow //Ширина ячейки
//        let height = width / 1.5
//        let paddins = (itemsForRow + 1) * (offset / itemsForRow) //количество отступов
//        return CGSize(width: width - paddins, height: height - (offset * 2))
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



