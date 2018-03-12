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

    var filename: String? {
        didSet {
            selectSoundButton.setTitle(filename ?? "Select...", for: .normal)
        }
    }
    
    var selectSoundButton = UIButton(type: .system)
    var clearSoundButton = UIButton(type: .system)
    
    override func setup() {
        super.setup()
        
        selectSoundButton.layer.cornerRadius = 5
        selectSoundButton.layer.borderColor = selectSoundButton.tintColor.cgColor
        selectSoundButton.layer.borderWidth = 1
        selectSoundButton.addTarget(self, action: #selector(onSelectSoundButtonPress), for: .touchUpInside)
        addSubview(selectSoundButton)
                
        clearSoundButton.setTitle("X", for: .normal)
        clearSoundButton.layer.cornerRadius = 5
        clearSoundButton.layer.borderColor = clearSoundButton.tintColor.cgColor
        clearSoundButton.layer.borderWidth = 1
        clearSoundButton.addTarget(self, action: #selector(onClearSoundButtonPress), for: .touchUpInside)
        addSubview(clearSoundButton)
        
        selectSoundButton.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(clearSoundButton.snp.left).offset(-6)
            make.top.equalTo(6)
            make.bottom.equalTo(-6)
        }
        
        clearSoundButton.snp.makeConstraints { (make) in
            make.right.equalTo(-20)
            make.top.equalTo(6)
            make.bottom.equalTo(-6)
            make.height.equalTo(clearSoundButton.snp.width) //square
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
