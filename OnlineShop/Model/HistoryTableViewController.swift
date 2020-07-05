//
//  HistoryTableViewController.swift
//  OnlineShop
//
//  Created by Камиль on 20.06.2020.
//  Copyright © 2020 Kamil. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {
    
    //MARK: - Vars
    var itemsArray: [Item] = []
    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "SubCell", bundle: nil), forCellReuseIdentifier: K.subCell)
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        loadItems()

    }

    //MARK: - Load items
    
//    private func loadItems() {
//        
//        downloadItems(User.currentUser()!.itemsInBasket) { (allItems) in
//            
//            self.itemsArray = allItems
//            print("we have \(allItems.count) purchased items")
//            self.tableView.reloadData()
//        }
//    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           
           return itemsArray.count
       }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.subCell, for: indexPath) as! SubCell
        cell.generateCell(itemsArray[indexPath.row])
        
        return cell
    }

}
