//
//  Data.swift
//  MyStyle
//
//  Created by 胡建明 on 2021/4/16.
//

import Foundation

var menus: [Menu] = [
    Menu(name: "西红柿炒鸡蛋", type: true, meterials: [materials[0], materials[1]], imagePath: "tomato_scrambled_eggs"),
    Menu(name: "炒青菜", type: true, meterials: [materials[2]], imagePath: "stir_fried_vegetables"),
    Menu(name: "酸辣土豆丝", type: true, meterials: [materials[3]], imagePath: "potato_floss"),
    Menu(name: "酸辣汤", type: false, meterials: [materials[4], materials[5], materials[6], materials[1]], imagePath: "sour_soup_with_beef"),
    Menu(name: "地三鲜", type: true, meterials: [materials[3], materials[7], materials[8]], imagePath: "di_sanxian"),
    Menu(name: "雪菜黄鱼汤", type: false, meterials: [materials[9], materials[10], materials[5]], imagePath: "pickled_vegetable_yellow_fish_soup"),
    Menu(name: "罗宋汤", type: false, meterials: [materials[11], materials[3], materials[12], materials[0]], imagePath: "borscht"),
    Menu(name: "萝卜焖牛腩", type: false, meterials: [materials[13], materials[11], materials[14]], imagePath:  "stewed_beef_brisket_with_radish"),
    Menu(name: "糖醋排骨", type: true, meterials: [materials[15]], imagePath: "sweet_and_sour_short_ribs"),
    Menu(name: "可乐鸡翅", type: true, meterials: [materials[16], materials[17]], imagePath: "coke_chicken_wings"),
    Menu(name:  "丝瓜炒鸡蛋", type: true, meterials: [materials[18], materials[1]], imagePath: "scrambled_eggs_with_loofah"),
    Menu(name: "家常红烧肉", type: true, meterials: [materials[4]], imagePath: "braised_pork"),
    Menu(name: "麻辣大闸蟹", type: true, meterials: [materials[19], materials[20], materials[21], materials[22]], imagePath: "spicy_hairy_crab"),
    Menu(name: "酸汤肥牛", type: false, meterials: [materials[23], materials[24], materials[25]], imagePath: "sour_soup_with_beef"),
    Menu(name: "水煮牛肉", type: false, meterials: [materials[23], materials[14], materials[1]], imagePath: "boiled_beef"),
    Menu(name: "水煮肉片", type: false, meterials: [materials[4], materials[14], materials[1]], imagePath: "poached_pork_slices"),
    Menu(name: "蒜泥白肉", type: true, meterials: [materials[4], materials[22]], imagePath: "garlic_white_meat"),
    Menu(name:  "农家小炒肉", type: true, meterials: [materials[4], materials[26]], imagePath: "fried_pork"),
    Menu(name: "木须肉", type: true, meterials: [materials[4], materials[1], materials[27], materials[28]], imagePath: "mushu_meat"),
    Menu(name:  "回锅肉", type: true, meterials: [materials[29], materials[30]], imagePath: "twice_cooked_pork")
]

var materials: [Material] = [
    Material(name: "西红柿", count: 2),
    Material(name: "鸡蛋", count: 6),
    Material(name: "青菜"),
    Material(name: "土豆", count: 3),
    Material(name: "猪肉", count: 6),
    Material(name: "豆腐", count: 2),
    Material(name: "香菇"),
    Material(name: "茄子"),
    Material(name: "菜椒"),
    Material(name: "雪菜"),
    Material(name: "黄鱼"),
    Material(name: "牛腩", count: 2),
    Material(name: "红肠"),
    Material(name: "萝卜"),
    Material(name: "郫县豆瓣酱", count: 3),
    Material(name: "肋排"),
    Material(name: "鸡翅"),
    Material(name: "可乐"),
    Material(name: "丝瓜"),
    Material(name: "大闸蟹"),
    Material(name: "八角"),
    Material(name: "干辣椒"),
    Material(name: "大蒜",count: 2),
    Material(name: "牛肉",count: 2),
    Material(name: "金针菇"),
    Material(name: "泡椒"),
    Material(name: "辣椒"),
    Material(name: "甜椒"),
    Material(name: "黑木耳"),
    Material(name: "五花肉"),
    Material(name: "尖椒"),
]
