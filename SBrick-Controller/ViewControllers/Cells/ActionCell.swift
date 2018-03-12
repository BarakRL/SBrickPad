//
//  DriveActionCell.swift
//  SBrick-Controller
//
//  Created by Barak Harel on 5/1/17.
//  Copyright © 2017 Barak Harel. All rights reserved.
//

import UIKit

class ActionCell: UITableViewCell {
    
    var action: GameControllerAction? {
        didSet {
            
            if let action = action {
                self.textLabel?.text = action.name
                self.detailTextLabel?.text = action.info
            }
            else {
                self.textLabel?.text = "No Actions"
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
