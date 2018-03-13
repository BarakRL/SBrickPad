//
//  SelectSoundEditCell.swift
//  SBrickPad
//
//  Created by Barak Harel on 6/3/17.
//  Copyright © 2017 Barak Harel. All rights reserved.
//

import UIKit
import SnapKit

class SelectSoundEditCell: GameControllerActionEditCell, FilePickerViewControllerDelegate {

    var title: String = "File:" {
        didSet {
            titleLabel.text = title
        }
    }
    
    var filename: String? {
        didSet {
            selectSoundButton.setTitle(filename ?? "Select...", for: .normal)
        }
    }
    
    private var titleLabel = UILabel()
    var selectSoundButton = UIButton(type: .system)
    var clearSoundButton = UIButton(type: .system)
    
    override func setup() {
        super.setup()
        
        titleLabel.font = UIFont.gillSansLight(size: 14)
        titleLabel.text = self.title        
        contentView.addSubview(titleLabel)
        
        selectSoundButton.layer.cornerRadius = 5
        selectSoundButton.layer.borderColor = UIView.appearance().tintColor.cgColor
        selectSoundButton.layer.borderWidth = 1
        selectSoundButton.titleLabel?.font = UIFont.gillSans(size: 16)
        selectSoundButton.addTarget(self, action: #selector(onSelectSoundButtonPress), for: .touchUpInside)
        contentView.addSubview(selectSoundButton)
                
        clearSoundButton.setTitle("X", for: .normal)
        clearSoundButton.layer.cornerRadius = 5
        clearSoundButton.layer.borderColor = UIView.appearance().tintColor.cgColor
        clearSoundButton.layer.borderWidth = 1
        clearSoundButton.titleLabel?.font = UIFont.gillSans(size: 16)
        clearSoundButton.addTarget(self, action: #selector(onClearSoundButtonPress), for: .touchUpInside)
        contentView.addSubview(clearSoundButton)
        
        titleLabel.snp.makeConstraints { (make) in
            make.leftMargin.equalTo(8)
            make.top.bottom.equalTo(0)
            make.right.equalTo(selectSoundButton.snp.left).offset(-8)
        }
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        selectSoundButton.snp.makeConstraints { (make) in
            make.right.equalTo(clearSoundButton.snp.left).offset(-6)
            make.height.equalTo(36)
            make.centerY.equalTo(self)
        }
        
        clearSoundButton.snp.makeConstraints { (make) in
            make.rightMargin.equalTo(-8)
            make.height.equalTo(36)
            make.width.equalTo(clearSoundButton.snp.height) //square
            make.centerY.equalTo(self)
        }
    }
    
    @objc private func onClearSoundButtonPress() {
        
        self.filename = nil
        self.onChange()
    }
    
    @objc private func onSelectSoundButtonPress() {
        
        let filePicker = FilePickerViewController.instantiate()
        filePicker.identifier = "pickSound"
        filePicker.title = "Pick Sound"
        filePicker.fileExtensions = ["mp3", "wav"]
        filePicker.delegate = self
        
        let nav = UINavigationController(rootViewController: filePicker)        
        self.presentationDelegate?.present(nav)
    }
    
    func filePickerViewController(_ filePickerViewController: FilePickerViewController, didSelectFile file: URL) {
        
        filePickerViewController.dismiss(animated: true, completion: nil)
        self.filename = file.lastPathComponent
        self.onChange()
    }

}
