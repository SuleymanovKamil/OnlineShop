//
//  Constants .swift
//  OnlineShop
//
//  Created by Камиль on 28.05.2020.
//  Copyright © 2020 Kamil. All rights reserved.
//

import Foundation

//Category


struct K {
    
    static let fireStorageURL = "gs://onlineshop-e24bb.appspot.com"
    static let mainScreenCatalogCell = "MainCell"
    static let subCell = "subCell"
    static let itemCell = "itemCell"
    
    struct Segues {
        static let toMapVCSegue = "MapSegue"
        static let toSubCategorySegue = "toSubCategory"
        static let segueToPhoneVCSegue = "toPhone"
        static let segueTotCapchaVCSegue = "toCapchaVC"
        static let toAddItemSegue = "toAddItem"
    }
    
    struct FireBase {
        //Headers
        static let userPath = "user"
        static let cateoryPath = "category"
        static let itemsPath = "items"
        static let basketPath = "basket"
        
        //Category
        static let name = "name"
        static let imageName = "imageName"
        static let objectID = "objectID"
        
        //Item
        static let categoryID = "categoryId"
        static let description = "description"
        static let price = "price"
        static let imageLinks = "imageLinks"
        static let itemWeith = "itemWeith"
        
        //Basket
        static let ownerID = "ownerID"
        static let itemID = "itemID"
        static let quantity = "quantity"
        
        //Users
        static let userPhoneNumber = "userPhoneNumber"
        static let userName = "name"
        static let currentUser = "currentUser"
        static let userAdress = "adress"
        static let itemsInBaket = "itemsInBaket"
        
    }
    
}




