//
//  Menu.swift
//  MyStyle
//
//  Created by 胡建明 on 2021/4/16.
//

import Foundation

struct Menu: Hashable {
    
    var name: String!
    var type: Bool!
    var meterials: Array<String>!
    var image: String!
    var chosen: Bool!
    
    init(name: String, type: Bool, meterials: Array<String>, image: String) {
        self.name = name
        self.type = type
        self.meterials = meterials
        self.image = image
        self.chosen = false
    }
}

struct Material:Hashable {
    var name: String
    var chosen: Bool!
    
    init(name: String) {
        self.name = name
        self.chosen = false
    }
    
}


