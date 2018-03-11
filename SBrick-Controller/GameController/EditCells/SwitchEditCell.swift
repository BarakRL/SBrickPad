//
//  SwitchEditCell.swift
//  SBrick-Controller
//
//  Created by Barak Harel on 3/11/18.
//  Copyright © 2018 Barak Harel. All rights reserved.
//

import UIKit
import SnapKit

class SwitchEditCell: GameControllerActionEditCell {

    var title: String = "Action:" {
        didSet {
            actionLabel.text = title
        }
    }
    
    var isOn: Bool = false {
        didSet {
            actionSwitch.isOn = isOn
        }
    }
    
    var actionSwitch = UISwitch()
    var actionLabel = UILabel()
    
    override func setup() {
        super.setup()
        
        actionLabel.font = UIFont.systemFont(ofSize: 12)
        addSubview(actionLabel)
        
        actionSwitch.addTarget(self, action: #selector(onActionSwitchChange), for: .valueChanged)
        addSubview(actionSwitch)
        
        actionLabel.snp.makeConstraints { (make) in
            make.left.equalTo(12)
            make.top.bottom.equalTo(0)
            make.right.equalTo(actionSwitch.snp.left).offset(-8)
        }
        
        actionSwitch.snp.makeConstraints { (make) in
            make.right.equalTo(-12)
            make.centerY.equalTo(self)
        }
    }
    
    @objc private func onActionSwitchChange() {
        
        self.isOn = self.actionSwitch.isOn
        onChange()
    }
}
