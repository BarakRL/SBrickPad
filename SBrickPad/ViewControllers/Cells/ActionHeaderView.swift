//
//  ActionHeaderView.swift
//  SBrickPad
//
//  Created by Barak Harel on 5/26/17.
//  Copyright © 2017 Barak Harel. All rights reserved.
//

import UIKit
import SnapKit

class ActionHeaderView: UIView {

    let titleLabel = UILabel(frame: .zero)
    private let addActionButton = UIButton(type: .contactAdd)
    
    var event: GameControllerButton.Event
    var onAddButtonPressed: ((ActionHeaderView)->())?
    
    init(event: GameControllerButton.Event) {
        self.event = event
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init(event: GameControllerButton.Event)")
    }
    
    func setup() {
        
        addSubview(titleLabel)
        addSubview(addActionButton)        
        
        titleLabel.font = UIFont.gillSans(size: 18)
        
        titleLabel.snp.makeConstraints { (make) in
            make.leftMargin.equalTo(16)
            make.bottom.equalTo(-10)
        }
        
        addActionButton.snp.makeConstraints { (make) in
            make.rightMargin.equalTo(-16)
            make.bottom.equalTo(-15)
        }
     
        addActionButton.addTarget(self, action: #selector(addButtonpRessed), for: .touchUpInside)
    }

    @objc private func addButtonpRessed() {
        onAddButtonPressed?(self)
    }
}
