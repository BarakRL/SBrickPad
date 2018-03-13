//
//  SegmentedControlEditCell.swift
//  SBrick-Controller
//
//  Created by Barak Harel on 3/11/18.
//  Copyright © 2018 Barak Harel. All rights reserved.
//

import UIKit
import SnapKit

class SegmentedControlEditCell: GameControllerActionEditCell {
    
    var title: String = "Action:" {
        didSet {
            titleLabel.text = title
        }
    }
    
    var values: [String] = [] {
        didSet {
            self.segmentedControl.removeAllSegments()
            for i in 0..<values.count {
                self.segmentedControl.insertSegment(withTitle: values[i], at: i, animated: false)
            }
        }
    }
    
    var selectedSegmentIndex: Int {
        get {
            return self.segmentedControl.selectedSegmentIndex
        }
        set {
            self.segmentedControl.selectedSegmentIndex = newValue
        }
    }
    
    private var segmentedControl = UISegmentedControl()
    private var titleLabel = UILabel()
    
    override func setup() {
        super.setup()
        
        titleLabel.font = UIFont.gillSansLight(size: 14)
        titleLabel.text = self.title
        contentView.addSubview(titleLabel)
        segmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.gillSans(size: 14)], for: .normal)
        segmentedControl.addTarget(self, action: #selector(onSegmentedControlChange), for: .valueChanged)
        contentView.addSubview(segmentedControl)
        
        titleLabel.snp.makeConstraints { (make) in
            make.leftMargin.equalTo(8)
            make.top.bottom.equalTo(0)
            make.right.equalTo(segmentedControl.snp.left).offset(-8)
        }
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        segmentedControl.snp.makeConstraints { (make) in
            make.rightMargin.equalTo(-8)
            make.centerY.equalTo(self)
        }
    }
    
    @objc private func onSegmentedControlChange() {        
        onChange()
    }
}
