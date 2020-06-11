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
    
    struct Segues {
        static let toMapVCSegue = "MapSegue"
        static let toSubCategorySegue = "toSubCategory"
        static let segueToPhoneVCSegue = "toPhone"
        static let segueTotCapchaVCSegue = "toCapchaVC"
        static let toAddItemSegue = "toAddItem"
    }

    struct FireBase {
        //Headers
        static let USER_PATH = "user"
        static let CATEGORY_PATH = "category"
        static let ITEMS_PATH = "items"
        static let BASKET_PATH = "basket"
        
        //Category
        static let NAME = "name"
        static let IMAGENAME = "imageName"
        static let OBJECTID = "objectID"
        
        //Item
        static let categoryID = "categoryId"
        static let description = "description"
        static let price = "price"
        static let imageLinks = "imageLinks"
    }
    
}




