//
//  ItemViewController.swift
//  OnlineShop
//
//  Created by Камиль on 12.06.2020.
//  Copyright © 2020 Kamil. All rights reserved.
//

import UIKit
import JGProgressHUD

class ItemViewController: UIViewController {
//MARK: - Outlets
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var quantitylabel: UILabel!
    
    //MARK: - Vars
    var item: Item!
    var itemImages: [UIImage] = []
    let hud = JGProgressHUD(style: .dark)
    var quantity = 1
    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        downloadPictures ()
        quantitylabel.text = "\(quantity) \(String(describing: item.itemWeith!))"
    }
    
    //MARK: - Buttons
    @IBAction func basketBarButton(_ sender: UIBarButtonItem) {
       
    }
    
    
    @IBAction func minusButton(_ sender: UIButton) {
        if quantity != 0 {
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
        
        //TO DO: check log in
        downloadBasketFromFirestore("1234") { (basket) in
            
            if basket == nil {
                self.createNewBasket()
            } else {
                basket!.itemIds.append(self.item.id)
                self.updateBasket(basket: basket!, withValues: [K.FireBase.itemID : basket!.itemIds, K.FireBase.quantity : basket!.quantity])
            }
        }
    }
    
    //MARK: - Add to basket
       
       private func createNewBasket() {
           
           let newBasket = Basket()
           newBasket.id = UUID().uuidString
           newBasket.ownerId = "1234"
           newBasket.itemIds = [self.item.id]
           newBasket.quantity = quantity
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
        
        if item != nil {
            self.title = item.name
            nameLabel.text = item.name
            priceLabel.text = convertToCurrency(item.price)
            descriptionTextView.text = item.description
        }
    }
}

extension ItemViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemImages.count == 0 ? 1 : itemImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.itemCell, for: indexPath) as! ImageCollectionViewCell
        if itemImages.count > 0 {
            cell.setupImageWith(itemImage: itemImages[indexPath.row])
        }
        return cell
    }
    
    
}
