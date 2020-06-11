//
//  HelperFunctions.swift
//  OnlineShop
//
//  Created by Камиль on 11.06.2020.
//  Copyright © 2020 Kamil. All rights reserved.
//

import Foundation

func convertToCurrency(_ number: Double) -> String {
    
    let currencyFormatter = NumberFormatter()
    currencyFormatter.usesGroupingSeparator = true
    currencyFormatter.maximumFractionDigits = 0 //округляем цены до целых чисел
    currencyFormatter.numberStyle = .currency
    currencyFormatter.locale = Locale(identifier: "ru_RU")
    
    return currencyFormatter.string(from: NSNumber(value:number))!
}


