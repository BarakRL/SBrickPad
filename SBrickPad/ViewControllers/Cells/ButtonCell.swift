//
//  ButtonCell.swift
//  SBrickPad
//
//  Created by Barak Harel on 5/1/17.
//  Copyright © 2017 Barak Harel. All rights reserved.
//

import UIKit

class ButtonCell: UITableViewCell {
    
    let progressView = UIProgressView(progressViewStyle: .default)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.textLabel?.font = UIFont.gillSansLight(size: 18)
        self.detailTextLabel?.font = UIFont.gillSansLight(size: 14)
        
        contentView.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = #colorLiteral(red: 0.9917162061, green: 0.8454038501, blue: 0.003790777875, alpha: 1)
            
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[progress(64)]", options: [], metrics: nil, views: ["progress":self.progressView]))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[progress]-14-|", options: [], metrics: nil, views: ["progress":self.progressView]))
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        progressView.setProgress(0, animated: false)
    }
}
