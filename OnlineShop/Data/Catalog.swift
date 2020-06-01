//
//  Catalog.swift
//  OnlineShop
//
//  Created by Камиль on 28.05.2020.
//  Copyright © 2020 Kamil. All rights reserved.
//

import UIKit
//Каталог для главного экрана
struct Catalog {
    let mainCategories = [
        Product(
            name: "Хлеб и булочки", image: UIImage(named: "Bread")
        ),
        Product(
            name: "Молоко", image: UIImage(named: "Milk")
        ),
        Product(
            name: "Колбаса", image: UIImage(named: "Bread")
        ),
        Product(
            name: "Конфеты", image: UIImage(named: "Bread")
        ),
        Product(
            name: "Чай", image: UIImage(named: "Bread")
        ),
        Product(
            name: "Кофе", image: UIImage(named: "Bread")
        ),
        Product(
            name: "Печенье", image: UIImage(named: "Bread")
        ),
        Product(
            name: "Крупы", image: UIImage(named: "Bread")
        ),
        Product(
            name: "Макароны", image: UIImage(named: "Bread")
        ),
        Product(
            name: "Рыба", image: UIImage(named: "Bread")
        ),
        
    ]
    
    var productNumber = 0
    
    func getProduct() -> String {
        return mainCategories[productNumber].name
    }
}


