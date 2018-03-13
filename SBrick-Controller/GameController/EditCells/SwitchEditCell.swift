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
        
        titleLabel.font = UIFont.gillSansLight(size: 14)
        titleLabel.text = self.title
        addSubview(titleLabel)
        
        actionSwitch.onTintColor = #colorLiteral(red: 0.005186316557, green: 0.5101435184, blue: 0.6784499288, alpha: 1)
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
