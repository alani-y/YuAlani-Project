// Project: YuAlani-Project
// EID: ay7892
// Course: CS329E//
//  Item.swift
//  YuAlani-Project
//
//  Created by Alani Yu on 4/7/25.
//

import Foundation

class Item{
    
    var price: Int
    var name: String
    var hasPaid: Bool
    
    init(name: String, price: Int, hasPaid: Bool){
        self.name = name
        self.price = price
        self.hasPaid = hasPaid
    }
    
    func displayItem(){
        print("\(self.name), \(self.price) credits, paid: \(self.hasPaid)")
    }
}
