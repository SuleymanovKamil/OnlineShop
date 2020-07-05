//
//  FavoriteItems.swift
//  OnlineShop
//
//  Created by Камиль on 20.06.2020.
//  Copyright © 2020 Kamil. All rights reserved.
//

import Foundation
import FirebaseAuth

class Favoriteitems {
    var id: String!
    var ownerId: String!
    var itemIds: [String]!
    var favoriteItems: [String]!
    
    init() {
    }
    
    init(_dictionary: NSDictionary) {
        id = _dictionary[K.FireBase.objectID] as? String
        ownerId = _dictionary[K.FireBase.ownerID] as? String
        itemIds = _dictionary[K.FireBase.itemIDs] as? [String]
        favoriteItems = _dictionary[K.FireBase.favorite] as? [String]
    }
}
    //MARK: - Download items
    func downloadFavoriteItemsFromFirestore(_ ownerId: String, completion: @escaping (_ favItems: Favoriteitems?)-> Void) {
        
        FirebaseReference(.FavoriteItems).whereField(K.FireBase.ownerID, isEqualTo: ownerId).getDocuments { (snapshot, error) in
            
            guard let snapshot = snapshot else {
                
                completion(nil)
                return
            }
            
            if !snapshot.isEmpty && snapshot.documents.count > 0 {
                let favItems = Favoriteitems(_dictionary: snapshot.documents.first!.data() as NSDictionary)
                completion(favItems)
            } else {
                completion(nil)
            }
        }
    }


    //MARK: - Save to Firebase
    func saveFavItemsToFirestore(_ favItems: Favoriteitems) {
        
        FirebaseReference(.FavoriteItems).document(favItems.id).setData(favItemsDictionaryFrom(favItems) as! [String: Any])
    }


    //MARK: Helper functions

    func favItemsDictionaryFrom(_ favItems: Favoriteitems) -> NSDictionary {
        
        return NSDictionary(objects: [favItems.id as Any, favItems.ownerId as Any, favItems.itemIds as Any, favItems.favoriteItems as Any], forKeys: [K.FireBase.objectID as NSCopying, K.FireBase.ownerID as NSCopying, K.FireBase.itemIDs as NSCopying, K.FireBase.favorite as NSCopying])
    }

    //MARK: - Update favItems
    func updateFavItemsInFirestore(_ favItems: Favoriteitems, withValues: [String : Any], completion: @escaping (_ error: Error?) -> Void) {
        
        
        FirebaseReference(.FavoriteItems).document(favItems.id).updateData(withValues) { (error) in
            completion(error)
        }
    }

