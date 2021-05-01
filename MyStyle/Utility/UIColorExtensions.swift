//
//  UIColorExtensions.swift
//  UICollectionViewHorizontalScroll
//
//  Created by 胡建明 on 2021/4/14.
//

import UIKit

extension UIColor {
    class func randomColor() -> UIColor {
        
        let red = CGFloat(arc4random() % 100) / 100
        let green = CGFloat(arc4random() % 100) / 100
        let blue = CGFloat(arc4random() % 100) / 100

        return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
    }
}
