//
//  FavoriteItems.swift
//  OnlineShop
//
//  Created by Камиль on 20.06.2020.
//  Copyright © 2020 Kamil. All rights reserved.
//

import Foundation

class Favoriteitems {
    var id: String!
    var ownerId: String!
    var itemIds: [String]!
    
    init() {
    }
    
    init(_dictionary: NSDictionary) {
        id = _dictionary[K.FireBase.objectID] as? String
        ownerId = _dictionary[K.FireBase.ownerID] as? String
        itemIds = _dictionary[K.FireBase.itemID] as? [String]
    }
}

//MARK: - Download items
func downloadFavotiteItemsFromFirestore(_ ownerId: String, completion: @escaping (_ items: Favoriteitems?)-> Void) {
    
    FirebaseReference(.FavoriteItems).whereField(K.FireBase.ownerID, isEqualTo: ownerId).getDocuments { (snapshot, error) in
        
        guard let snapshot = snapshot else {
            
            completion(nil)
            return
        }
        
        if !snapshot.isEmpty && snapshot.documents.count > 0 {
            let favotiteItems = Favoriteitems(_dictionary: snapshot.documents.first!.data() as NSDictionary)
            completion(favotiteItems)
        } else {
            completion(nil)
        }
    }
}


//MARK: - Save to Firebase
func saveFavoriteItemsToFirestore(_ favoriteItems: Favoriteitems) {
    
    FirebaseReference(.FavoriteItems).document(favoriteItems.id).setData(favoriteItemsDictionaryFrom(favoriteItems) as! [String: Any])
}


//MARK: Helper functions

func favoriteItemsDictionaryFrom(_ favoriteItems: Favoriteitems) -> NSDictionary {
    
    return NSDictionary(objects: [favoriteItems.id as Any, favoriteItems.ownerId as Any, favoriteItems.itemIds as Any], forKeys: [K.FireBase.objectID as NSCopying, K.FireBase.ownerID as NSCopying, K.FireBase.itemID as NSCopying])
}

//MARK: - Update items
func updateFavoriteItemsInFirestore(_ favotiteItems: Favoriteitems, withValues: [String : Any], completion: @escaping (_ error: Error?) -> Void) {


    FirebaseReference(.FavoriteItems).document(favotiteItems.id).updateData(withValues) { (error) in
        completion(error)
    }
}
