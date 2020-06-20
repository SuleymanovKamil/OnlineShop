//
//  FirebaseCollectionReferense.swift
//  OnlineShop
//
//  Created by Камиль on 07.06.2020.
//  Copyright © 2020 Kamil. All rights reserved.
//

import Foundation
import FirebaseFirestore

enum FCollectionReferene: String {
    case User
    case Category
    case Items
    case Basket
    case FavoriteItems
}

func FirebaseReference (_ collectionReferense: FCollectionReferene) -> CollectionReference {
    return Firestore.firestore().collection(collectionReferense.rawValue)
}
