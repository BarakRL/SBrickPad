//
//  UIStoryboard+Ext.swift
//  SBrick-Controller
//
//  Created by Barak Harel on 5/1/17.
//  Copyright © 2017 Barak Harel. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    class func instantiateViewController<T: UIViewController>() -> T {
        
        let storyboardName = "Main"
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let identifier = NSStringFromClass(T.self).components(separatedBy: ".").last!
        let controller = storyboard.instantiateViewController(withIdentifier: identifier) as! T
        
        return controller
    }
}

extension UIViewController {
    
    class func instantiate() -> Self {
        return UIStoryboard.instantiateViewController()
    }
}
