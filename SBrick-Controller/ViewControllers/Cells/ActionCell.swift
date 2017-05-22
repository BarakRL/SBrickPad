//
//  DriveActionCell.swift
//  SBrick-Controller
//
//  Created by Barak Harel on 5/1/17.
//  Copyright © 2017 Barak Harel. All rights reserved.
//

import UIKit

class ActionCell: UITableViewCell {

    static let reuseIdentifier = "ActionCell"
    
    var action: GameControllerAction? {
        didSet {
            
            if let action = action {
                self.textLabel?.text = action.name
                self.detailTextLabel?.text = action.info
            }
            else {
                self.textLabel?.text = "No Action"
                self.detailTextLabel?.text = nil
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepareForReuse()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.textLabel?.text = nil
        self.detailTextLabel?.text = nil
    }    
    
}
