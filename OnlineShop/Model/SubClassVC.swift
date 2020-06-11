//
//  SubClassVC.swift
//  OnlineShop
//
//  Created by Камиль on 08.06.2020.
//  Copyright © 2020 Kamil. All rights reserved.
//

import UIKit

class SubClassVC: UITableViewController {
    //MARK: - Vars
    var category:Category?
    var itemArray: [Item] = []
    
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = category?.name
        tableView.register(UINib(nibName: "SubCell", bundle: nil), forCellReuseIdentifier: K.subCell)
        tableView.rowHeight = 100
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if category != nil {
            loadItems()
        }
    }
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.subCell, for: indexPath) as! SubCell
        
        cell.generateCell(itemArray[indexPath.row])
        return cell
    }
    
 
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.toAddItemSegue{
        let vc = segue.destination as! AddItemViewController
        vc.category = category
        }
    }
    
    
    //MARK: Load Items
    private func loadItems() {
        downloadItemsFromFirebase(category!.id) { (allItems) in
            self.itemArray = allItems
            self.tableView.reloadData()
        }
    }
}
