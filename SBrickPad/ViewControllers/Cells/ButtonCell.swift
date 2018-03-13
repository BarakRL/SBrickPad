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
        
        selectedBackgroundView = UIView() //clear
        selectedBackgroundView?.backgroundColor = #colorLiteral(red: 0.9917162061, green: 0.8454038501, blue: 0.003790777875, alpha: 1)
        
        textLabel?.font = UIFont.gillSansLight(size: 18)
        detailTextLabel?.font = UIFont.gillSansLight(size: 14)
        
        textLabel?.backgroundColor = UIColor.clear
        detailTextLabel?.backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        contentView.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        progressView.trackTintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[progress(64)]", options: [], metrics: nil, views: ["progress":self.progressView]))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[progress(1)]-14-|", options: [], metrics: nil, views: ["progress":self.progressView]))        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        progressView.setProgress(0, animated: false)
    }
    
}
