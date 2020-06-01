//
//  Catalog.swift
//  OnlineShop
//
//  Created by Камиль on 28.05.2020.
//  Copyright © 2020 Kamil. All rights reserved.
//

import UIKit
//Описание эдиницы товара
struct Product {
    let name: String
    var image: UIImage!
    
    init(name: String, image: UIImage!) {
        self.name = name
        self.image = image
    }
}
