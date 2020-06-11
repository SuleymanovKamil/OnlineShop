//
//  Catalog.swift
//  OnlineShop
//
//  Created by Камиль on 28.05.2020.
//  Copyright © 2020 Kamil. All rights reserved.
//

import UIKit
//Каталог для главного экрана
class Category {
    var id: String
    var name: String
    var image: UIImage?
    var imageName: String?
    
    init(_name: String, _imageName: String) {
        id = ""
        name = _name
        imageName = _imageName
        image = UIImage(named: _imageName)
    }
    
    init(_dictionary: NSDictionary) {
        id = _dictionary[K.FireBase.OBJECTID] as! String
        name = _dictionary[K.FireBase.NAME] as! String
        image = UIImage(named: _dictionary[K.FireBase.IMAGENAME] as? String ?? "")
    }
}
//MARK: - Download categgory from Firebase
func downloadCategories(completion: @escaping (_ categoryArray: [Category]) -> Void) {
    var categoryArray: [Category] = []
    FirebaseRefeerense(.Category).getDocuments { (snapshot, error) in
        guard let snapshot = snapshot else {
            completion(categoryArray)
            return
        }
        if !snapshot.isEmpty {
            for categoryDict in snapshot.documents {
                categoryArray.append(Category(_dictionary: categoryDict.data() as NSDictionary))
            }
        }
        completion(categoryArray)
    }
}



//MARK: - Save category to Firebase function

func SaveCategoryToFirebase(_ category: Category) {
    let id = UUID().uuidString
    category.id = id
    
    FirebaseRefeerense(.Category).document(id).setData(categoryDictionaryFrom(category) as! [String : Any])
}

//MARK: - Helpers
func categoryDictionaryFrom(_ category: Category) ->NSDictionary {
    
    return NSDictionary(objects: [category.id, category.name, category.imageName!], forKeys: [K.FireBase.OBJECTID as NSCopying,
                                                                                             K.FireBase.NAME  as NSCopying,
                                                                                             K.FireBase.IMAGENAME  as NSCopying ])
}

//use onle one time
//func createCategorySet() {
//    let milk = Category(_name: "Молочные продукты и яйца", _imageName: "milk")
//    let fruits = Category(_name: "Овощи и фрукты", _imageName: "fruits")
//    let meat = Category(_name: "Мясные продукты", _imageName: "meat")
//    let frozen = Category(_name: "Замороженные продукты", _imageName: "frozen")
//    let grocery = Category(_name: "Бакалея", _imageName: "grocery")
//    let bread = Category(_name: "Хлеб и выпечка", _imageName: "bread")
//    let fish = Category(_name: "Рыба и морепродукты", _imageName: "fish")
//    let coffee = Category(_name: "Кофе и чай", _imageName: "coffee")
//    let sweets = Category(_name: "Напитки", _imageName: "sweets")
//    let sauce = Category(_name: "Соусы, консервы, соленья", _imageName: "sauce")
//    let hygiene = Category(_name: "Гигиена и бытовая химия", _imageName: "hygiene")
//    let animals = Category(_name: "Товары для животных", _imageName: "animals")
//    let children = Category(_name: "Товары для детей", _imageName: "children")
//    let home = Category(_name: "Товары для дома", _imageName: "home")
//    let food = Category(_name: "Готовая продукция", _imageName: "food")
//
//    let arraysOfCategories = [milk, fruits, meat, frozen, grocery, bread, fish, coffee, sweets, sauce, hygiene, animals, children, home, food]
//
//    for category in arraysOfCategories {
//        saveCategoryToFirebase(category)
//    }
//}
