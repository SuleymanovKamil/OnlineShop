//
//  ItemViewController.swift
//  OnlineShop
//
//  Created by Камиль on 12.06.2020.
//  Copyright © 2020 Kamil. All rights reserved.
//

import UIKit
import JGProgressHUD
import Firebase

class ItemViewController: UIViewController {
//MARK: - Outlets
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var quantitylabel: UILabel!
    @IBOutlet var unfavotiteOutlet: UIButton!
    @IBOutlet var addToBasketOutlet: UIButton!
    @IBOutlet var favoriteStatuslabel: UILabel!
    
    //MARK: - Vars
    var item: Item!
    var itemImages: [UIImage] = []
    let hud = JGProgressHUD(style: .dark)
    var quantity = 1
    var favItems: Favoriteitems?
    var basket: Basket?
    var itemsArray: [Item] = []
    var itemsInBasket = 0
    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        downloadPictures ()
        item.itemQuantity = 1
        quantitylabel.text = "\(quantity) \(String(describing: item.itemWeith!))"
    }
    
 
    override func viewWillAppear(_ animated: Bool) {
        quantity = 1
        if User.currentUser() != nil {
            loadBasketFromFirestore()
        }
    }
    
    //MARK: - Buttons
    @IBAction func basketBarButton(_ sender: UIBarButtonItem) {
       
    }
    
    
    @IBAction func minusButton(_ sender: UIButton) {
        
        if quantity != 1 {
            quantity -= 1
            quantitylabel.text = "\(quantity) \(String(describing: item.itemWeith!))"
            item.itemQuantity = quantity
               }

    }
    
    
    @IBAction func plusButton(_ sender: UIButton) {
        quantity += 1
        quantitylabel.text = "\(quantity) \(String(describing: item.itemWeith!))"
        item.itemQuantity = quantity
    }
    
    
    @IBAction func addToBasketPressed(_ sender: UIButton) {
        
        if User.currentUser() != nil {
            downloadBasketFromFirestore(User.currentId()) { (basket) in
                if basket == nil {
                    self.createNewBasket()
                    self.changetitle()
                } else {
                    basket!.dic[self.item.id] = self.item.itemQuantity
                    self.updateBasket(basket: basket!, withValues: [K.FireBase.dic : basket!.dic!])
                    self.changetitle()
                    self.viewWillAppear(true)
                }
            }
        } else {
            showLoginView()
        }
    }
    
    
    //MARK: - Add to basket
    
    private func loadBasketFromFirestore() {
        
        downloadBasketFromFirestore(User.currentId()) { (basket) in
            
            self.basket = basket
            self.itemsInBasket = basket!.dic.keys.count
            self.changetitle()
            self.getBasketItems()
            if let basketExist = basket?.dic[self.item.id] {
                self.quantitylabel.text = ("\(String(basketExist)) \(String(describing: self.item.itemWeith!))")
                self.quantity = basketExist
                self.addToBasketOutlet.backgroundColor = .red
                self.addToBasketOutlet.setTitle("Обновить корзину", for: .normal)
            }
        }
    }
    
    private func getBasketItems() {
        
        if basket != nil {
            if basket?.dic != nil {
            downloadItems(basket!.dic.keys) { (allItems) in
                }
            }
        }
    }
    
    private func createNewBasket() {
        
        let newBasket = Basket()
        newBasket.id = UUID().uuidString
        newBasket.ownerId = User.currentId()

        newBasket.dic = [self.item.id : self.item.itemQuantity]
          
        saveBasketToFirestore(newBasket)
        
        self.hud.textLabel.text = "Добавлено в корзину"
        self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        self.hud.show(in: self.view)
        self.hud.dismiss(afterDelay: 2.0)
    }
    
    private func updateBasket(basket: Basket, withValues: [String : Any]) {
        updateBasketInFirestore(basket, withValues: withValues) { (error) in
            
            if error != nil {
                
                self.hud.textLabel.text = "Error: \(error!.localizedDescription)"
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
                
                print("error updating basket", error!.localizedDescription)
            } else {
                
                self.hud.textLabel.text = "Добавлено в корзину"
                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
        }
        
    }
    //MARK: - Add to favorite
    
    @IBAction func toFavoritePressed(_ sender: UIButton) {
        if User.currentUser() != nil {
            
            if unfavotiteOutlet.image(for: .normal) == UIImage(named: "unfavorite"){
                unfavotiteOutlet.setImage(UIImage(named: "favorite"), for: .normal)
                favoriteStatuslabel.text = "любимый товар"
                downloadFavoriteItemsFromFirestore(User.currentId()) { (favItems) in
                               if favItems == nil {
                                   self.createNewFavorites()
                               } else {
                                   favItems!.itemIds.append(self.item.id)
                                   self.updateFavorites(favoritesItem: favItems!, withValues: [K.FireBase.itemIDs : favItems!.itemIds!])
                               }
                           }
            } else { unfavotiteOutlet.setImage(UIImage(named: "unfavorite"), for: .normal)
                removeFavoriteItem(itemId: self.item.id)
                favoriteStatuslabel.text = "добавить в любимые товары"
            }

           
        }
    }

    func FavItemStatusCheck(itemId: String) {
        
        downloadFavoriteItemsFromFirestore(User.currentId()) { (favItems) in
            if favItems?.itemIds.count != nil{
                for i in 0..<favItems!.itemIds.count {
                    
                    if itemId == favItems!.itemIds[i]{
                        self.favoriteStatuslabel.text = "любимый товар"
                        self.unfavotiteOutlet.setImage(UIImage(named: "favorite"), for: .normal)
                        
                        return
                    }
                    
                }
                
            }
        }
        
        if unfavotiteOutlet.image(for: .normal) == UIImage(named: "unfavorite"){
            favoriteStatuslabel.text = "добавить в любимые товары"
        } else {
            favoriteStatuslabel.text = "любимый товар"
        }
    }
    
    private func createNewFavorites() {
        
        let newFavoriteItems = Favoriteitems()
        newFavoriteItems.id = UUID().uuidString
        newFavoriteItems.ownerId = User.currentId()
        newFavoriteItems.itemIds = [self.item.id]
        saveFavItemsToFirestore(newFavoriteItems)
        
        if self.unfavotiteOutlet.image(for: .normal) != UIImage(named: "unfavorite"){
            self.hud.textLabel.text = "Добавлено в любимые товары"
            self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
            self.hud.show(in: self.view)
            self.hud.dismiss(afterDelay: 2.0)
        }
    }
    
    private func updateFavorites(favoritesItem: Favoriteitems, withValues: [String : Any]) {
        updateFavItemsInFirestore(favoritesItem, withValues: withValues) { (error) in
            
            if error != nil {
                
                self.hud.textLabel.text = "Error: \(error!.localizedDescription)"
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
                
                print("error updating favorites", error!.localizedDescription)
            } else {
                
                if self.unfavotiteOutlet.image(for: .normal) != UIImage(named: "unfavorite"){
                    self.hud.textLabel.text = "Добавлено в любимые товары"
                    self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay: 2.0)
                }
            }
        }
        
    }
    
    private func removeFavoriteItem (itemId: String) {
        
        downloadFavoriteItemsFromFirestore(User.currentId()) { (favItems) in
            if favItems?.itemIds.count != nil{
                for i in 0..<favItems!.itemIds.count {
                    
                    if itemId == favItems!.itemIds[i]{
                        favItems!.itemIds.remove(at: i)
                        self.updateFavorites(favoritesItem: favItems!, withValues: [K.FireBase.itemIDs : favItems!.itemIds!])
                        
                        self.hud.textLabel.text = "Удалено из любимых товаров"
                        self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                        self.hud.show(in: self.view)
                        self.hud.dismiss(afterDelay: 2.0)
                        return
                    }
                    
                }
                
            }
        }
    }
    //MARK: - Download images
    private func downloadPictures () {
        
        if item != nil && item.imageLinks != nil {
            downloadImages(imageUrls: item.imageLinks) { (allImages) in
                if allImages.count > 0 {
                    self.itemImages = allImages as! [UIImage]
                    self.imageCollectionView.reloadData()
                }
                
            }
        }
    }
    

    //MARK: - SetupUi
    private func setupUI() {
        changetitle()
        unfavotiteOutlet.setImage(UIImage(named: UserDefaults.standard.string(forKey: "FavoriteLabel") ?? "unfavorite"), for: .normal)
        if User.currentUser() == nil {
            unfavotiteOutlet.isEnabled = false
        }
        
        if item != nil {
            self.title = item.name
            nameLabel.text = item.name
            priceLabel.text = convertToCurrency(item.price)
            descriptionTextView.text = item.description
        }
    }
    
    //MARK: - NavigationButton
    func changetitle() {
        
        let button =  UIButton(type: .custom)
        button.setImage(UIImage(named: "basket"), for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.frame = CGRect(x: 0.0, y: 0.0, width: 5, height: 5)
        button.contentMode = .scaleAspectFit
        let menuBarItem = UIBarButtonItem(customView: button)
        let currWidth = menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 24)
        currWidth?.isActive = true
        let currHeight = menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 24)
        currHeight?.isActive = true
        let label = UILabel(frame: CGRect(x: 26, y: -5, width: 50, height: 20))// set position of label
        label.font = UIFont(name: "Arial-BoldMT", size: 14)// add font and size of label
        if User.currentUser() != nil && itemsInBasket > 0 {
            label.text = String(itemsInBasket)
        }
        label.textAlignment = .left
        label.textColor = UIColor.red
        label.backgroundColor =   UIColor.clear
        button.addSubview(label)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
        
        
    }
       
       @objc func buttonAction () {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let dvc = storyboard.instantiateViewController(withIdentifier: "BasketViewController") as! BasketViewController
        dvc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(dvc, animated: true)
       }
    
    
    //MARK: - Show login view
    
    private func showLoginView() {
        
        let loginView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "AccountViewController")
        loginView.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(loginView, animated: true)
     
    }
 
}
//MARK: - CollectionView extension
extension ItemViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemImages.count == 0 ? 1 : itemImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.itemCell, for: indexPath) as! ImageCollectionViewCell
        if itemImages.count > 0 {
            cell.activityIndicatorLabel.startAnimating()
            DispatchQueue.main.async {
                cell.setupImageWith(itemImage: self.itemImages[indexPath.row])
                cell.activityIndicatorLabel.stopAnimating()
            }
        }
        return cell
    }
    
    
}
