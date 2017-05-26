//
//  ActionHeaderView.swift
//  SBrick-Controller
//
//  Created by Barak Harel on 5/26/17.
//  Copyright © 2017 Barak Harel. All rights reserved.
//

import UIKit
import SnapKit

class ActionHeaderView: UIView {

    let titleLabel = UILabel(frame: .zero)
    let addActionButton = UIButton(type: .contactAdd)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        
        addSubview(titleLabel)
        addSubview(addActionButton)
        
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightLight)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.bottom.equalTo(-10)
        }
        
        addActionButton.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.bottom.equalTo(-15)
        }
    }

}
