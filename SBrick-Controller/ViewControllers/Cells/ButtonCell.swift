//
//  ButtonCell.swift
//  SBrick-Controller
//
//  Created by Barak Harel on 5/1/17.
//  Copyright © 2017 Barak Harel. All rights reserved.
//

import UIKit

class ButtonCell: UITableViewCell {
    
    static let reuseIdentifier = "ButtonCell"
    let progressView = UIProgressView(progressViewStyle: .default)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[progress(64)]", options: [], metrics: nil, views: ["progress":self.progressView]))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[progress]-14-|", options: [], metrics: nil, views: ["progress":self.progressView]))
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        progressView.setProgress(0, animated: false)
    }
}
