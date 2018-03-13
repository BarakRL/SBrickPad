//
//  SliderEditCell.swift
//  SBrick-Controller
//
//  Created by Barak Harel on 3/11/18.
//  Copyright © 2018 Barak Harel. All rights reserved.
//

import Foundation
import SnapKit

class SliderEditCell: GameControllerActionEditCell {
    
    var title: String = "Action:" {
        didSet {
            titleLabel.text = title
        }
    }
    
    var value: UInt8 {
        get {
            return UInt8(slider.value)
        }
        set {
            slider.value = Float(newValue)
            valueLabel.text = "\(value)"
        }
    }
    
    private var slider = UISlider()
    private var titleLabel = UILabel()
    private var valueLabel = UILabel()
    
    override func setup() {
        super.setup()
        
        titleLabel.font = UIFont.gillSansLight(size: 14)
        titleLabel.text = self.title
        contentView.addSubview(titleLabel)
        
        slider.minimumValue = Float(UInt8.min)
        slider.maximumValue = Float(UInt8.max)
        
        slider.addTarget(self, action: #selector(onSliderChange), for: .valueChanged)
        contentView.addSubview(slider)
        
        valueLabel.font = UIFont.gillSansLight(size: 14)
        valueLabel.textAlignment = .right
        contentView.addSubview(valueLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.leftMargin.equalTo(8)
            make.top.bottom.equalTo(0)
            make.right.equalTo(slider.snp.left).offset(-8)
        }
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        slider.snp.makeConstraints { (make) in
            make.right.equalTo(valueLabel.snp.left).offset(-5)
            make.centerY.equalTo(self)
        }
        
        valueLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.rightMargin.equalTo(-8)
            make.width.equalTo(30)
        }
    }
    
    @objc private func onSliderChange() {
        valueLabel.text = "\(value)"
        onChange()
    }
}
