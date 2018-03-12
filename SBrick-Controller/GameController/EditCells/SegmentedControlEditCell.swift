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
        
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        addSubview(titleLabel)
        
        segmentedControl.addTarget(self, action: #selector(onSegmentedControlChange), for: .valueChanged)
        addSubview(segmentedControl)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.bottom.equalTo(0)
            make.right.equalTo(segmentedControl.snp.left).offset(-8)
        }
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        segmentedControl.snp.makeConstraints { (make) in
            make.right.equalTo(-20)
            make.centerY.equalTo(self)
        }
    }
    
    @objc private func onSegmentedControlChange() {        
        onChange()
    }
}
