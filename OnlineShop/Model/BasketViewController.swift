//
//  BasketViewController.swift
//  OnlineShop
//
//  Created by Камиль on 13.06.2020.
//  Copyright © 2020 Kamil. All rights reserved.
//

import UIKit
import JGProgressHUD
import Firebase

class BasketViewController: UIViewController {

    //MARK: - IBOutlets

    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var buyButtonOutlet: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalItemsLabel: UILabel!
    @IBOutlet weak var basketTotalPriceLabel: UILabel!
    
    //MARK: - Vars
    var basket: Basket?
    var allItems: [Item] = []
    var purchasedItemIds : [String] = []
    let hud = JGProgressHUD(style: .dark)
    var quantity = 1
    var totalPrice = 0.0
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "SubCell", bundle: nil), forCellReuseIdentifier: K.subCell)
        tableView.tableFooterView = footerView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if User.currentUser() != nil {
        loadBasketFromFirestore()
        } else {
            self.updateTotalLabels(true)
        }
    }
    
    //MARK: - IBActions

    @IBAction func checkoutButtonPressed(_ sender: Any) {
        
        
    }
    //MARK: - Download basket
    private func loadBasketFromFirestore() {

        downloadBasketFromFirestore(User.currentId()) { (basket) in
            
            self.basket = basket
            self.getBasketItems()

        }
    }
    private func getBasketItems() {
        
        if basket != nil {
            if basket?.dic != nil {
            downloadItems(basket!.dic.keys) { (allItems) in
                self.allItems = allItems
                self.updateTotalLabels(false)
                self.tableView.reloadData()
                }
            }
        }
    }

//MARK: - Helper functions

    private func updateTotalLabels(_ isEmpty: Bool) {
        
        if isEmpty {
            totalItemsLabel.text = "0"
            basketTotalPriceLabel.text = returnBasketTotalPrice()
        } else {
            totalItemsLabel.text = "\(allItems.count)"
            basketTotalPriceLabel.text = returnBasketTotalPrice()
        }
        
        
        checkoutButtonStatusUpdate()

    }
    
 private func returnBasketTotalPrice() -> String {
       
        totalPrice = 0.0
        
        for item in allItems{
            totalPrice += item.price * Double((basket?.dic[item.id])!)

        }

        return "Итого: " + convertToCurrency(totalPrice)
    }
    

    //MARK: - Navigation
    private func showItemView(withItem: Item) {
        
        let itemVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "itemView") as! ItemViewController
        itemVC.item = withItem
        self.navigationController?.pushViewController(itemVC, animated: true)
    }

    //MARK: - Check Buy Button
    private func checkoutButtonStatusUpdate() {
        
        buyButtonOutlet.isEnabled = allItems.count > 0
        if buyButtonOutlet.isEnabled {
            buyButtonOutlet.backgroundColor = #colorLiteral(red: 0.05854509026, green: 0.304964751, blue: 0.3185600042, alpha: 1)
        } else {
            disableBuyButton ()
        }
        
    }
    
    private func disableBuyButton () {
        buyButtonOutlet.isEnabled = false
        buyButtonOutlet.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
    
    private func removeItemFromBasket (itemId: String) {
        
        if (basket?.dic) != nil {
            var newBasketDic = basket!.dic
            newBasketDic!.removeValue(forKey: itemId)
            basket?.dic = newBasketDic
            }
        
        }
    
}
    private func updateBasket(basket: Basket, withValues: [String : Any]) {
        updateBasketInFirestore(basket, withValues: withValues) { (error) in
        if error != nil {
            print("error updating basket", error!.localizedDescription)
            } else {
        }
    }
    
}
//MARK: - tableView extension
extension BasketViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.subCell, for: indexPath) as! SubCell
        cell.generateCell(allItems[indexPath.row])
        cell.stackViewLabel.isHidden = false
        cell.descriptionLabel.isHidden = true
        if allItems[indexPath.row].itemQuantity != 0 {
        cell.quantityLabel.text = String(basket!.dic[allItems[indexPath.row].id]!)
        }
        
        for _ in allItems {
            allItems[indexPath.row].itemQuantity = Int(basket!.dic[allItems[indexPath.row].id]!)
        }
        
        cell.minus = {
            self.allItems[indexPath.row].itemQuantity -= 1
            self.basket!.dic[self.allItems[indexPath.row].id] = self.allItems[indexPath.row].itemQuantity
            if self.allItems[indexPath.row].itemQuantity == 0 {
                let itemToDelete = self.allItems[indexPath.row]
                self.allItems.remove(at: indexPath.row)
                self.removeItemFromBasket(itemId: itemToDelete.id)
            }
            updateBasket(basket: self.basket!, withValues: [K.FireBase.dic : self.basket!.dic!])
            self.updateTotalLabels(false)
            self.tableView.reloadData()
        }

        cell.plus = {
            self.allItems[indexPath.row].itemQuantity += 1
            self.basket!.dic[self.allItems[indexPath.row].id] = self.allItems[indexPath.row].itemQuantity
            updateBasket(basket: self.basket!, withValues: [K.FireBase.dic : self.basket!.dic!])
            self.updateTotalLabels(false)
            self.tableView.reloadData()
        }

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //delete items from basket
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let itemToDelete = allItems[indexPath.row]
            allItems.remove(at: indexPath.row)
            removeItemFromBasket(itemId: itemToDelete.id)
            updateBasketInFirestore(basket!, withValues: [K.FireBase.dic : basket!.dic as Any]) { (error) in
                if error != nil {
                    print ("Error while updating basket", error?.localizedDescription as Any)
                }
                self.getBasketItems()
                tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showItemView(withItem: allItems[indexPath.row])
    }
}

