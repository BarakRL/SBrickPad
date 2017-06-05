//
//  SelectSoundEditCell.swift
//  SBrick-Controller
//
//  Created by Barak Harel on 6/3/17.
//  Copyright © 2017 Barak Harel. All rights reserved.
//

import UIKit
import SnapKit

class SelectSoundEditCell: GameControllerActionEditCell, FilePickerViewControllerDelegate {

    override class var reuseIdentifier: String {
        return "SelectSoundEditCell"
    }
    
    var fileName: String = "" {
        didSet {
            selectSoundButton.setTitle(fileName, for: .normal)
        }
    }
    
    var loop: Bool = false {
        didSet {
            loopSwitch.isOn = loop
        }
    }
    
    var selectSoundButton = UIButton(type: .system)
    var loopSwitch = UISwitch()
    
    override func setup() {
        super.setup()
        
        selectSoundButton.layer.cornerRadius = 5
        selectSoundButton.layer.borderColor = selectSoundButton.tintColor.cgColor
        selectSoundButton.layer.borderWidth = 1
        selectSoundButton.addTarget(self, action: #selector(onSelectSoundButtonPress), for: .touchUpInside)
        
        addSubview(selectSoundButton)
        
        loopSwitch.addTarget(self, action: #selector(onLoopSwitchChange), for: .valueChanged)
        addSubview(loopSwitch)
        
        selectSoundButton.snp.makeConstraints { (make) in
            make.left.equalTo(12)
            make.right.equalTo(loopSwitch.snp.left).offset(-12)
            make.top.equalTo(6)
            make.bottom.equalTo(-6)
        }
        
        loopSwitch.snp.makeConstraints { (make) in
            make.right.equalTo(-12)
            make.centerY.equalTo(self)
        }
    }
    
    func onLoopSwitchChange() {
        
        self.loop = self.loopSwitch.isOn
        onChange()
    }
    
    func onSelectSoundButtonPress() {
        
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
        self.fileName = file.lastPathComponent
        self.onChange()
    }

}
