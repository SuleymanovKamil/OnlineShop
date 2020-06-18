//
//  Basket.swift
//  OnlineShop
//
//  Created by Камиль on 13.06.2020.
//  Copyright © 2020 Kamil. All rights reserved.
//

import Foundation

class Basket {
    
    var id: String!
    var ownerId: String!
    var itemIds: [String]!
    var quantity: Int!
    
    init() {
    }
    
    init(_dictionary: NSDictionary) {
        id = _dictionary[K.FireBase.objectID] as? String
        ownerId = _dictionary[K.FireBase.ownerID] as? String
        itemIds = _dictionary[K.FireBase.itemID] as? [String]
        quantity = _dictionary[K.FireBase.quantity] as? Int
    }
}


//MARK: - Download items
func downloadBasketFromFirestore(_ ownerId: String, completion: @escaping (_ basket: Basket?)-> Void) {
    
    FirebaseReference(.Basket).whereField(K.FireBase.ownerID, isEqualTo: ownerId).getDocuments { (snapshot, error) in
        
        guard let snapshot = snapshot else {
            
            completion(nil)
            return
        }
        
        if !snapshot.isEmpty && snapshot.documents.count > 0 {
            let basket = Basket(_dictionary: snapshot.documents.first!.data() as NSDictionary)
            completion(basket)
        } else {
            completion(nil)
        }
    }
}


//MARK: - Save to Firebase
func saveBasketToFirestore(_ basket: Basket) {
    
    FirebaseReference(.Basket).document(basket.id).setData(basketDictionaryFrom(basket) as! [String: Any])
}


//MARK: Helper functions

func basketDictionaryFrom(_ basket: Basket) -> NSDictionary {
    
    return NSDictionary(objects: [basket.id as Any, basket.ownerId as Any, basket.itemIds as Any, basket.quantity as Any], forKeys: [K.FireBase.objectID as NSCopying, K.FireBase.ownerID as NSCopying, K.FireBase.itemID as NSCopying, K.FireBase.quantity as NSCopying])
}

//MARK: - Update basket
func updateBasketInFirestore(_ basket: Basket, withValues: [String : Any], completion: @escaping (_ error: Error?) -> Void) {
    
    
    FirebaseReference(.Basket).document(basket.id).updateData(withValues) { (error) in
        completion(error)
    }
}
