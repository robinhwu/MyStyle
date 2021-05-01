//
//  Data.swift
//  MyStyle
//
//  Created by 胡建明 on 2021/4/16.
//

import Foundation

var menus: [Menu] = [
    Menu(name: "西红柿炒鸡蛋", type: true, meterials: ["西红柿", "鸡蛋"], image: "tomato_scrambled_eggs"),
    Menu(name: "炒青菜", type: true, meterials: ["青菜"], image: "stir_fried_vegetables"),
    Menu(name: "酸辣土豆丝", type: true, meterials: ["土豆"], image: "potato_floss"),
    Menu(name: "酸辣汤", type: false, meterials: ["猪肉", "豆腐", "香菇", "鸡蛋"], image: "sour_soup_with_beef"),
    Menu(name: "地三鲜", type: true, meterials: ["土豆", "茄子", "菜椒"], image: "di_sanxian"),
    Menu(name: "雪菜黄鱼豆腐汤", type: false, meterials: ["雪菜", "黄鱼", "豆腐"], image: "pickled_vegetable_yellow_fish_soup"),
    Menu(name: "罗宋汤", type: false, meterials: ["牛腩", "土豆", "红肠", "西红柿"], image: "borscht"),
    Menu(name: "萝卜焖牛腩", type: false, meterials: ["萝卜", "牛腩", "郫县豆瓣酱"], image:  "stewed_beef_brisket_with_radish"),
    Menu(name: "糖醋排骨", type: true, meterials: ["肋排"], image: "sweet_and_sour_short_ribs"),
    Menu(name: "可乐鸡翅", type: true, meterials: ["鸡翅", "可乐"], image: "coke_chicken_wings"),
    Menu(name:  "丝瓜炒鸡蛋", type: true, meterials: ["丝瓜", "鸡蛋"], image: "scrambled_eggs_with_loofah"),
    Menu(name: "家常红烧肉", type: true, meterials: ["猪肉"], image: "braised_pork"),
    Menu(name: "麻辣大闸蟹", type: true, meterials: ["大闸蟹", "八角", "干辣椒", "大蒜"], image: "spicy_hairy_crab"),
    Menu(name: "酸汤肥牛金针菇", type: false, meterials: ["牛肉", "金针菇", "泡椒"], image: "sour_soup_with_beef"),
    Menu(name: "水煮牛肉", type: false, meterials: ["牛肉", "郫县豆瓣酱", "鸡蛋"], image: "boiled_beef"),
    Menu(name: "水煮肉片", type: false, meterials: ["猪肉", "郫县豆瓣酱", "鸡蛋"], image: "poached_pork_slices"),
    Menu(name: "蒜泥白肉", type: true, meterials: ["猪肉", "大蒜"], image: "garlic_white_meat"),
    Menu(name:  "农家小炒肉", type: true, meterials: ["猪肉", "辣椒"], image: "fried_pork"),
    Menu(name: "木须肉", type: true, meterials: ["猪肉", "鸡蛋", "甜椒", "黑木耳"], image: "mushu_meat"),
    Menu(name:  "回锅肉", type: true, meterials: ["五花肉", "尖椒"], image: "twice_cooked_pork")
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
