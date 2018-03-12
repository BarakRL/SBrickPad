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
            titleLabel.text = title
        }
    }
    
    var isOn: Bool {
        get {
            return actionSwitch.isOn
        }
        set {
            actionSwitch.isOn = newValue
        }
    }
    
    private var actionSwitch = UISwitch()
    private var titleLabel = UILabel()
    
    override func setup() {
        super.setup()
        
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        addSubview(titleLabel)
        
        actionSwitch.addTarget(self, action: #selector(onActionSwitchChange), for: .valueChanged)
        addSubview(actionSwitch)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.bottom.equalTo(0)
            make.right.equalTo(actionSwitch.snp.left).offset(-8)
        }
        
        actionSwitch.snp.makeConstraints { (make) in
            make.right.equalTo(-20)
            make.centerY.equalTo(self)
        }
    }
    
    @objc private func onActionSwitchChange() {
        onChange()
    }
}
