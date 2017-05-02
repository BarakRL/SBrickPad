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
    
    var action: GameControllerAction! {
        didSet {
            guard let action = action else { return }
            
            self.textLabel?.text = action.name
            self.detailTextLabel?.text = action.description
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
