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
    private let addActionButton = UIButton(type: .contactAdd)
    
    var section: Int = 0
    var onAddButtonPressed: ((ActionHeaderView)->())?
    
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
        
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.bottom.equalTo(-10)
        }
        
        addActionButton.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.bottom.equalTo(-15)
        }
     
        addActionButton.addTarget(self, action: #selector(addButtonpRessed), for: .touchUpInside)
    }

    @objc private func addButtonpRessed() {
        onAddButtonPressed?(self)
    }
}
