//
//  UIColorExtensions.swift
//  UICollectionViewHorizontalScroll
//
//  Created by 胡建明 on 2021/4/14.
//

import UIKit

extension UIColor {
    class func randomColor() -> UIColor {
        
        let hue = CGFloat(arc4random() % 100) / 100
        let saturation = CGFloat(arc4random() % 100) / 100
        let brightness = CGFloat(arc4random() % 100) / 100
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }
}
