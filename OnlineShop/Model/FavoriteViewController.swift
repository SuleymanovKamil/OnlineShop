//
//  FavoriteViewController.swift
//  OnlineShop
//
//  Created by Камиль on 20.06.2020.
//  Copyright © 2020 Kamil. All rights reserved.
//

import UIKit
import JGProgressHUD
import Firebase

class FavoriteViewController: UIViewController {
    
    //MARK: - Vars
    var favItems: Favoriteitems?
    var allItems: [Item] = []
    let hud = JGProgressHUD(style: .dark)
    
    //MARK: - IBOutlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet var labelForEmptyView: UILabel!
    //MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if User.currentUser() != nil {
        loadFavItemsFromFirestore()
        }
    }
    
    func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "SubCell", bundle: nil), forCellReuseIdentifier: K.subCell)
    }
    
    
    //MARK: - Download favItems
    private func loadFavItemsFromFirestore() {
        
        downloadFavoriteItemsFromFirestore(User.currentId()) { (favItems) in
            
            self.favItems = favItems
            self.getFavItems()
        }
    }
    
    private func getFavItems() {
         
         if favItems != nil {
             downloadFavItems(favItems!.itemIds) { (allItems) in
                 
                 self.allItems = allItems
                if allItems.count > 0 {
                    self.labelForEmptyView.isHidden = true
                }
                self.removeMyDuplicates ()
                 self.tableView.reloadData()
                
                
             }
         }
 }
    
//MARK: - Delete duplicates
    func removeMyDuplicates () {
        
        var newListOfItems:[Item] = []

        for item in self.allItems{
            var added = false
            for newItems in newListOfItems{
                if(item.id == newItems.id){
                    added = true
                }
            }
            if !added{
                newListOfItems.append(item)
            }
        }
        self.allItems = newListOfItems
    }
    
    //MARK: - Navigation
     private func showItemView(withItem: Item) {
         
         let itemVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "itemView") as! ItemViewController
         itemVC.item = withItem
         self.navigationController?.pushViewController(itemVC, animated: true)
     }
}
extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           
           return allItems.count
       }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.subCell, for: indexPath) as! SubCell
        cell.generateCell(allItems[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           tableView.deselectRow(at: indexPath, animated: true)
           showItemView(withItem: allItems[indexPath.row])
       }
    
   
}
