//
//  NoActionCell.swift
//  SBrick-Controller
//
//  Created by Barak Harel on 5/1/17.
//  Copyright © 2017 Barak Harel. All rights reserved.
//

import UIKit

class NoActionCell: UITableViewCell {
    
    static let reuseIdentifier = "NoActionCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textLabel?.text = "No action selected"
    }
    
}
