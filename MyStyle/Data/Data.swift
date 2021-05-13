//
//  Data.swift
//  MyStyle
//
//  Created by 胡建明 on 2021/4/16.
//

import Foundation

var menus: [Menu] = []
var materials: [Material] = []

var menusData: [MenuData] = [
    MenuData(name: "西红柿炒鸡蛋", type: true, meterials: [materialsData[0], materialsData[1]], imageName: "tomato_scrambled_eggs"),
    MenuData(name: "炒青菜", type: true, meterials: [materialsData[2]], imageName: "stir_fried_vegetables"),
    MenuData(name: "酸辣土豆丝", type: true, meterials: [materialsData[3]], imageName: "potato_floss"),
    MenuData(name: "酸辣汤", type: false, meterials: [materialsData[4], materialsData[5], materialsData[6], materialsData[1]], imageName: "sour_soup_with_beef"),
    MenuData(name: "地三鲜", type: true, meterials: [materialsData[3], materialsData[7], materialsData[8]], imageName: "di_sanxian"),
    MenuData(name: "雪菜黄鱼汤", type: false, meterials: [materialsData[9], materialsData[10], materialsData[5]], imageName: "pickled_vegetable_yellow_fish_soup"),
    MenuData(name: "罗宋汤", type: false, meterials: [materialsData[11], materialsData[3], materialsData[12], materialsData[0]], imageName: "borscht"),
    MenuData(name: "萝卜焖牛腩", type: false, meterials: [materialsData[13], materialsData[11], materialsData[14]], imageName:  "stewed_beef_brisket_with_radish"),
    MenuData(name: "糖醋排骨", type: true, meterials: [materialsData[15]], imageName: "sweet_and_sour_short_ribs"),
    MenuData(name: "可乐鸡翅", type: true, meterials: [materialsData[16], materialsData[17]], imageName: "coke_chicken_wings"),
    MenuData(name:  "丝瓜炒鸡蛋", type: true, meterials: [materialsData[18], materialsData[1]], imageName: "scrambled_eggs_with_loofah"),
    MenuData(name: "家常红烧肉", type: true, meterials: [materialsData[4]], imageName: "braised_pork"),
    MenuData(name: "麻辣大闸蟹", type: true, meterials: [materialsData[19], materialsData[20], materialsData[21], materialsData[22]], imageName: "spicy_hairy_crab"),
    MenuData(name: "酸汤肥牛", type: false, meterials: [materialsData[23], materialsData[24], materialsData[25]], imageName: "sour_soup_with_beef"),
    MenuData(name: "水煮牛肉", type: false, meterials: [materialsData[23], materialsData[14], materialsData[1]], imageName: "boiled_beef"),
    MenuData(name: "水煮肉片", type: false, meterials: [materialsData[4], materialsData[14], materialsData[1]], imageName: "poached_pork_slices"),
    MenuData(name: "蒜泥白肉", type: true, meterials: [materialsData[4], materialsData[22]], imageName: "garlic_white_meat"),
    MenuData(name:  "农家小炒肉", type: true, meterials: [materialsData[4], materialsData[26]], imageName: "fried_pork"),
    MenuData(name: "木须肉", type: true, meterials: [materialsData[4], materialsData[1], materialsData[27], materialsData[28]], imageName: "mushu_meat"),
    MenuData(name:  "回锅肉", type: true, meterials: [materialsData[29], materialsData[30]], imageName: "twice_cooked_pork")
]

var materialsData: [MaterialData] = [
    MaterialData(name: "西红柿"),
    MaterialData(name: "鸡蛋"),
    MaterialData(name: "青菜"),
    MaterialData(name: "土豆"),
    MaterialData(name: "猪肉"),
    MaterialData(name: "豆腐"),
    MaterialData(name: "香菇"),
    MaterialData(name: "茄子"),
    MaterialData(name: "菜椒"),
    MaterialData(name: "雪菜"),
    MaterialData(name: "黄鱼"),
    MaterialData(name: "牛腩"),
    MaterialData(name: "红肠"),
    MaterialData(name: "萝卜"),
    MaterialData(name: "郫县豆瓣酱"),
    MaterialData(name: "肋排"),
    MaterialData(name: "鸡翅"),
    MaterialData(name: "可乐"),
    MaterialData(name: "丝瓜"),
    MaterialData(name: "大闸蟹"),
    MaterialData(name: "八角"),
    MaterialData(name: "干辣椒"),
    MaterialData(name: "大蒜"),
    MaterialData(name: "牛肉"),
    MaterialData(name: "金针菇"),
    MaterialData(name: "泡椒"),
    MaterialData(name: "辣椒"),
    MaterialData(name: "甜椒"),
    MaterialData(name: "黑木耳"),
    MaterialData(name: "五花肉"),
    MaterialData(name: "尖椒"),
]
