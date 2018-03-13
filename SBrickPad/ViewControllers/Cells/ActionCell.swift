//
//  DriveActionCell.swift
//  SBrickPad
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
                self.accessoryType = .disclosureIndicator
            }
            else {
                self.textLabel?.text = "No Actions"
                self.detailTextLabel?.text = nil
                self.accessoryType = .none
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textLabel?.font = UIFont.gillSansLight(size: 18)
        self.detailTextLabel?.font = UIFont.gillSansLight(size: 14)
        self.prepareForReuse()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.textLabel?.text = nil
        self.detailTextLabel?.text = nil
    }    
    
}
