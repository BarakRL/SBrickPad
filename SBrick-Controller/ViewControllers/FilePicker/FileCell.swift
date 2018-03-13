//
//  FileCell.swift
//  SBrick-Controller
//
//  Created by Barak Harel on 5/27/17.
//  Copyright © 2017 Barak Harel. All rights reserved.
//

import UIKit

class FileCell: UITableViewCell {
        
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textLabel?.font = UIFont.gillSansLight(size: 18)
        self.detailTextLabel?.font = UIFont.gillSansLight(size: 14)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.textLabel?.text = nil
        self.detailTextLabel?.text = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
