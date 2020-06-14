//
//  Item.swift
//  OnlineShop
//
//  Created by Камиль on 09.06.2020.
//  Copyright © 2020 Kamil. All rights reserved.
//

import UIKit


class Item {
    
    var id: String!
    var categoryId: String!
    var name: String!
    var description: String!
    var price: Double!
    var imageLinks: [String]!
    var itemQuantity: Int!
    var itemWeith: String!
    
    init() {
    }
    
    init(_dictionary: NSDictionary) {
        
        id = _dictionary[K.FireBase.objectID] as? String
        categoryId = _dictionary[K.FireBase.objectID] as? String
        name = _dictionary[K.FireBase.name] as? String
        description = _dictionary[K.FireBase.description] as? String
        price = _dictionary[K.FireBase.price] as? Double
        imageLinks = _dictionary[K.FireBase.imageLinks] as? [String]
        itemQuantity = _dictionary[K.FireBase.quantity] as? Int
        itemWeith = _dictionary[K.FireBase.itemWeith] as? String
    }
}

//MARK: Save items func

func saveItemToFirestore(_ item: Item) {
    
    FirebaseReference(.Items).document(item.id).setData(itemDictionaryFrom(item) as! [String : Any])
  
}


//MARK: Helper functions

func itemDictionaryFrom(_ item: Item) -> NSDictionary {
    
    return NSDictionary(objects: [item.id, item.categoryId, item.name, item.description, item.price, item.imageLinks, item.itemQuantity, item.itemWeith],forKeys: [K.FireBase.objectID as NSCopying, K.FireBase.categoryID as NSCopying, K.FireBase.name as NSCopying, K.FireBase.description as NSCopying, K.FireBase.price as NSCopying, K.FireBase.imageLinks as NSCopying, K.FireBase.quantity as NSCopying, K.FireBase.itemWeith as NSCopying])
}

//MARK: Download Func
func downloadItemsFromFirebase(_ withCategoryId: String, completion: @escaping (_ itemArray: [Item]) -> Void) {
    
    var itemArray: [Item] = []
    
    FirebaseReference(.Items).whereField(K.FireBase.categoryID, isEqualTo: withCategoryId).getDocuments { (snapshot, error) in
        
        guard let snapshot = snapshot else {
            completion(itemArray)
            return
        }
        
        if !snapshot.isEmpty {
            
            for itemDict in snapshot.documents {
                
                itemArray.append(Item(_dictionary: itemDict.data() as NSDictionary))
            }
        }
        
        completion(itemArray)
    }
    
}

func downloadItems(_ withIds: [String], completion: @escaping (_ itemArray: [Item]) -> Void) {
    
    var count = 0
    var itemArray: [Item] = []
    
    if withIds.count > 0 {
        
        for itemId in withIds {
            
            FirebaseReference(.Items).document(itemId).getDocument { (snapshot,
                error) in
                
                guard let snapshot = snapshot else {
                    completion (itemArray)
                    return
                }
                
                if snapshot.exists {
                    
                    itemArray.append(Item(_dictionary: snapshot.data()! as! NSDictionary))
                    count += 1
                    
                } else {
                    completion (itemArray)
                }
                
                if count == withIds.count {
                    completion (itemArray)
                }
            }
        }
    } else {
        completion (itemArray)
    }
}

