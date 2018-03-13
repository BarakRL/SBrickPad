//
//  UITable+Ext.swift
//  SBrickPad
//
//  Created by Barak Harel on 3/11/18.
//  Copyright © 2018 Barak Harel. All rights reserved.
//

import UIKit

extension UITableViewCell {

    @objc static var identifier: String {
        return String(describing: self)
    }
    
    @objc class func register(in tableView: UITableView) {
        tableView.register(self, forCellReuseIdentifier: identifier)
    }
    
    @objc class func dequeue(for tableView: UITableView, at indexPath: IndexPath) -> Self {
        return _cell(dequeuedFor: tableView, indexPath: indexPath)
    }
    
    private class func _cell<T : UITableViewCell>(dequeuedFor tableView: UITableView, indexPath: IndexPath) -> T {
        
        let identifier = T.identifier
        return tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! T
    }
}
