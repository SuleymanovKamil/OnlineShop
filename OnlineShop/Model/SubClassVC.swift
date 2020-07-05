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
        tableView.tableFooterView = UIView() //удаляем неиспользуемые ячейки
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if category != nil {
            loadItems()
        }
    }
    // MARK: - Tableview datasource


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.subCell, for: indexPath) as! SubCell
        
        cell.generateCell(itemArray[indexPath.row])
        return cell
    }
    
    //MARK: - TableView delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        showItemView(itemArray[indexPath.row])
    }
 
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.toAddItemSegue{
        let vc = segue.destination as! AddItemViewController
        vc.category = category
        }
    }
    
    private func showItemView(_ item: Item) {
        let itemVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "itemView") as! ItemViewController
        itemVC.item = item
        itemVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(itemVC, animated: true)
    }

    
    //MARK: Load Items
    private func loadItems() {
        downloadItemsFromFirebase(category!.id) { (allItems) in
            self.itemArray = allItems
            self.tableView.reloadData()
        }
    }
}
