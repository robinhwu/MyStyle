//
//  Menu.swift
//  MyStyle
//
//  Created by 胡建明 on 2021/4/16.
//

import Foundation

struct MenuData: Hashable {
    
    var name: String!
    var type: Bool!
    var materialData: Array<MaterialData>!
    var imageName: String!
    var chosen: Bool!
    var isPreload: Bool!
    
    init(name: String, type: Bool, meterials: Array<MaterialData>, imageName: String) {
        self.name = name
        self.type = type
        self.materialData = meterials
        self.imageName = imageName
        self.chosen = false
        self.isPreload = true
    }
}

struct MaterialData:Hashable {
    var name: String
    var count: Int
    var chosen: Bool
    
    init(name: String) {
        self.name = name
        self.count = 0
        self.chosen = false
    }
}


