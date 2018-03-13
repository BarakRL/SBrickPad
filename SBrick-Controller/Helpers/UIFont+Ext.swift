//
//  UIFont+Ext.swift
//  SBrick-Controller
//
//  Created by Barak Harel on 3/12/18.
//  Copyright © 2018 Barak Harel. All rights reserved.
//

import UIKit

extension UIFont {
        
    static func gillSans(size: CGFloat) -> UIFont {
        return UIFont(name: "GillSans", size: size)!
    }
    
    static func gillSansItalic(size: CGFloat) -> UIFont {
        return UIFont(name: "GillSans-Italic", size: size)!
    }
    
    static func gillSansBoldItalic(size: CGFloat) -> UIFont {
        return UIFont(name: "GillSans-BoldItalic", size: size)!
    }
    
    static func gillSansLight(size: CGFloat) -> UIFont {
        return UIFont(name: "GillSans-Light", size: size)!
    }
    
    static func gillSansLightItalic(size: CGFloat) -> UIFont {
        return UIFont(name: "GillSans-LightItalic", size: size)!
    }
    
    static func gillSansBold(size: CGFloat) -> UIFont {
        return UIFont(name: "GillSans-Bold", size: size)!
    }
    
}
