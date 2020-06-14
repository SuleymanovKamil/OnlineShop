//
//  MainScreenCollectionView.swift
//  OnlineShop
//
//  Created by Камиль on 30.05.2020.
//  Copyright © 2020 Kamil. All rights reserved.
//

import UIKit

class MainScreenCollectionView: UICollectionViewController{
    @IBOutlet weak var mainCategories: UICollectionView!
    //MARK: Vars
    var categoryArray: [Category] = []
    static var mainAdress = "Указать адрес доставки"
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mainCategories.register(UINib(nibName: "MainCVCell", bundle: nil), forCellWithReuseIdentifier: K.mainScreenCatalogCell)
         MainScreenCollectionView.mainAdress = UserDefaults.standard.string(forKey: "delievertAdress") ?? "Указать адрес доставки"
        
       //для сохранения категорий в Firebase
//        createCategorySet()
        
        //для загрузки категорий из Firebase
//        downloadCategories{ (allCatogories) in
//            print ("Complete")
//        }
     }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadCategories()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    //hide navBar while scrolling
       override func scrollViewDidScroll(_ scrollView: UIScrollView) {
           let height = scrollView.contentOffset.y
           if height > 70 {
               navBarButtonsApper ()
           } else if height < 700  {
               // TODO: add methods for this
               navigationItem.leftBarButtonItem = nil
           }
       }
    //MARK: - UnwindSegue
    @IBAction  func unwindToMainScreen (segue: UIStoryboardSegue){
        
        UserDefaults.standard.set(MainScreenCollectionView.mainAdress, forKey: "delievertAdress")
        collectionView.reloadData()
    }
    //MARK: Download categories
    private func loadCategories() {
        
        downloadCategories {(allCategories) in
            
            self.categoryArray = allCategories
            self.collectionView.reloadData()
        }
    }
    
    //MARK: - CollectionView methods
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryArray.count
        }
        
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.mainScreenCatalogCell, for: indexPath) as! MainCVCell

        cell.title.text = categoryArray[indexPath.row].name
        cell.image.image = categoryArray[indexPath.row].image

        cell.backgroundColor = .black
        cell.layer.cornerRadius = 5
        return cell
    }
        
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let hadder = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! Header
        hadder.mapOutlet.setTitle(MainScreenCollectionView.mainAdress, for: .normal)
        return hadder
    }

    //MARK: - Segue to SubVC
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           performSegue(withIdentifier: K.Segues.toSubCategorySegue, sender: categoryArray[indexPath.row])    }
       
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.toSubCategorySegue{
            let vc = segue.destination as! SubClassVC
            vc.category = sender as? Category
        }
    }
}
//MARK: - Extension for CollectionViewLayout Delegate
extension MainScreenCollectionView: UICollectionViewDelegateFlowLayout {
    
    //cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsForRow: CGFloat = 2 //Количество ячеек в ряду
        let offset: CGFloat = 2 //размер отступа
        let paddins = offset * (itemsForRow + 1) //количество отступов
        let availableWidth = collectionView.frame.width - paddins //  Высчисляем доступную ширину для ячеек в зависимости от размера экрана
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
    
    
    
//MARK: - Кнопка поиска в навбаре
    func navBarButtonsApper () {
        
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
    }
}

//MARK: - Black NavBar
extension UINavigationController {
  override open var preferredStatusBarStyle: UIStatusBarStyle {
    guard #available(iOS 13, *) else {
      return .default
    }
    return .lightContent
  }
    open override var childForStatusBarStyle: UIViewController? {
        topViewController
    }
}

