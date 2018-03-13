//
//  SwitchEditCell.swift
//  SBrickPad
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
        
        titleLabel.font = UIFont.gillSansLight(size: 14)
        titleLabel.text = self.title
        contentView.addSubview(titleLabel)
        
        actionSwitch.onTintColor = #colorLiteral(red: 0.01943824254, green: 0.6778953671, blue: 0.9364978671, alpha: 1)
        actionSwitch.addTarget(self, action: #selector(onActionSwitchChange), for: .valueChanged)
        contentView.addSubview(actionSwitch)
        
        titleLabel.snp.makeConstraints { (make) in
            make.leftMargin.equalTo(8)
            make.top.bottom.equalTo(0)
            make.right.equalTo(actionSwitch.snp.left).offset(-8)
        }
        
        actionSwitch.snp.makeConstraints { (make) in
            make.rightMargin.equalTo(-8)
            make.centerY.equalTo(self)
        }
    }
    
    @objc private func onActionSwitchChange() {
        onChange()
    }
}
